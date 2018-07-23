IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\Commitment Desk SQL SEC')
CREATE LOGIN [GRCORP\Commitment Desk SQL SEC] FROM WINDOWS
GO
CREATE USER [GRCORP\Commitment Desk SQL SEC] FOR LOGIN [GRCORP\Commitment Desk SQL SEC]
GO
