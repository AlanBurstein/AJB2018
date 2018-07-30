IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\JMiller')
CREATE LOGIN [GRCORP\JMiller] FROM WINDOWS
GO
CREATE USER [GRCORP\JMiller] FOR LOGIN [GRCORP\JMiller] WITH DEFAULT_SCHEMA=[emdbuser]
GO
GRANT SHOWPLAN TO [GRCORP\JMiller]
GRANT VIEW DEFINITION TO [GRCORP\JMiller]