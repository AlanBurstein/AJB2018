SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJsonTest2]
WITH SCHEMABINDING AS 
SELECT
  id,
  [300] = JSON_VALUE(jt.jdata,'$."300"'),
  [305] = JSON_VALUE(jt.jdata,'$."305"'),
  [313] = JSON_VALUE(jt.jdata,'$."313"'),
  [315] = JSON_VALUE(jt.jdata,'$."315"'),
  [317] = JSON_VALUE(jt.jdata,'$."317"'),
  [319] = JSON_VALUE(jt.jdata,'$."319"'),
  [321] = JSON_VALUE(jt.jdata,'$."321"'),
  [323] = JSON_VALUE(jt.jdata,'$."323"'),
  [324] = JSON_VALUE(jt.jdata,'$."324"'),
  [325] = JSON_VALUE(jt.jdata,'$."325"'),
  [348] = JSON_VALUE(jt.jdata,'$."348"'),
  [350] = JSON_VALUE(jt.jdata,'$."350"'),
  [364] = JSON_VALUE(jt.jdata,'$."364"'),
  [369] = JSON_VALUE(jt.jdata,'$."369"'),
  [371] = JSON_VALUE(jt.jdata,'$."371"'),
  [382] = JSON_VALUE(jt.jdata,'$."382"'),
  [386] = JSON_VALUE(jt.jdata,'$."386"'),
  [390] = JSON_VALUE(jt.jdata,'$."390"'),
  [410] = JSON_VALUE(jt.jdata,'$."410"'),
  [420] = JSON_VALUE(jt.jdata,'$."420"'),
  [608] = JSON_VALUE(jt.jdata,'$."608"'),
  [624] = JSON_VALUE(jt.jdata,'$."624"'),
  [626] = JSON_VALUE(jt.jdata,'$."626"')
FROM dbo.jsonTest jt;
GO
CREATE UNIQUE CLUSTERED INDEX [cl_uq_jsonTest2] ON [dbo].[vwJsonTest2] ([id]) ON [PRIMARY]
GO
