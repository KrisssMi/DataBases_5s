--user: system
CREATE PROFILE CUSTOMER_PROFILE LIMIT PASSWORD_LIFE_TIME 180 SESSIONS_PER_USER 20 FAILED_LOGIN_ATTEMPTS 7 PASSWORD_LOCK_TIME 1 PASSWORD_REUSE_TIME 10 PASSWORD_GRACE_TIME DEFAULT CONNECT_TIME 180 IDLE_TIME 30;

DROP PROFILE CUSTOMER_PROFILE CASCADE;
DROP USER CUSTOMER CASCADE;

CREATE USER customer IDENTIFIED BY qwerty
    DEFAULT TABLESPACE USERS
    PROFILE CUSTOMER_PROFILE
    QUOTA UNLIMITED ON USERS;

grant connect to customer;
DROP ROLE CUSTOMER_ROLE;

CREATE ROLE CUSTOMER_ROLE;
Alter session set container = cdb$root;

commit;

Grant connect, resource to customer;
grant customer_role to customer;
grant customer_role to customer_2;

-- DBLINK по схеме USER1 - USER2
--1
CREATE DATABASE LINK anotherdb
   CONNECT TO customer
   IDENTIFIED BY qwerty
   USING 'DESKTOP-OF49FOH:1521/XE';

DROP DATABASE LINK anotherdb;
--grant create database link to customer;
GRANT CREATE DATABASE LINK TO CUSTOMER;

-- user: CUSTOMER
create table MKV (
    MKV_id number(10) generated as identity(start with 1 increment by 1),
    MKV_name varchar2(30) not null,
    MKV_number number(3) not null,
    CONSTRAINT MKV_pk PRIMARY KEY (MKV_id)
);
commit;
insert into MKV (MKV_name, MKV_number) values ('Kristina', 19);

select * from MKV;
drop table MKV;

-- user: system
SELECT * FROM SNA@anotherdb;    -- подключение и просмотр информации в таблице SNA сервера удаленной базе данных


--2
SELECT * FROM SNA@anotherdb;
INSERT INTO SNA@anotherdb values('NewRow', 20);
UPDATE SNA@anotherdb SET SNA_NUMBER = 13 WHERE SNA_NAME = 'NewRow';
DELETE SNA@anotherdb where SNA_NAME = 'NewRow';
commit;


--3
-- создание процедуры и функции:
create or replace procedure MKV_PROCEDURE
is
begin
    insert into MKV (MKV_name, MKV_number) values ('Kristina', 19);
end;
--drop procedure MKV_PROCEDURE;
begin
    MKV_PROCEDURE();
end;

-- вызов чужой функции:
begin
     DBMS_OUTPUT.PUT_LINE(CUSTOMER.GET_NUM_Rows@anotherdb(1,2));
end;

select * from MKV;


create or replace function GET_NUM_Rows RETURN NUMBER
is
    num_rows NUMBER;
begin
    select count(*) into num_rows from MKV;
    return num_rows;
end;
--drop function GET_NUM_Rows;
begin
    DBMS_OUTPUT.PUT_LINE(GET_NUM_Rows);
end;

-- вызов чужой процедуры:
begin
     CUSTOMER.Get_sna@anotherdb('Hello',3);
end;