CREATE TABLE [Inst].[today_ajb]
(
[dtId] [tinyint] NOT NULL IDENTITY(1, 1),
[dt] [date] NOT NULL CONSTRAINT [DF__today_ajb__dt__0F624AF8] DEFAULT (getdate()),
[duration] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Inst].[today_ajb] ADD CONSTRAINT [onlyOne_inst_today_ajb] CHECK (([dtID]=(1)))
GO
