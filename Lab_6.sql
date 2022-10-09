-- 1.	Определите общий размер области SGA.
select * from V$SGA;
select SUM(value) from v$sga;

-- 2.	Определите текущие размеры основных пулов SGA.
select * from v$sga_dynamic_components  where current_size > 0;

-- 3.	Определите размеры гранулы для каждого пула.
select component, granule_size from v$sga_dynamic_components  where current_size > 0;

-- 4.	Определите объем доступной свободной памяти в SGA.
select current_size from v$sga_dynamic_free_memory;

-- 5.	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.
select component, current_size, min_size from v$sga_dynamic_components  where component='KEEP buffer cache' or component='DEFAULT buffer cache' or component='RECYCLE buffer cache'; 

-- 6.	Создайте таблицу, которая будут помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
create table MyTable(x int) storage(buffer_pool keep);
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name) like '%mytable%';
drop table MyTable;

-- 7.	Создайте таблицу, которая будут кэшироваться в пуле default. Продемонстрируйте сегмент таблицы. 
create table MyTable2(x int) storage(buffer_pool default);
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name)='mytable2';

-- 8.	Найдите размер буфера журналов повтора.
show parameter log_buffer;

-- 9.	Найдите 10 самых больших объектов в разделяемом пуле.
select *from (select pool, name, bytes from v$sgastat where pool = 'shared pool' order by bytes desc) where rownum <=10;

-- 10.	Найдите размер свободной памяти в большом пуле.
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

-- 11.	Получите перечень текущих соединений с инстансом. 
select * from v$session;

-- 12.	Определите режимы текущих соединений с инстансом (dedicated, shared).
select username, server from v$session;

-- 13.	*Найдите самые часто используемые объекты в базе данных.


