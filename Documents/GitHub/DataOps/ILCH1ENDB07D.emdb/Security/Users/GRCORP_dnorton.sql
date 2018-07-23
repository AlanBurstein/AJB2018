IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\dnorton')
CREATE LOGIN [GRCORP\dnorton] FROM WINDOWS
GO
CREATE USER [GRCORP\dnorton] FOR LOGIN [GRCORP\dnorton]
GO
