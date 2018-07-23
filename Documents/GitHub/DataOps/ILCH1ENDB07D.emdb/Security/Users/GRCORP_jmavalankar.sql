IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\jmavalankar')
CREATE LOGIN [GRCORP\jmavalankar] FROM WINDOWS
GO
CREATE USER [GRCORP\jmavalankar] FOR LOGIN [GRCORP\jmavalankar]
GO
GRANT VIEW DEFINITION TO [GRCORP\jmavalankar]
