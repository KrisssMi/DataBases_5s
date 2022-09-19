-- alter session set container=XEPDB1;
-- alter session set container=CDB$ROOT;
alter session set "_ORACLE_SCRIPT"= true;

-- ������� �1: �������� ��������� ������������ ��� ���������� ������
create tablespace TS_MKV
datafile 'TS1_MKV'
size 7M
reuse
autoextend on next 5M maxsize 20M;

select * from dba_data_files

-- ������� �2: �������� ��������� ������������ ��� ��������� ������
create temporary tablespace TS_MKV_TEMP
tempfile 'TS_MKV_TEMP'
size 5M
reuse
autoextend on next 3M maxsize 30M;

drop tablespace TS_MKV;
drop tablespace TS_MKV_TEMP;


-- ������� �3: ������ ���� ��������� �����������, ������ ���� ������ � ������� select-������� � �������
select TABLESPACE_NAME from dba_tablespaces;

-- � ����� ������ �������� ��������� ������������:
select file_name, tablespace_name FROM DBA_DATA_FILES;


-- ������� �4: �������� ���� � ������ RL_XXXCORE. + ��������� ����������: ?	���������� �� ���������� � ��������; ?	���������� ��������� � ������� �������, �������������, ��������� � �������.
create role RL_MKVCORE;
commit;

--drop role RL_MKVCORE;

grant create session, create table, create view, create procedure to RL_MKVCORE;
grant drop any table, drop any view, drop any procedure to RL_MKVCORE;


-- ������� �5. ������� � ������� select-������� ���� � �������. ������� � ������� select-������� ��� ��������� ����������, ����������� ����.
select * from DBA_ROLES where ROLE = 'RL_MKVCORE';
select * from DBA_SYS_PRIVS where grantee='RL_MKVCORE';


-- ������� �6: �������� ������� ������������ � ������ PF_XXXCORE, ������� �����, ����������� ������� �� ������.
create profile PF_MKVCORE limit
    password_life_time 180          -- ���������� ���� ����� ������
    sessions_per_user 3             -- ���������� ������ ��� ������������
    failed_login_attempts 7         -- ���������� ������� �����
    password_lock_time 1            -- ���������� ���� ������������ ����� ������
    password_reuse_time 10          -- ����� ������� ���� ����� ��������� ������
    password_grace_time default     -- ���������� ���� �������������� � ����� ������
    connect_time 180                -- ����� ����������, �����
    idle_time 30;                   -- ���������� ����� �������

--drop profile PF_MKVCORE;


-- ������� �7: �������� ������ ���� �������� ��. �������� �������� ���� ���������� ������� PF_XXXCORE. �������� �������� ���� ���������� ������� DEFAULT.
select * from DBA_PROFILES;
select * from DBA_PROFILES where PROFILE='PF_MKVCORE';
select * from DBA_PROFILES where PROFILE='DEFAULT';


-- ������� �8: �������� ������������ � ������ XXXCORE �� ���������� �����������: - ��������� ������������ �� ���������: TS_XXX; - ��������� ������������ ��� ��������� ������: TS_XXX_TEMP; - ������� ������������ PF_XXXCORE; - ������� ������ ��������������; - ���� �������� ������ �����.
create user MKVCORE identified by MKVCORE           -- ! ����� by ����������� ������
    default tablespace TS_MKV
    temporary tablespace TS_MKV_TEMP
    profile PF_MKVCORE
    account unlock
    password expire;

--drop user MKVCORE cascade;                                                                    -- ������: MKV29


-- ������� �9. ����������� � �������� Oracle � ������� sqlplus � ������� ����� ������ ��� ������������ XXXCORE.



-- ������� �10. �������� ���������� � ������� SQL Developer ��� ������������ XXXCORE. �������� ����� ������� � ����� �������������.
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


-- ������� �11. �������� ��������� ������������ � ������ XXX_QDATA (10m). ��� �������� ���������� ��� � ��������� offline. ����� ���������� ��������� ������������ � ��������� online. �������� ������������ XXX ����� 2m � ������������ XXX_QDATA. �� ����� ������������ XXX �������� ������� � ������������ XXX_T1. � ������� �������� 3 ������.
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