create table MKV_t (x number(3) primary key, s varchar2(50));

insert into MKV_t (x, s) values (1, 'Angelina');
insert into MKV_t (x, s) values (2, 'Boris');
insert into MKV_t (x, s) values (3, 'Kate');
insert into MKV_t (x, s) values (5, 'Larisa');
insert into MKV_t (x, s) values (6, 'Kristina');
insert into MKV_t (x, s) values (7, 'Roman');
insert into MKV_t (x, s) values (8, 'Tima');
commit;

update MKV_t set x = '0' where s = 'Angelina';
commit;

select * from MKV_t;
select s from MKV_t where x=2;
select sum(x) from MKV_t;

delete from MKV_t where x=3;
commit;

create table MKV_t1
(
x1 number(3),
s1 varchar2(50),
  CONSTRAINT fk_xx1 FOREIGN KEY (x1) REFERENCES MKV_t(x)
);

insert into MKV_t1(x1, s1) values (0, 'Denis');
insert into MKV_t1(x1, s1) values (2, 'Evgenii');
insert into MKV_t1(x1, s1) values (5, 'Fedya');
insert into MKV_t1(x1, s1) values (8, 'Mila');
commit;

/*соединения*/

select x, s from MKV_t inner join MKV_t1 on MKV_t.x = MKV_t1.x1;

select x,s from MKV_t left outer join MKV_t1 on MKV_t.x = MKV_t1.x1;

select x,s from MKV_t right outer join MKV_t1 on MKV_t.x = MKV_t1.x1;

select x,s from MKV_t full outer join MKV_t1 on MKV_t.x = MKV_t1.x1;

drop table MKV_t1;
drop table MKV_t;