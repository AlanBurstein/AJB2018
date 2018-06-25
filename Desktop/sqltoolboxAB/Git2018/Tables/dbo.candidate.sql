CREATE TABLE [dbo].[candidate]
(
[candidateId] [int] NOT NULL,
[candidateName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[candidateSource] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__candidate__candi__4AB81AF0] DEFAULT ('Unknown'),
[candidateResume] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[resumeDate] [date] NOT NULL CONSTRAINT [DF__candidate__resum__4BAC3F29] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[candidate] ADD CONSTRAINT [pk_cl_dbo_candidate] PRIMARY KEY CLUSTERED  ([candidateId]) ON [PRIMARY]
GO
