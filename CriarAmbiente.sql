USE MASTER

CREATE DATABASE SabComElas
ON
( NAME = SabComElas_dat,
    FILENAME = 'D:\SQLServer\Data\SabComElas_14.mdf',
    SIZE = 10,
    FILEGROWTH = 1024MB )
LOG ON
( NAME = SabComElas_log,
    FILENAME = 'D:\SQLServer\Log\SabComElas_14.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1024MB  ) ;
GO

USE SabComElas
CREATE TABLE palestra (id INT IDENTITY,
						descricao VARCHAR(1000),
						palestrante VARCHAR (500),
						data DATETIME DEFAULT GETDATE());
GO

INSERT INTO palestra (descricao, palestrante)
VALUES ('Alto desempenho com Databricks','Izabella Bauer'),
 ('Tempdb: casos de concorrência','Raiane Lins'),
 ('Performance e query optimizer','Suh Moraes'),
 ('Migrando seu BD On Premisse para a Nuvem','Sulamita Dantas')
 GO 1000

/************************************************************************************************************************/
/*************************************Criar procedures, caso 1***********************************************************/
/************************************************************************************************************************/

CREATE PROCEDURE spu_tempDefault 
AS
BEGIN
CREATE TABLE #tempDefault (id INT IDENTITY,
							nome VARCHAR(500) CONSTRAINT dfNome DEFAULT 'Nane')

INSERT INTO #tempDefault (nome)
SELECT p.palestrante
FROM palestra p
INNER JOIN palestra p1 on p.id = p1.id

WHILE 1=1
BEGIN
	SELECT *
	FROM #tempDefault

	WAITFOR DELAY '00:00:30' 
END	 
END

/************************************************************************************************************************/
/*************************************Criar procedures, caso 2***********************************************************/
/************************************************************************************************************************/
USE SabComElas
GO

CREATE procedure spu_tempObj1 
AS
BEGIN

BEGIN TRAN

SELECT p.*
INTO #tempDefaultObj
FROM palestra p

WHILE 1 = 1
BEGIN
	SELECT *
	FROM #tempDefaultObj
	WAITFOR DELAY '00:00:30'
END
 
COMMIT
END;

--Criar procedure 2

CREATE procedure spu_tempObj2
AS
BEGIN

IF EXISTS (SELECT 1 FROM tempdb.sys.objects WHERE name LIKE '%#teste123%')
BEGIN
	DROP TABLE #teste123
END
CREATE TABLE #teste123 (id INT,
						data DATETIME)

INSERT INTO #teste123
VALUES (1,GETDATE())
	 
END;


/************************************************************************************************************************/
/*************************************Criar procedures, caso 3***********************************************************/
/************************************************************************************************************************/

USE SabComElas
GO

CREATE PROCEDURE spu_demo3 
AS
BEGIN

CREATE TABLE #tempData (data DATETIME)

BEGIN TRAN

INSERT INTO #tempData values (GETDATE())

WHILE 1 = 1
BEGIN
	UPDATE #tempData SET data = GETDATE()
	WAITFOR DELAY '00:15:00'
END
 
COMMIT
END;


