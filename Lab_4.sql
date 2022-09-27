ALTER PLUGGABLE DATABASE MKV_PDB OPEN READ WRITE FORCE;
ALTER PLUGGABLE DATABASE MKV_PDB CLOSE;

-- 1. Получите список всех существующих PDB в рамках экземпляра ORA12W. Определите их текущее состояние.
select name, open_mode from v$pdbs;

-- 2. Выполните запрос к ORA12W, позволяющий получить перечень экземпляров.
select INSTANCE_NAME from v$instance;

-- 3. Выполните запрос к ORA12W, позволяющий получить перечень установленных компонентов СУБД Oracle 12c и их версии и статус. 
select * from PRODUCT_COMPONENT_VERSION;

-- 4. Создайте собственный экземпляр PDB (необходимо подключиться к серверу 
-- с серверного компьютера и используйте Database Configuration Assistant) с именем XXX_PDB, где XXX – инициалы студента.
-- (screenshot)

-- 5. Получите список всех существующих PDB в рамках экземпляра ORA12W. Убедитесь, что созданная PDB-база данных существует.
select name, open_mode from v$pdbs; 

-- 6. Подключитесь к XXX_PDB c помощью SQL Developer создайте инфраструктурные объекты (табличные пространства, роль, 
-- профиль безопасности, пользователя с именем U1_XXX_PDB).
create tablespace TS_MKV
datafile 'C:\DBF-files\TS_MKV.dbf'
size 7M autoextend on next 5M maxsize 20M
logging
online;
commit;

drop TABLESPACE TS_MKV;
commit;

create tablespace TS_MKV_2 
datafile 'C:\DBF-files\MKV_2.dbf' 
size 7M reuse autoextend on next 5M maxsize 20M; 
commit;
drop TABLESPACE TS_MKV_2;
commit;

create temporary tablespace TS_MKV_TEMP
tempfile 'C:\DBF-files\MKV_TEMP.dbf' size 5M
autoextend on next 3M maxsize 30M;
commit;
drop TABLESPACE TS_MKV_TEMP;
commit;

select * from DBA_TABLESPACES;


--alter session set "_ORACLE_SCRIPT"=true;
alter session set container=CDB$ROOT;

create role RL_MKV;
commit;

GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      UPDATE TABLE,
      INSERT TABLE,
      CREATE PROCEDURE TO  RL_MKV;
GRANT DROP ANY TABLE,
      DROP ANY VIEW,
      DROP ANY PROCEDURE TO  RL_MKV;
     
commit;

select * from DBA_ROLES where ROLE = 'RL_MKV';
select * from DBA_ROLE_PRIVS where GRANTED_ROLE = 'RL_MKV';
drop ROLE RL_MKV;
commit;

create profile PF_MKV limit
    password_life_time 180          -- количество дней жизни пароля
    sessions_per_user 3             -- количество сессий для пользователя
    failed_login_attempts 7         -- количество попыток входа
    password_lock_time 1            -- количество дней блокирования после ошибок
    password_reuse_time 10          -- через сколько дней можно повторить пароль
    password_grace_time default     -- количество дней предупреждений о смене пароля
    connect_time 180                -- время соединения, минут
    idle_time 30;                   -- количество минут простоя
commit;

select * from DBA_PROFILES where PROFILE = 'PF_MKV';
drop PROFILE PF_MKV cascade;
commit;

create user U1_MKV_PDB identified by U1_MKV_PDB
default tablespace TS_MKV
quota unlimited on TS_MKV
TEMPORARY TABLESPACE TS_MKV_TEMP
profile PF_MKV
account unlock;
commit;

grant quota unlimited on TS_MKV to U1_MKV_PDB;
grant unlimited tablespace to U1_MKV_PDB;

grant RL_MKV to U1_MKV_PDB;
grant create session to U1_MKV_PDB;
grant INSERT on table MKV_t from U1_MKV_PDB;
commit;

show user;
select * from dba_users;

drop user U1_MKV_PDB cascade;
commit;

-- 7. Подключитесь к пользователю U1_XXX_PDB, с помощью SQL Developer, 
-- создайте таблицу XXX_table, добавьте в нее строки, выполните SELECT-запрос к таблице.
create table MKV_t (x number(3), s varchar2(50)) ;
commit;

insert into MKV_t (x, s) values (1, 'first');
insert into MKV_t (x, s) values (2, 'second');
insert into MKV_t (x, s) values (3, 'third');
commit;

select * from MKV_t;

-- 8. С помощью представлений словаря базы данных определите, все табличные пространства, все  файлы (перманентные и временные), все роли (и выданные им привилегии), профили безопасности, 
-- всех пользователей  базы данных XXX_PDB и  назначенные им роли.
select * from DBA_TABLESPACES;  --все табличные пространства
select * from DBA_DATA_FILES;   --перманентные данные 
select * from DBA_TEMP_FILES;  --временные данные
select * from DBA_ROLES where ROLE like 'RL%'; --роли
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;  --привилегии
select * from DBA_PROFILES;  --профили безопасности
select * from ALL_USERS;  --все пользователи

-- 9. Подключитесь  к CDB-базе данных, создайте общего пользователя с именем C##XXX, назначьте ему привилегию, позволяющую подключится к базе данных XXX_PDB. Создайте 2 подключения пользователя C##XXX в SQL Developer к CDB-базе данных и  XXX_PDB – базе данных. 
-- Проверьте их работоспособность.  
create user C##MKV identified by 12345678
account unlock;
grant create session to C##MKV;
commit;

select * from DBA_USERS where USERNAME like '%MKV%';
select * from v$session where USERNAME is not null;
show user;

drop user C##MKV;
commit;


-- 13. Удалите созданную базу данных XXX_DB. Убедитесь, что все файлы PDB-базы данных удалены. 
-- Удалите пользователя C##XXX. Удалите в SQL Developer все подключения к XXX_PDB.
drop user C##MKV;
drop user U1_MKV_PDB;
drop database MKV_PDB;
commit;
