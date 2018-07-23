IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\rwogsland')
CREATE LOGIN [GRCORP\rwogsland] FROM WINDOWS
GO
CREATE USER [grcorp\rwogsland] FOR LOGIN [GRCORP\rwogsland]
GO
