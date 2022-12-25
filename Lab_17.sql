-- JOB
-- Раз в неделю в определенное время выполняется копирование части данных по условию из одной таблицы в другую, после чего эти данные из первой таблицы удаляются.
create table Persons
(
    id number primary key,
    name varchar2(20)
);

create table Persons_backup
(
    id number primary key,
    name varchar2(20)
);

create table backup_state
(
    datetime date,
    state nvarchar2(10)
);

declare
    id number(10) := 1;
    name varchar(20);
begin
    while(id <= 100)
    loop
        name := concat('PersonValue_', to_char(id));
        insert into Persons(id, name) values (id, name);
        id := id + 1;
    end loop;
    commit;
end;

select * from Persons;

drop table Persons;
drop table Persons_backup;
drop table backup_state;

create or replace package mydbms_job
as
    procedure newJob;
    procedure newBackup;
    procedure executing;
    procedure stopExecuting;
    procedure setDate(newDate date);
    procedure deleteJob;
end;

drop package mydbms_job;

create or replace package body mydbms_job
    as
    procedure newJob
        as
        begin
        dbms_job.ISUBMIT(job => 1,
                         what => 'begin mydbms_job.newBackup; end;',
                         next_date => sysdate,
                         interval =>'trunc(sysdate + 7) + 15*60*60/86400'); -- интервал между запусками задания (в данном случае - раз в неделю) - 15*60*60/86400 - 15 часов в секундах / 86400 - количество секунд в сутках
        end;

    procedure newBackup
        as
        begin
        insert into Persons_backup select * from Persons where id > 66;
        delete Persons where id > 66;
        insert into backup_state(datetime, state) values (sysdate, 'выполнен');
        commit;
            exception when others
            then insert into backup_state(datetime, state) values (sysdate, 'ошибка');
        end;

    procedure executing is              -- проверка на наличие задания в очереди заданий
        curjob user_jobs.what % type;   -- тип данных, возвращаемый функцией WHAT
    begin
        select (select what from user_jobs
                where what = 'begin mydbms_job.newBackup; end;' and user_jobs.broken = 'N')
        into curjob from dual;         -- broken - статус задания (N - задание не испорчено, Y - задание испорчено)
        if curjob is not null then
            DBMS_OUTPUT.PUT_LINE('выполняется');
        else
            DBMS_OUTPUT.PUT_LINE('не выполняется');
        end if;
    end;

    procedure stopExecuting
        as
    begin
        dbms_job.broken(1, TRUE);
        commit;
    end;

    procedure setDate(newDate date) as
    begin
        DBMS_JOB.change(job => 1,
                        what => 'begin jobs_pack.manipulate; end;',
                        next_date => newDate,
                        interval =>'trunc(sysdate + 7) + 15*60*60/86400');
        commit;
    end;

        procedure deleteJob as
    begin
        dbms_job.remove(1);
        commit;
    end;
end;

begin
    mydbms_job.newJob();
    dbms_job.run(1);
    mydbms_job.executing();
    insert into Persons (id, name) values (19, 'New_Value');
    commit;
end;

delete from Persons where id=67;
select * from user_jobs;
select * from Persons;
select * from Persons_backup;
select * from backup_state;

begin
    mydbms_job.setDate(sysdate + 1);    -- изменение даты и времени первого запуска задания на текущее время + 1 день
end;

select * from user_jobs;

begin
    mydbms_job.stopexecuting();
    mydbms_job.executing();
    mydbms_job.deletejob();
end;

select * from user_jobs;


-- DBMS_SHEDULER
create or replace package mydbms_sheduler
as
    procedure newJob;
    procedure newBackup;
    procedure executing;
    procedure stopExecuting;
    procedure setDate(newDate date);
    procedure deleteJob;
end;

drop package mydbms_sheduler;

create or replace package body mydbms_sheduler
as
    procedure newJob as
    begin
        dbms_scheduler.create_schedule(
                schedule_name => 'schedule',
                start_date => sysdate,
                repeat_interval => 'FREQ=WEEKLY;'
            );
        dbms_scheduler.create_program(
                program_name => 'backupProgram',
                program_type => 'STORED_PROCEDURE',
                program_action => 'mydbms_sheduler.newBackup',
                number_of_arguments => 0,
                enabled => true
            );
        dbms_scheduler.create_job(
                job_name =>'backupJob',
                program_name => 'backupProgram',
                SCHEDULE_NAME => 'schedule',
                ENABLED => true
            );
    end;

    procedure newBackup
    as
    begin
        mydbms_job.newBackup();
    end;

    procedure executing as
        jobName varchar2(100);
    begin
        select (select job_name from all_scheduler_jobs where job_name = 'BACKUPJOB' and ENABLED = 'TRUE')
        into jobName from dual;
        if jobName is not null then
            DBMS_OUTPUT.PUT_LINE('выполняется');
        else
            DBMS_OUTPUT.PUT_LINE('не выполняется');
        end if;
    end;

    procedure stopExecuting
    is
    begin
        DBMS_SCHEDULER.disable('backupJob');
        commit;
    end;

    procedure deleteJob
    is
    begin
        DBMS_SCHEDULER.DROP_JOB(job_name => 'backupJob');
        DBMS_SCHEDULER.DROP_SCHEDULE(schedule_name => 'schedule');
        DBMS_SCHEDULER.DROP_PROGRAM(program_name => 'backupProgram');
        commit;
    end;

    procedure setDate(newDate date)
    as
    begin
        DBMS_SCHEDULER.SET_ATTRIBUTE(
        name => 'Schedule',
        attribute => 'start_date',
        value => newDate
        );
    end;
end;

begin
    mydbms_sheduler.newJob();
    mydbms_sheduler.executing();
    mydbms_sheduler.setdate(sysdate + 1);
end;

select * from all_scheduler_jobs where job_name = 'BACKUPJOB';

begin
    mydbms_sheduler.stopexecuting();
    mydbms_sheduler.executing();
    mydbms_sheduler.deleteJob();
end;