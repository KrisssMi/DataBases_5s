--1. Добавьте в таблицу TEACHERS два столбца BIRTHDAY и SALARY, заполните их значениями.
alter table TEACHER add BIRTHDAY Date;
alter table TEACHER add SALARY number(7,2);

select * from TEACHER;

declare
    cursor curs is select * from teacher for update;
    rand_date Date;
begin
    for cur_curs in curs
    loop
        update teacher set salary = dbms_random.value(100, 999) where current of curs;
        select to_date(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '1960-01-01', 'J'), TO_CHAR(DATE '2000-01-01', 'J'))), 'J')
        into rand_date from DUAL;
        update teacher set birthday = rand_date where current of curs;
    end loop;
    commit;
exception when others
    then dbms_output.PUT_LINE(sqlerrm);
end;

select * from TEACHER;

--2. Получите список преподавателей в виде Фамилия И.О.
declare
    LastName TEACHER.TEACHER_NAME % type;
    FirstName TEACHER.TEACHER_NAME % type;
    Patronymic TEACHER.TEACHER_NAME % type;
    pos_name number := 0;
    pos_patronymic number := 0;
    cursor curs is select TEACHER_NAME from TEACHER;
begin
    for cur_curs in curs
    loop
        pos_name := INSTR(cur_curs.TEACHER_NAME, ' ');
        pos_patronymic := INSTR(cur_curs.TEACHER_NAME, ' ', pos_name + 1);
        LastName := SUBSTR(cur_curs.TEACHER_NAME, 1, pos_name - 1);
        FirstName := SUBSTR(SUBSTR(cur_curs.TEACHER_NAME, pos_name, pos_patronymic - 1), 1, 2);
        Patronymic := SUBSTR(SUBSTR(cur_curs.TEACHER_NAME, pos_patronymic), 1, 2);
        dbms_output.PUT_LINE( LastName || FirstName|| '.' || Patronymic || '.' );
    end loop;
end;

--3. Получите список преподавателей, родившихся в понедельник.
declare
    cursor curs
    is select TEACHER_NAME, BIRTHDAY from teacher
    where TO_CHAR((birthday), 'd') = 1;
    teacher_birth TEACHER.BIRTHDAY % TYPE;
    teacher_name TEACHER.TEACHER_NAME % TYPE;
begin
    open curs;
    fetch curs into teacher_name, teacher_birth;
    while curs % found
    loop
        dbms_output.PUT_LINE(teacher_name || ' ' || teacher_birth);
        fetch curs into teacher_name, teacher_birth;
    end loop;
    close curs;
end;

--4. Создайте представление, в котором поместите список преподавателей, которые родились в следующем месяце.
create view V1 as
select * from teacher
where TO_CHAR(sysdate, 'mm') + 1 = TO_CHAR(birthday, 'mm');

select * from V1;
drop view V1;

--5. Создайте представление, в котором поместите количество преподавателей, которые родились в каждом месяце.
create view V2 as
select to_char(birthday, 'Month') Month, count(*) Count
from teacher
group by to_char(birthday, 'mm'), to_char(birthday, 'Month')
having count(*) > 0
order by to_char(birthday, 'mm');

select * from V2;
drop view V2;

--6. Создать курсор и вывести список преподавателей, у которых в следующем году юбилей.
declare
    cursor curs is select * from TEACHER;
    cur_curs TEACHER % rowtype;
begin
    for cur_curs in curs
    loop
        if (mod((to_number(to_char(sysdate, 'YYYY')) + 1) - to_number(to_char(cur_curs.birthday, 'YYYY')), 10) = 0) then
            dbms_output.PUT_LINE(cur_curs.TEACHER_NAME || ' ' || cur_curs.BIRTHDAY);
        end if;
    end loop;
exception when others
    then dbms_output.PUT_LINE(sqlerrm);
end;

--7. Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до целых,
--вывести средние итоговые значения для каждого факультета и для всех факультетов в целом.
declare
    cursor curs1 is
    select floor(avg(salary)), pulpit
    from teacher
    group by pulpit;

    cursor curs2 is
    select round(avg(salary), 3), faculty
    from teacher inner join pulpit
    on teacher.pulpit = pulpit.pulpit
    group by faculty
    order by faculty;

    cursor curs3 is
    select round(avg(salary), 3)
    from teacher;

    cur_salary teacher.salary % type;
    cur_pulpit teacher.pulpit % type;
    cur_faculty pulpit.faculty % type;
begin
    open curs1;
    fetch curs1 into cur_salary, cur_pulpit;
    while curs1 % found
    loop
        dbms_output.PUT_LINE(cur_pulpit || ' ' || cur_salary);
        fetch curs1 into cur_salary, cur_pulpit;
    end loop;
    close curs1;

    dbms_output.PUT_LINE('--------------------------------');

    open curs2;
    fetch curs2 into cur_salary, cur_faculty;
    while curs2 % found
    loop
        dbms_output.PUT_LINE(cur_faculty || ' ' || cur_salary);
        fetch curs2 into cur_salary, cur_faculty;
    end loop;
    close curs2;

    dbms_output.PUT_LINE('--------------------------------');

    open curs3;
    fetch curs3 into cur_salary;
    while curs3 % found
    loop
        dbms_output.PUT_LINE(cur_salary);
        fetch curs3 into cur_salary;
    end loop;
    close curs3;
exception when others
    then dbms_output.PUT_LINE(sqlerrm);
end;

--8. Создайте собственный тип PL/SQL-записи (record) и продемонстрируйте работу с ним. Продемонстрируйте работу с вложенными записями.
--Продемонстрируйте и объясните операцию присвоения.
declare
    type params is record
    (
      age number := 20,
      height number := 170
    );
    type person is record
    (
        firstName varchar2(10):= 'Kristina',
        lastName varchar2(10):= 'Minevich',
        personParams params
    );
    person1 person;
begin
    dbms_output.PUT_LINE(person1.firstName || ' ' || person1.lastName || ' ' || person1.personParams.age || ' ' || person1.personParams.height);
    person1.firstName := 'XXX';
    person1.lastName := 'YYY';
    person1.personParams.age := 19;
    person1.personParams.height := 180;
    dbms_output.PUT_LINE(person1.firstName || ' ' || person1.lastName || ' ' || person1.personParams.age || ' ' || person1.personParams.height);
end;