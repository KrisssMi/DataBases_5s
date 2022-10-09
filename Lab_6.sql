-- 1.	���������� ����� ������ ������� SGA.
select * from V$SGA;
select SUM(value) from v$sga;

-- 2.	���������� ������� ������� �������� ����� SGA.
select * from v$sga_dynamic_components  where current_size > 0;

-- 3.	���������� ������� ������� ��� ������� ����.
select component, granule_size from v$sga_dynamic_components  where current_size > 0;

-- 4.	���������� ����� ��������� ��������� ������ � SGA.
select current_size from v$sga_dynamic_free_memory;

-- 5.	���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.
select component, current_size, min_size from v$sga_dynamic_components  where component='KEEP buffer cache' or component='DEFAULT buffer cache' or component='RECYCLE buffer cache'; 

-- 6.	�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.
create table MyTable(x int) storage(buffer_pool keep);
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name) like '%mytable%';
drop table MyTable;

-- 7.	�������� �������, ������� ����� ������������ � ���� default. ����������������� ������� �������. 
create table MyTable2(x int) storage(buffer_pool default);
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name)='mytable2';

-- 8.	������� ������ ������ �������� �������.
show parameter log_buffer;

-- 9.	������� 10 ����� ������� �������� � ����������� ����.
select *from (select pool, name, bytes from v$sgastat where pool = 'shared pool' order by bytes desc) where rownum <=10;

-- 10.	������� ������ ��������� ������ � ������� ����.
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

-- 11.	�������� �������� ������� ���������� � ���������. 
select * from v$session;

-- 12.	���������� ������ ������� ���������� � ��������� (dedicated, shared).
select username, server from v$session;

-- 13.	*������� ����� ����� ������������ ������� � ���� ������.


