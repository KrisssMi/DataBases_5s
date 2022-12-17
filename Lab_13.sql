ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 1.
create or replace procedure get_teachers
(pcode teacher.pulpit%type)
is
cursor my_cursor is select TEACHER_NAME, TEACHER from teacher where pulpit = pcode;
    t_name teacher.TEACHER_NAME%type;
    t_code teacher.teacher%type;
    begin
        open my_cursor;
        fetch my_cursor into t_name, t_code;
        loop
            exit when my_cursor%notfound;
            fetch my_cursor into t_name, t_code;
            dbms_output.put_line(my_cursor%rowcount|| '. '|| t_code||'->'||t_name);
        end loop;
        close my_cursor;
    end;
--drop procedure get_teachers;
begin
    get_teachers('ИСиТ');
end;


-- 2.
create or replace function get_num_teachers
(pcode teacher.pulpit%type)
return number
is
    num number;
    begin
        select count(*) into num from teacher where pulpit = pcode;
        return num;
    end;
--drop function get_num_teachers;
begin
    dbms_output.put_line(get_num_teachers('ИСиТ'));
end;


-- 3.
create or replace procedure get_teachers
(fcode faculty.faculty%type)
is
cursor my_cursor is select TEACHER_NAME, TEACHER from teacher inner join PULPIT P on P.PULPIT = TEACHER.PULPIT inner join FACULTY F on F.FACULTY = P.FACULTY where F.FACULTY = fcode;
    t_name teacher.TEACHER_NAME%type;
    t_code teacher.teacher%type;
    begin
        open my_cursor;
        fetch my_cursor into t_name, t_code;
        loop
            exit when my_cursor%notfound;
            fetch my_cursor into t_name, t_code;
            dbms_output.put_line(my_cursor%rowcount|| '. '|| t_code||'->'||t_name);
        end loop;
        close my_cursor;
    end;
--drop procedure get_teachers;
begin
    get_teachers('ИДиП');
end;


-- 4.
create or replace procedure get_subjects
(pcode subject.pulpit%type)
is
cursor my_cursor is select SUBJECT_NAME, SUBJECT from subject where pulpit = pcode;
    s_name subject.SUBJECT_NAME%type;
    s_code subject.subject%type;
    begin
        open my_cursor;
        fetch my_cursor into s_name, s_code;
        loop
            exit when my_cursor%notfound;
            fetch my_cursor into s_name, s_code;
            dbms_output.put_line(my_cursor%rowcount|| '. '|| s_code||' -> '||s_name);
        end loop;
        close my_cursor;
    end;
-- drop procedure get_subjects;
begin
    get_subjects('ИСиТ');
end;


-- 5.
create or replace function get_num_teachers
(fcode faculty.faculty%type)
return number
is
    num number;
    begin
        select count(*) into num from teacher inner join PULPIT P on P.PULPIT = TEACHER.PULPIT inner join FACULTY F on F.FACULTY = P.FACULTY where F.FACULTY = fcode;
        return num;
    end;
--drop function get_num_teachers;
begin
    dbms_output.put_line(get_num_teachers('ИДиП'));
end;


-- 6.
create or replace function get_num_subjects
(pcode subject.pulpit%type)
return number
is
    num number;
    begin
        select count(*) into num from subject where pulpit = pcode;
        return num;
    end;
--drop function get_num_subjects;
begin
    dbms_output.put_line(get_num_subjects('ИСиТ'));
end;


-- 7.
-- Разработайте пакет TEACHERS, содержащий процедуры и функции
create or replace package teachers as
    function get_num_teachers(fcode faculty.faculty%type) return number;
    function get_num_subjects(pcode subject.pulpit%type) return number;
    procedure get_teachers(fcode faculty.faculty%type);
    procedure get_subjects(pcode subject.pulpit%type);
end;


create or replace package body teachers as
    function get_num_teachers (fcode faculty.faculty%type) return number is tCount number;
    begin
        select count(*) into tCount from teacher inner join PULPIT P on P.PULPIT = TEACHER.PULPIT inner join FACULTY F on F.FACULTY = P.FACULTY where F.FACULTY = fcode;
        return tCount;
    end get_num_teachers;

    function get_num_subjects (pcode subject.pulpit%type) return number is sCount number;
    begin
        select count(*) into sCount from subject where pulpit = pcode;
        return sCount;
    end get_num_subjects;

    procedure get_teachers (fcode faculty.faculty%type) is
        cursor my_cursor is select TEACHER_NAME, TEACHER from teacher inner join PULPIT P on P.PULPIT = TEACHER.PULPIT inner join FACULTY F on F.FACULTY = P.FACULTY where F.FACULTY = fcode;
            t_name teacher.TEACHER_NAME%type;
            t_code teacher.teacher%type;
            begin
                open my_cursor;
                fetch my_cursor into t_name, t_code;
                loop
                    exit when my_cursor%notfound;
                    fetch my_cursor into t_name, t_code;
                    dbms_output.put_line(my_cursor%rowcount|| '. '|| t_code||'->'||t_name);
                end loop;
                close my_cursor;
            end get_teachers;

    procedure get_subjects (pcode subject.pulpit%type) is
        cursor my_cursor is select SUBJECT_NAME, SUBJECT from subject where pulpit = pcode;
            s_name subject.SUBJECT_NAME%type;
            s_code subject.subject%type;
            begin
                open my_cursor;
                fetch my_cursor into s_name, s_code;
                loop
                    exit when my_cursor%notfound;
                    fetch my_cursor into s_name, s_code;
                    dbms_output.put_line(my_cursor%rowcount|| '. '|| s_code||' -> '||s_name);
                end loop;
                close my_cursor;
            end get_subjects;
end teachers;

--drop package teachers;
begin
    DBMS_OUTPUT.PUT_LINE('Количество преподавателей по факультету: '|| teachers.get_num_teachers('ИДиП'));
    DBMS_OUTPUT.PUT_LINE('Количество дисциплин по кафедре: '|| teachers.get_num_subjects('ИСиТ'));
    DBMS_OUTPUT.PUT_LINE('Преподаватели по факультету: ');
    teachers.get_teachers('ИДиП');
    DBMS_OUTPUT.PUT_LINE('Дисциплины по кафедре: ');
    teachers.get_subjects('ИСиТ');
end;