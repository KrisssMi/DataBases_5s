-- alter session set container=XEPDB1;
-- alter session set container=CDB$ROOT;
alter session set "_ORACLE_SCRIPT"= true;

-- Задание №1: Создайте табличное пространство для постоянных данных
create tablespace TS_MKV
datafile 'TS1_MKV'
size 7M
reuse
autoextend on next 5M maxsize 20M;

select * from dba_data_files

-- Задание №2: Создайте табличное пространство для временных данных
create temporary tablespace TS_MKV_TEMP
tempfile 'TS_MKV_TEMP'
size 5M
reuse
autoextend on next 3M maxsize 30M;

drop tablespace TS_MKV;
drop tablespace TS_MKV_TEMP;


-- Задание №3: Список всех табличных пространств, списки всех файлов с помощью select-запроса к словарю
select TABLESPACE_NAME from dba_tablespaces;

-- В каких файлах хранятся табличные пространства:
select file_name, tablespace_name FROM DBA_DATA_FILES;


-- Задание №4: Создайте роль с именем RL_XXXCORE. + назначить привилегии: ?	разрешение на соединение с сервером; ?	разрешение создавать и удалять таблицы, представления, процедуры и функции.
create role RL_MKVCORE;
commit;

--drop role RL_MKVCORE;

grant create session, create table, create view, create procedure to RL_MKVCORE;
grant drop any table, drop any view, drop any procedure to RL_MKVCORE;


-- Задание №5. Найдите с помощью select-запроса роль в словаре. Найдите с помощью select-запроса все системные привилегии, назначенные роли.
select * from DBA_ROLES where ROLE = 'RL_MKVCORE';
select * from DBA_SYS_PRIVS where grantee='RL_MKVCORE';


-- Задание №6: Создайте профиль безопасности с именем PF_XXXCORE, имеющий опции, аналогичные примеру из лекции.
create profile PF_MKVCORE limit
    password_life_time 180          -- количество дней жизни пароля
    sessions_per_user 3             -- количество сессий для пользователя
    failed_login_attempts 7         -- количество попыток входа
    password_lock_time 1            -- количество дней блокирования после ошибок
    password_reuse_time 10          -- через сколько дней можно повторить пароль
    password_grace_time default     -- количество дней предупреждений о смене пароля
    connect_time 180                -- время соединения, минут
    idle_time 30;                   -- количество минут простоя

--drop profile PF_MKVCORE;


-- Задание №7: Получите список всех профилей БД. Получите значения всех параметров профиля PF_XXXCORE. Получите значения всех параметров профиля DEFAULT.
select * from DBA_PROFILES;
select * from DBA_PROFILES where PROFILE='PF_MKVCORE';
select * from DBA_PROFILES where PROFILE='DEFAULT';


-- Задание №8: Создайте пользователя с именем XXXCORE со следующими параметрами: - табличное пространство по умолчанию: TS_XXX; - табличное пространство для временных данных: TS_XXX_TEMP; - профиль безопасности PF_XXXCORE; - учетная запись разблокирована; - срок действия пароля истек.
create user MKVCORE identified by MKVCORE           -- ! после by указывается пароль
    default tablespace TS_MKV
    temporary tablespace TS_MKV_TEMP
    profile PF_MKVCORE
    account unlock
    password expire;

--drop user MKVCORE cascade;                                                                    -- пароль: MKV29


-- Задание №9. Соединитесь с сервером Oracle с помощью sqlplus и введите новый пароль для пользователя XXXCORE.



-- Задание №10. Создайте соединение с помощью SQL Developer для пользователя XXXCORE. Создайте любую таблицу и любое представление.
grant connect, create session, create any table, drop any table, create any view to MKVCORE;

create table MKVCORE_T
(
  NAME varchar(50),
  NUMB number
);

-- drop table MKVCORE_T;

insert into MKVCORE_T values ('Kristina', 0);
insert into MKVCORE_T values ('Ira', 1);
insert into MKVCORE_T values ('Natasha', 2);
insert into MKVCORE_T values ('Sasha', 3);
insert into MKVCORE_T values ('Masha', 4);

create view MKVCORE_V as select NAME, NUMB from MKVCORE_T where NAME = 'Kristina';
select * from MKVCORE_V;
-- drop view MKVCORE_V;


-- Задание №11. Создайте табличное пространство с именем XXX_QDATA (10m). При создании установите его в состояние offline. Затем переведите табличное пространство в состояние online. Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. От имени пользователя XXX создайте таблицу в пространстве XXX_T1. В таблицу добавьте 3 строки.
create tablespace MKV_QDATA OFFLINE
  datafile 'E:\MKV_QDATA.txt'
  size 10M reuse
  autoextend on next 5M
  maxsize 20M;

-- drop tablespace MKV_QDATA;

alter tablespace MKV_QDATA online;
alter user MKVCORE QUOTA 2M ON MKV_QDATA;
create table MKV_T1 (c NUMBER);

INSERT INTO MKV_T1(c) VALUES(1);
INSERT INTO MKV_T1(c) VALUES(2);
INSERT INTO MKV_T1(c) VALUES(3);

SELECT * FROM MKV_T1;

--drop table MKV_T1;