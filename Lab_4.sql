ALTER PLUGGABLE DATABASE MKV_PDB OPEN READ WRITE FORCE;
ALTER PLUGGABLE DATABASE MKV_PDB CLOSE;

-- 1. �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. ���������� �� ������� ���������.
select name, open_mode from v$pdbs;

-- 2. ��������� ������ � ORA12W, ����������� �������� �������� �����������.
select INSTANCE_NAME from v$instance;

-- 3. ��������� ������ � ORA12W, ����������� �������� �������� ������������� ����������� ���� Oracle 12c � �� ������ � ������. 
select * from PRODUCT_COMPONENT_VERSION;

-- 4. �������� ����������� ��������� PDB (���������� ������������ � ������� 
-- � ���������� ���������� � ����������� Database Configuration Assistant) � ������ XXX_PDB, ��� XXX � �������� ��������.
-- (screenshot)

-- 5. �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. ���������, ��� ��������� PDB-���� ������ ����������.
select name, open_mode from v$pdbs; 

-- 6. ������������ � XXX_PDB c ������� SQL Developer �������� ���������������� ������� (��������� ������������, ����, 
-- ������� ������������, ������������ � ������ U1_XXX_PDB).
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
    password_life_time 180          -- ���������� ���� ����� ������
    sessions_per_user 3             -- ���������� ������ ��� ������������
    failed_login_attempts 7         -- ���������� ������� �����
    password_lock_time 1            -- ���������� ���� ������������ ����� ������
    password_reuse_time 10          -- ����� ������� ���� ����� ��������� ������
    password_grace_time default     -- ���������� ���� �������������� � ����� ������
    connect_time 180                -- ����� ����������, �����
    idle_time 30;                   -- ���������� ����� �������
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

-- 7. ������������ � ������������ U1_XXX_PDB, � ������� SQL Developer, 
-- �������� ������� XXX_table, �������� � ��� ������, ��������� SELECT-������ � �������.
create table MKV_t (x number(3), s varchar2(50)) ;
commit;

insert into MKV_t (x, s) values (1, 'first');
insert into MKV_t (x, s) values (2, 'second');
insert into MKV_t (x, s) values (3, 'third');
commit;

select * from MKV_t;

-- 8. � ������� ������������� ������� ���� ������ ����������, ��� ��������� ������������, ���  ����� (������������ � ���������), ��� ���� (� �������� �� ����������), ������� ������������, 
-- ���� �������������  ���� ������ XXX_PDB �  ����������� �� ����.
select * from DBA_TABLESPACES;  --��� ��������� ������������
select * from DBA_DATA_FILES;   --������������ ������ 
select * from DBA_TEMP_FILES;  --��������� ������
select * from DBA_ROLES where ROLE like 'RL%'; --����
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;  --����������
select * from DBA_PROFILES;  --������� ������������
select * from ALL_USERS;  --��� ������������

-- 9. ������������  � CDB-���� ������, �������� ������ ������������ � ������ C##XXX, ��������� ��� ����������, ����������� ����������� � ���� ������ XXX_PDB. �������� 2 ����������� ������������ C##XXX � SQL Developer � CDB-���� ������ �  XXX_PDB � ���� ������. 
-- ��������� �� �����������������.  
create user C##MKV identified by 12345678
account unlock;
grant create session to C##MKV;
commit;

select * from DBA_USERS where USERNAME like '%MKV%';
select * from v$session where USERNAME is not null;
show user;

drop user C##MKV;
commit;


-- 13. ������� ��������� ���� ������ XXX_DB. ���������, ��� ��� ����� PDB-���� ������ �������. 
-- ������� ������������ C##XXX. ������� � SQL Developer ��� ����������� � XXX_PDB.
drop user C##MKV;
drop user U1_MKV_PDB;
drop database MKV_PDB;
commit;
