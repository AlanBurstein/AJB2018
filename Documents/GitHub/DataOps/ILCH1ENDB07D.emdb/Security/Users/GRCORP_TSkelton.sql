IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\tskelton')
CREATE LOGIN [GRCORP\tskelton] FROM WINDOWS
GO
CREATE USER [GRCORP\TSkelton] FOR LOGIN [GRCORP\tskelton]
GO
