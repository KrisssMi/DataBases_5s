show user;    -- user: С##MKV, password: 12345678

  -- 1.
select * from user_sys_privs;
select * from session_privs;
select * from user_tablespaces;

grant create session to C##MKV;
grant create sequence to C##MKV;
grant create cluster to C##MKV;
grant create synonym to C##MKV;
grant create public synonym to C##MKV;
grant create view to C##MKV;
grant create table to C##MKV;
grant dba to C##MKV;
grant create MATERIALIZED view to C##MKV;
commit;

alter user C##MKV quota unlimited on users;

  -- 2.
create sequence S1
    increment by 10
    start with 1000
    nominvalue
    nomaxvalue
    nocycle
    nocache
    noorder;
commit;

select S1.nextval from dual;
select S1.currval from dual;
select S1.currval, S1.nextval from dual; 

drop sequence S1;
commit;

  -- 3.
create sequence S2
    start with 10
    increment by 10
    maxvalue 100
    nocycle;
commit;

select S2.nextval, S2.nextval from dual;
select S2.currval from dual;
alter sequence S2 increment by 90;
alter sequence S2 increment by 10;

drop sequence S2;
commit;

  -- 5. ???
create sequence S3
  start with -10
  increment by -10
  minvalue -100
  nocycle
  order;
commit;

select S3.nextval, S3.nextval from dual;
select S3.currval from dual;

alter sequence S3 increment by 50;
-- ORA-08004: ????????. S3.NEXTVAL exceeds MAXVALUE ? ?? ????? ???? ???????????
alter sequence S3 increment by -10;

drop sequence S3;
commit;

  -- 6. 
create sequence S4
  start with 1
  increment by 1
  maxvalue 10
  cycle
  cache 5
  noorder;
commit;

select S4.nextval from dual;
select S4.currval from dual;

drop sequence S4;
commit;

  -- 7.
SELECT * FROM SYS.all_sequences WHERE SEQUENCE_OWNER = 'C##MKV';

  -- 8.
create table T1 (
        N1 NUMBER(20),
        N2 NUMBER(20),
        N3 NUMBER(20),
        N4 NUMBER(20)) cache storage(buffer_pool keep);
commit;

insert into T1(N1, N2, N3, N4) values(S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
commit;
select * from T1;
drop table T1;

  -- 9.
create cluster ABC (
      X number(10),
      V varchar2(12)) hashkeys 200;
commit;

select * from all_clusters where owner='C##MKV';

drop cluster ABC;

  -- 10-12.
create table A(XA number(10),
               VA varchar2(12), 
               AA number(10))
cluster ABC (XA, VA); 

create table B(XB number(10),
               VB varchar2(12), 
               BB number(10))
cluster ABC (XB, VB); 

create table C(XC number(10),
               VC varchar2(12), 
               CC number(10))
cluster ABC (XC, VC); 

drop table A;
drop table B;
drop table C;

  -- 13.
select * from user_tables;
select * from user_clusters;

  -- 14.
create synonym SYN1 for C;
commit;
select * from SYN1;
--select * from C##MKV.SYN1;
drop synonym SYN1;

  -- 15.
create public synonym SYN2 for B;
commit;
select * from SYN2;
--select * from C##MKV.SYN2;
drop public synonym SYN2;

  -- 16.
-- Создайте две произвольные таблицы A и B (с первичным и внешним ключами),
-- заполните их данными, создайте представление V1, основанное на SELECT... FOR A inner join B.
-- Продемонстрируйте его работоспособность.
create table A1(
    x number(10), 
    y varchar(12),
    constraint x_pk primary key (x)
    );
    
create table B1(
    x number(10),
    y varchar(12), 
    constraint x_fk foreign key (x) references A1(x)
    );
commit;

insert into A1 (x, y) values (1,'a');
insert into A1 (x, y) values (2,'b');
insert into A1 (x, y) values (3,'c');
insert into B1 (x, y) values (1,'d');
insert into B1 (x, y) values (2,'e');
insert into B1 (x, y) values (3,'f');
commit;

select * from A1;
select * from B1;

create view V1 as select A1.y as AY, B1.y as BYf, A1.x from A1 inner join B1 on A1.x=B1.x;
commit;

select * from V1;

drop view V1;
drop table A1;
drop table B1;

  -- 17.
-- На основе таблиц A и B создайте материализованное представление MV,
-- которое имеет периодичность обновления 2 минуты.
-- Продемонстрируйте его работоспособность.
create materialized view MV
build immediate
refresh complete on demand next sysdate+numtodsinterval(2,'minute')
as select * from A1;
commit;

select * from A1;
select * from B1;
select * from MV;
insert into A1(x,y) values (4, 'aaaaaaaaaa');
insert into A1(x,y) values (5, 'bbbbbbbbbb');
commit;

drop materialized view MV;
commit;

  
