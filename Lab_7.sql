ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- 1.	�������� ������ ������ ������� ���������. 
select count(*) from v$bgprocess; 
select name, description from v$bgprocess; 

-- 2.	���������� ������� ��������, ������� �������� � �������� � ��������� ������.
select * from v$process where background is not null;
select * from v$process;
select * from v$process inner join v$session on v$session.paddr= v$process.addr  where v$session.username != 'null';

-- 3.	����������, ������� ��������� DBWn �������� � ��������� ������.
show parameter db_writer_processes;
select * from v$process where pname like 'DBW%';

-- 4.	�������� �������� ������� ���������� � �����������.
select * from v$session;

-- 5.	���������� ������ ���� ����������.
select username, server from v$session;

-- 6.	���������� ������� (����� ����������� ����������).
select * from v$services;

-- 7.	�������� ��������� ��� ��������� ���������� � �� ��������.
select * from v$dispatcher;
show parameter dispatchers;

-- 8.	������� � ������ Windows-�������� ������, ����������� ������� LISTENER.
-- OracleOraDB19Home1TNSListener

-- 9.	�������� �������� ������� ���������� � ���������. (dedicated, shared). 
SELECT PADDR, USERNAME, SERVER FROM V$SESSION WHERE USERNAME IS NOT NULL;

SELECT ADDR, SPID, PNAME FROM V$PROCESS WHERE BACKGROUND IS NULL ORDER BY PNAME;

-- 10.	����������������� � �������� ���������� ����� LISTENER.ORA. 
-- ������������: C:\app\Admin\product\12.1.0\dbhome_2\NETWORK\ADMIN

-- 11.	��������� ������� lsnrctl � �������� �� �������� �������. 
--lsnrctl
--help --> start, stop,status - ready, blocked, unknown
--services, version
--servacls - get access control lists
--reload - reload the parameter files and SIDs
--save_config - saves configuration changes to parameter file

-- 12.	�������� ������ ����� ��������, ������������� ��������� LISTENER. 

