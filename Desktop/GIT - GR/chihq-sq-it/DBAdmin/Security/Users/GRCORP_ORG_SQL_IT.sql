IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\ORG_SQL_IT')
CREATE LOGIN [GRCORP\ORG_SQL_IT] FROM WINDOWS
GO
CREATE USER [GRCORP\ORG_SQL_IT] FOR LOGIN [GRCORP\ORG_SQL_IT] WITH DEFAULT_SCHEMA=[db_owner]
GO