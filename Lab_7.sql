ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- 1.	Получите полный список фоновых процессов. 
select count(*) from v$bgprocess; 
select name, description from v$bgprocess; 

-- 2.	Определите фоновые процессы, которые запущены и работают в настоящий момент.
select * from v$process where background is not null;
select * from v$process;
select * from v$process inner join v$session on v$session.paddr= v$process.addr  where v$session.username != 'null';

-- 3.	Определите, сколько процессов DBWn работает в настоящий момент.
show parameter db_writer_processes;
select * from v$process where pname like 'DBW%';

-- 4.	Получите перечень текущих соединений с экземпляром.
select * from v$session;

-- 5.	Определите режимы этих соединений.
select username, server from v$session;

-- 6.	Определите сервисы (точки подключения экземпляра).
select * from v$services;

-- 7.	Получите известные вам параметры диспетчера и их значений.
select * from v$dispatcher;
show parameter dispatchers;

-- 8.	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.
-- OracleOraDB19Home1TNSListener

-- 9.	Получите перечень текущих соединений с инстансом. (dedicated, shared). 
SELECT PADDR, USERNAME, SERVER FROM V$SESSION WHERE USERNAME IS NOT NULL;

SELECT ADDR, SPID, PNAME FROM V$PROCESS WHERE BACKGROUND IS NULL ORDER BY PNAME;

-- 10.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 
-- Расположение: C:\app\Admin\product\12.1.0\dbhome_2\NETWORK\ADMIN

-- 11.	Запустите утилиту lsnrctl и поясните ее основные команды. 
--lsnrctl
--help --> start, stop,status - ready, blocked, unknown
--services, version
--servacls - get access control lists
--reload - reload the parameter files and SIDs
--save_config - saves configuration changes to parameter file

-- 12.	Получите список служб инстанса, обслуживаемых процессом LISTENER. 

