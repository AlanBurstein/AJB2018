IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\gellett')
CREATE LOGIN [GRCORP\gellett] FROM WINDOWS
GO
CREATE USER [GRCORP\GEllett] FOR LOGIN [GRCORP\gellett]
GO
