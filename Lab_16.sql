ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER MKV
IDENTIFIED BY Pa$$w0rd
DEFAULT TABLESPACE Users
QUOTA UNLIMITED ON Users;

GRANT CONNECT TO MKV;
GRANT CREATE TABLESPACE TO MKV;
GRANT CREATE TABLE TO MKV;
GRANT CREATE SESSION TO MKV;
GRANT ALTER TABLESPACE TO MKV;
commit;

ALTER USER MKV QUOTA UNLIMITED ON ts1;
ALTER USER MKV QUOTA UNLIMITED ON ts2;
ALTER USER MKV QUOTA UNLIMITED ON ts3;

CREATE TABLESPACE ts1 DATAFILE 'D:\16\ts1.DAT'
SIZE 50M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 100M;
CREATE TABLESPACE ts2 DATAFILE 'D:\16\ts2.DAT'
SIZE 50M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 100M;
CREATE TABLESPACE ts3 DATAFILE 'D:\16\ts3.DAT'
SIZE 50M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 100M;

DROP TABLESPACE ts1 INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts2 INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts3 INCLUDING CONTENTS AND DATAFILES;

-- Task 1
-- Создайте таблицу T_RANGE c диапазонным секционированием. Используйте ключ секционирования типа NUMBER
create table T_RANGE (id number not null, time_id date)
partition by range (id)
(
    partition p1 values less than (100) tablespace ts1,
    partition p2 values less than (200) tablespace ts2,
    partition p3 values less than (maxvalue) tablespace ts3
);

insert into T_RANGE(id, time_id) values(50,'01-02-2018');
insert into T_RANGE(id, time_id) values(100,'01-02-2019');
insert into T_RANGE(id, time_id) values(105,'01-02-2017');
insert into T_RANGE(id, time_id) values(205,'01-02-2016');
insert into T_RANGE(id, time_id) values(305,'01-02-2015');
commit;

select * from T_RANGE partition(p1);
select * from T_RANGE partition(p2);
select * from T_RANGE partition(p3);

ALTER TABLE T_RANGE ENABLE ROW MOVEMENT;
UPDATE T_RANGE SET id = '90' WHERE id = '105';
-- ROLLBACK;

DROP TABLE T_RANGE;


-- Task 2
-- Создайте таблицу T_INTERVAL c интервальным секционированием. Используйте ключ секционирования типа DATE.
create table T_INTERVAL (id number not null, time_id date)
partition by range (time_id)
    INTERVAL (INTERVAL '1' YEAR) STORE IN (ts1)
(
PARTITION p1 VALUES LESS THAN (to_date('01-01-2010', 'dd-mm-yyyy')) TABLESPACE ts2,
PARTITION p2 VALUES LESS THAN (to_date('01-01-2020', 'dd-mm-yyyy')) TABLESPACE ts3
);

INSERT INTO T_INTERVAL(id, time_id) VALUES (1, '01-01-1990');
INSERT INTO T_INTERVAL(id, time_id) VALUES (2, '01-01-1995');
INSERT INTO T_INTERVAL(id, time_id) VALUES (3, '01-01-2000');
INSERT INTO T_INTERVAL(id, time_id) VALUES (4, '01-01-2005');
INSERT INTO T_INTERVAL(id, time_id) VALUES (5, '01-01-2010');
INSERT INTO T_INTERVAL(id, time_id) VALUES (6, '01-01-2015');
commit;

select * from T_INTERVAL partition(p1);
select * from T_INTERVAL partition(p2);
select * from T_INTERVAL;
select * from T_INTERVAL partition for (to_date('01-01-1995', 'dd-mm-yyyy'));

ALTER TABLE T_INTERVAL ENABLE ROW MOVEMENT;
UPDATE T_INTERVAL SET time_id = '01-01-2012' WHERE time_id = '01-01-2005';
-- ROLLBACK;

DROP TABLE T_INTERVAL;


