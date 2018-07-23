CREATE SCHEMA [reports]
AUTHORIZATION [dbo]
GO
GRANT EXECUTE ON SCHEMA:: [reports] TO [GRCORP\SSRS_DataSource_Dev]
GO
GRANT EXECUTE ON SCHEMA:: [reports] TO [reportuser]
GO
GRANT SELECT ON SCHEMA:: [reports] TO [reportuser]
GO
