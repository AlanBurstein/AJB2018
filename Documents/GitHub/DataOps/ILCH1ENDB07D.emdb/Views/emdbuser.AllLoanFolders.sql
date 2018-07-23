SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [emdbuser].[AllLoanFolders]
as
(
	SELECT IsNull(LSFolders.LoanFolder, LoanFolder.FolderName) as FolderName, 
		(case when LoanFolder.Archive = 'Y' then '<' + LoanFolder.FolderName + '>' else IsNull(LSFolders.LoanFolder, LoanFolder.FolderName) end) as DisplayName,
		IsNull(LoanFolder.Active, 'Y') as Active,
		IsNull(LoanFolder.Trash, 'N') as Trash,
		IsNull(LoanFolder.Archive, 'N') as Archive
	FROM (SELECT DISTINCT LoanFolder from LoanSummary) LSFolders
		FULL OUTER JOIN LoanFolder on LSFolders.LoanFolder = LoanFolder.FolderName
)

GO