-- Task 3
-- Создайте таблицу T_HASH c хэш-секционированием. Используйте ключ секционирования типа VARCHAR2
CREATE TABLE T_HASH(t_str VARCHAR2(50))
PARTITION BY HASH(t_str)
(
PARTITION p1 TABLESPACE ts1,
PARTITION p2 TABLESPACE ts2,
PARTITION p3 TABLESPACE ts3
);

INSERT INTO T_HASH(t_str)VALUES ('11111');
INSERT INTO T_HASH(t_str)VALUES ('22222');
INSERT INTO T_HASH(t_str)VALUES ('33333');
INSERT INTO T_HASH(t_str)VALUES ('44444');
INSERT INTO T_HASH(t_str)VALUES ('55555');
commit;

SELECT * FROM T_HASH;
SELECT * FROM T_HASH PARTITION(p1);
SELECT * FROM T_HASH PARTITION(p2);
SELECT * FROM T_HASH PARTITION(p3);

ALTER TABLE T_HASH ENABLE ROW MOVEMENT;
UPDATE T_HASH SET t_str = '22222' WHERE t_str = '55555';
-- ROLLBACK;

DROP TABLE T_HASH;


-- Task 4
-- Создайте таблицу T_LIST со списочным секционированием. Используйте ключ секционирования типа CHAR
CREATE TABLE T_LIST(t_str CHAR(50))
PARTITION BY LIST(t_str)
(
PARTITION p1 VALUES ('11111') TABLESPACE ts1,
PARTITION p2 VALUES ('22222') TABLESPACE ts2,
PARTITION p3 VALUES (DEFAULT) TABLESPACE ts3
);

INSERT INTO T_LIST(t_str)VALUES ('11111');
INSERT INTO T_LIST(t_str)VALUES ('22222');
INSERT INTO T_LIST(t_str)VALUES ('33333');
INSERT INTO T_LIST(t_str)VALUES ('44444');
INSERT INTO T_LIST(t_str)VALUES ('55555');
commit;

SELECT * FROM T_LIST;
SELECT * FROM T_LIST PARTITION(p1);
SELECT * FROM T_LIST PARTITION(p2);
SELECT * FROM T_LIST PARTITION(p3);

ALTER TABLE T_LIST ENABLE ROW MOVEMENT;
UPDATE T_LIST SET t_str = '22222' WHERE t_str = '55555';
-- ROLLBACK;

DROP TABLE T_LIST;


-- Task 5
-- Введите с помощью операторов INSERT данные в таблицы T_RANGE, T_INTERVAL, T_HASH, T_LIST. Данные должны быть такими, чтобы они разместились по всем секциям. Продемонстрируйте это с помощью SELECT запроса


-- Task 6
-- Продемонстрируйте для всех таблиц процесс перемещения строк между секциями, при изменении (оператор UPDATE) ключа секционирования.


-- Task 7
-- Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE
ALTER TABLE T_RANGE MERGE PARTITIONS p1, p2, p3 INTO PARTITION p4 TABLESPACE ts1;
SELECT * FROM T_RANGE PARTITION(p4);


-- Task 8
-- Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT
ALTER TABLE T_INTERVAL SPLIT PARTITION p2 at (to_date ('01-06-2018', 'dd-mm-yyyy'))
into (partition p6 tablespace ts3, partition p5 tablespace ts2);
-- SPLIT позволяет разделить существующую секцию на две новые. В данном случае секция p2 разделена на p5 и p6. Все строки, которые были в секции p2, перемещаются в секцию p6. Секция p5 пустая.
-- ROLLBACK;
SELECT * FROM T_INTERVAL PARTITION(p5);
SELECT * FROM T_INTERVAL PARTITION(p6);


-- Task 9
-- Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE
CREATE TABLE T_range_temp(t_id NUMBER, t_date DATE);

ALTER TABLE T_RANGE EXCHANGE PARTITION p3 WITH TABLE T_range_temp;
SELECT * FROM T_RANGE PARTITION(p3);
SELECT * FROM T_range_temp;
-- ROLLBACK;
DROP TABLE T_range_temp;