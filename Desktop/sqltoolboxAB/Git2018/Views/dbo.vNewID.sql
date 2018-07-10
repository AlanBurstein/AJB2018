SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--====== 1. generate a uniqueidentifier (a way to sneak a uniqueidentifier into an iTVF)
CREATE VIEW [dbo].[vNewID] WITH SCHEMABINDING AS SELECT id = NEWID();
GO
