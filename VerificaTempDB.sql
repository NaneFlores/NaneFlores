-- 1) Verificar o Log Reuse dos arquivos de Log da tempDB
SELECT name, log_reuse_wait_desc
FROM sys.databases
WHERE database_id = 2

-- 2) Verificar as requisições com mais de 2 horas abertas (de qualquer base de dados)
SELECT s.session_id, s.host_name, s.program_name, s.login_name, r.start_time, r.command
FROM sys.dm_exec_requests r
INNER JOIN sys.dm_exec_sessions s on r.session_id = s.session_id
WHERE r.session_id > 50
AND start_time <= dateadd(hour,-2, getdate())
AND command <> 'WAITFOR'
AND s.group_id <> 1
AND program_name not like 'SQLAgent%'
AND login_name <> 'NT AUTHORITY\SYSTEM'

-- 3) Verificar as transações com mais de 10 minutos e que estão com o status 4(gerou registro de log) 
SELECT s.session_id, 
DB_NAME(dt.database_id),
s.HOST_NAME,
s.last_request_start_time, 
s.login_name, 
s.open_transaction_count, 
dt.database_transaction_state, 
dt.database_transaction_log_record_count, 
dt.database_transaction_log_bytes_used,
dt.database_transaction_log_bytes_reserved, 
database_transaction_begin_lsn,
dt.database_transaction_last_lsn
FROM sys.dm_tran_database_transactions dt
INNER JOIN sys.dm_tran_session_transactions st on dt.transaction_id = st.transaction_id
INNER JOIN sys.dm_exec_sessions s on st.session_id = s.session_id
WHERE dt.database_id = 2
AND s.session_id > 50
AND s.is_user_process = 1
AND dt.database_transaction_state = 4
AND login_name not in ('NT AUTHORITY\SYSTEM','sa')
AND s.last_request_start_time <= DATEADD(MINUTE,-10, GETDATE())
ORDER BY s.last_request_start_time

--4) Verificar todas as requisições abertas há mais que 10 min e que estão consumindo espaço no tempdb
SELECT tsu.session_id,  
   s.last_request_end_time,  
   s.HOST_NAME,   
   s.Login_Name,  
   s.PROGRAM_NAME,  
   CONVERT(DECIMAL(10,2),(tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count)*1./128) AS tempdb_allocations_mb,  
   CONVERT(DECIMAL(10,2),(tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count - tsu.user_objects_dealloc_page_count - tsu.internal_objects_dealloc_page_count)*1./128) AS tempdb_current_allocations_mb,  
   t.Text,  
   'Executando' as Tipo,  
   s.open_transaction_count as TA
 FROM  sys.dm_db_task_space_usage tsu  
 INNER JOIN sys.dm_exec_sessions s ON tsu.session_id = s.session_id  
 INNER JOIN sys.dm_exec_connections c ON s.session_id = c.session_id  
 OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) As t  
 WHERE s.group_id > 1  
--AND CONVERT(DECIMAL(10,2),(tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count)*1./128) > 100
   --AND (user_objects_alloc_page_count + internal_objects_alloc_page_count) > (user_objects_dealloc_page_count + internal_objects_dealloc_page_count)  
--AND ((tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count - tsu.user_objects_dealloc_page_count - tsu.internal_objects_dealloc_page_count)*1./128) > 200

UNION ALL

SELECT tsu.session_id,  
   s.last_request_end_time,  
   s.host_name,   
   s.Login_Name,  
   s.program_name,  
   CONVERT(DECIMAL(10,2),(tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count)*1./128) AS tempdb_allocations_mb,  
   CONVERT(DECIMAL(10,2),(tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count - tsu.user_objects_dealloc_page_count - tsu.internal_objects_dealloc_page_count)*1./128) AS tempdb_current_allocations_mb,  
   t.Text,  
   'Executou' as Tipo,  
   s.open_transaction_count as TA  
 FROM  sys.dm_db_session_space_usage tsu  
 INNER JOIN sys.dm_exec_sessions s ON tsu.session_id = s.session_id  
 INNER JOIN sys.dm_exec_connections c ON s.session_id = c.session_id  
 OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS t  
 WHERE s.group_id > 1  
 --AND CONVERT(DECIMAL(10,2),(tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count)*1./128) > 100
   --AND (user_objects_alloc_page_count + internal_objects_alloc_page_count) > (user_objects_dealloc_page_count + internal_objects_dealloc_page_count)  
  --AND ((tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count - tsu.user_objects_dealloc_page_count - tsu.internal_objects_dealloc_page_count)*1./128) > 200
--order by last_request_end_time 

SELECT * FROM sys.dm_exec_sessions WHERE open_transaction_count > 0


