IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\amostovoy')
CREATE LOGIN [GRCORP\amostovoy] FROM WINDOWS
GO
CREATE USER [GRCORP\amostovoy] FOR LOGIN [GRCORP\amostovoy]
GO
