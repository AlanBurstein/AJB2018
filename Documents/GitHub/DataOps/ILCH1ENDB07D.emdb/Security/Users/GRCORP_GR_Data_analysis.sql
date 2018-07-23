IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\GR_Data_analysis')
CREATE LOGIN [GRCORP\GR_Data_analysis] FROM WINDOWS
GO
CREATE USER [GRCORP\GR_Data_analysis] FOR LOGIN [GRCORP\GR_Data_analysis]
GO
