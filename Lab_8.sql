-- 1.	������� �� ���������� ���������������� ����� SQLNET.ORA � TNSNAMES.ORA � ������������ � �� ����������.
-- C:\app\Admin\product\12.1.0\dbhome_2\NETWORK\ADMIN

-- 2.	����������� ��� ������ sqlplus � Oracle ��� ������������ SYSTEM, �������� �������� 
-- ���������� ���������� Oracle.
show parameter instance;

-- 3.	����������� ��� ������ sqlplus � ������������ ����� ������ ��� ������������ SYSTEM, 
-- �������� ������ ��������� �����������, ������ ��������� �����������, ����� � �������������.
select * from v$tablespace;
select * from sys.dba_data_files;
select * from dba_role_privs;
select * from all_users;

-- 4.	������������ � ����������� � HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE �� ����� ����������.
-- ��������� ������������ ������ ����������� Oracle Universal. (�������� � �������)

-- 5.	��������� ������� Oracle Net Manager � ����������� ������ ����������� � ������ ���_������_������������_SID, 
-- ��� SID � ������������� ������������ ���� ������.

-- 6.	������������ � ������� sqlplus ��� ����������� ������������� � � ����������� �������������� ������ �����������. 
connect PDB_Admin/qwer12345A@localhost:1521/My_PDB;

-- 7. 	��������� select � ����� �������, ������� ������� ��� ������������.
select * from MKV_t;

-- 8.	������������ � �������� HELP. �������� ������� �� ������� TIMING. �����������, ������� ������� ������ select � ����� �������.
-- help timing
-- > timi start
-- > timi show
-- > timi stop

-- 9.	������������ � �������� DESCRIBE. �������� �������� �������� ����� �������.
describe MKV_t;

-- 10.	�������� �������� ���� ���������, ���������� ������� �������� ��� ������������.
select * from dba_segments where owner = 'U1_MKV_PDB';  
select * from user_segments;                            

-- 11.	�������� �������������, � ������� �������� ���������� ���� ���������, ���������� ���������, ������ ������ � ������ � ����������, ������� ��� ��������.
create or replace view Lab08 as select 
    count(*) as count,
    sum(extents) as count_extents,
    sum(blocks) as count_blocks,
    sum(bytes) as Kb from user_segments;
    
select * from Lab08;


show user;