-- 1.	Найдите на компьютере конфигурационные файлы SQLNET.ORA и TNSNAMES.ORA и ознакомьтесь с их содержимым.
-- C:\app\Admin\product\12.1.0\dbhome_2\NETWORK\ADMIN

-- 2.	Соединитесь при помощи sqlplus с Oracle как пользователь SYSTEM, получите перечень 
-- параметров экземпляра Oracle.
show parameter instance;

-- 3.	Соединитесь при помощи sqlplus с подключаемой базой данных как пользователь SYSTEM, 
-- получите список табличных пространств, файлов табличных пространств, ролей и пользователей.
select * from v$tablespace;
select * from sys.dba_data_files;
select * from dba_role_privs;
select * from all_users;

-- 4.	Ознакомьтесь с параметрами в HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE на вашем компьютере.
-- Указывает расположение файлов установщика Oracle Universal. (смотреть в реестре)

-- 5.	Запустите утилиту Oracle Net Manager и подготовьте строку подключения с именем имя_вашего_пользователя_SID, 
-- где SID – идентификатор подключаемой базы данных.

-- 6.	Подключитесь с помощью sqlplus под собственным пользователем и с применением подготовленной строки подключения. 
connect PDB_Admin/qwer12345A@localhost:1521/My_PDB;

-- 7. 	Выполните select к любой таблице, которой владеет ваш пользователь.
select * from MKV_t;

-- 8.	Ознакомьтесь с командой HELP. Получите справку по команде TIMING. Подсчитайте, сколько времени длится select к любой таблице.
-- help timing
-- > timi start
-- > timi show
-- > timi stop

-- 9.	Ознакомьтесь с командой DESCRIBE. Получите описание столбцов любой таблицы.
describe MKV_t;

-- 10.	Получите перечень всех сегментов, владельцем которых является ваш пользователь.
select * from dba_segments where owner = 'U1_MKV_PDB';  
select * from user_segments;                            

-- 11.	Создайте представление, в котором получите количество всех сегментов, количество экстентов, блоков памяти и размер в килобайтах, которые они занимают.
create or replace view Lab08 as select 
    count(*) as count,
    sum(extents) as count_extents,
    sum(blocks) as count_blocks,
    sum(bytes) as Kb from user_segments;
    
select * from Lab08;


show user;