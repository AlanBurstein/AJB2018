IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\NonSeniorDevelopersAccess')
CREATE LOGIN [GRCORP\NonSeniorDevelopersAccess] FROM WINDOWS
GO
CREATE USER [GRCORP\NonSeniorDevelopersAccess] FOR LOGIN [GRCORP\NonSeniorDevelopersAccess]
GO
