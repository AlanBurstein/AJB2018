IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\pnewman')
CREATE LOGIN [GRCORP\pnewman] FROM WINDOWS
GO
CREATE USER [GRCORP\pnewman] FOR LOGIN [GRCORP\pnewman]
GO
