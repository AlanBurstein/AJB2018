IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\Database Developers')
CREATE LOGIN [GRCORP\Database Developers] FROM WINDOWS
GO
CREATE USER [GRCORP\Database Developers] FOR LOGIN [GRCORP\Database Developers]
GO
GRANT EXECUTE TO [GRCORP\Database Developers]
GRANT SHOWPLAN TO [GRCORP\Database Developers]
GRANT VIEW DEFINITION TO [GRCORP\Database Developers]
