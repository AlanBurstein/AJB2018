SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[getDeadlockGraphFlattened]() RETURNS TABLE AS RETURN
SELECT TOP (1000000000000)
  currentdb          = db.[name],
  deadlockid         = 
  	dl.deadLockGraph.value('(deadlock/victim-list/victimProcess/@id)[1]', 'varchar(200)'),
  processId          = processList.process.value('(@id)',                 'varchar(200)'),
  waittime           = processList.process.value('(@waittime)',           'varchar(200)'),
  transactionname    = processList.process.value('(@transactionname)',    'varchar(200)'),
  lasttranstarted    = processList.process.value('(@lasttranstarted)',    'varchar(200)'),
  lastbatchstarted   = processList.process.value('(@lastbatchstarted)',   'varchar(200)'),
  lastbatchcompleted = processList.process.value('(@lastbatchcompleted)', 'varchar(200)'),
  lockMode           = processList.process.value('(@lockMode)',           'varchar(200)'),
  clientapp          = processList.process.value('(@clientapp)',          'varchar(200)'),
  hostname           = processList.process.value('(@hostname)',           'varchar(200)'),
  loginname          = processList.process.value('(@loginname)',          'varchar(200)'),
  isolationlevel     = processList.process.value('(@isolationlevel)',     'varchar(200)'),
  queryInfo          = processList.process.query('inputbuf/text()'),
  resourceList       = dl.deadLockGraph.query('(//resource-list)[1]'),
  dl.deadLockGraph
--lockTimeout        = processList.process.value('(@lockTimeout)',        'varchar(200)'),
--objectname         = process.value('(../../resource-list/keylock/@objectname)[1]', 'varchar(200)'),
FROM dbo.getDeadlockGraph() dl
CROSS APPLY dl.deadLockGraph.nodes('/deadlock/process-list/process') processList(process)
JOIN sys.databases db ON db.database_id = processList.process.value('(@currentdb)', 'int')
WHERE processList.process.value('(@transactionname)', 'varchar(200)') = 'SELECT'
ORDER BY lasttranstarted;
GO
