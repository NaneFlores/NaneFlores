USE MASTER

ALTER DATABASE tempdb MODIFY FILE (
NAME = 'templog',
MAXSIZE = 512MB,
SIZE = 0
);


ALTER DATABASE tempdb MODIFY FILE (
NAME = 'tempdev',
SIZE = 0,
MAXSIZE = 512MB

);

ALTER DATABASE tempdb MODIFY FILE (
NAME = 'temp2',
SIZE = 0,
MAXSIZE = 512MB

);


ALTER DATABASE tempdb MODIFY FILE (
NAME = 'temp3',
SIZE = 0,
MAXSIZE = 512MB

);


ALTER DATABASE tempdb MODIFY FILE (
NAME = 'temp4',
SIZE = 0,
MAXSIZE = 512MB

);

USE TEMPDB;

SELECT SIZE*8/1024,* 
FROM SYS.DATABASE_FILES;


DBCC SHRINKFILE (1,0)
DBCC SHRINKFILE (2,50)
DBCC SHRINKFILE (3,0)
DBCC SHRINKFILE (4,0)
DBCC SHRINKFILE (5,0)

DBCC OPENTRAN()