CREATE ROLE [db_executor]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'db_executor', N'GRCORP\ORG_SSIS_D'
GO
GRANT EXECUTE TO [db_executor]
