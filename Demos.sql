--Palestra Casos de concorrência no TEMPDB

--Caso 1:
--Criar Default Constraint 
USE SabComElas; EXEC spu_tempdefault;

USE tempdb; SELECT * FROM sys.objects WHERE NAME LIKE '%dfNome%';
USE tempdb; SELECT * FROM sys.objects WHERE object_id =  ;

--Caso 2:
--Lock no tempdb
USE SabComElas; EXEC spu_tempObj1;
USE SabComElas; EXEC spu_tempObj2;

SELECT wait_type, last_wait_type, wait_resource,blocking_session_id,* 
FROM sys.dm_exec_sessions s
INNER JOIN sys.dm_exec_requests r on s.session_id = r.session_id
WHERE s.session_id > 50
AND login_name <> 'sa'

--Artigo Kendra
--https://littlekendra.com/2016/10/17/decoding-key-and-page-waitresource-for-deadlocks-and-blocking/
SELECT object_name(object_id),*
FROM sys.partitions
WHERE partition_id = 

--ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA = ON

--Caso 3:
--Estouro log Tempdb com transação aberta
USE SabComElas; EXEC spu_demo3; 

select @@TRANCOUNT

exec sp_readerrorlog 0,1,'tempdb';

SELECT SIZE*8/1024,* 
FROM SYS.DATABASE_FILES;
DBCC SHRINKFILE (2,50);

--Executar em duas conexões diferentes:

USE SabComElas;
--DROP TABLE #tempDefault
CREATE TABLE #tempDefault (id INT IDENTITY,
							nome VARCHAR(500));
GO

BEGIN TRAN;
GO

--INSERT INTO #tempDefault
--SELECT p.palestrante
--FROM palestra p
--GO 100

UPDATE #tempDefault SET nome = 'Nane Flores' 
UPDATE #tempDefault SET nome = 'Raiane Lins' 

COMMIT

--Caso 4:
--Estouro log Tempdb sem Transação aberta

USE SabComElas
SELECT top 200 p.palestrante
FROM palestra2 p
ORDER BY p.palestrante desc
OPTION (MAXDOP 6)
