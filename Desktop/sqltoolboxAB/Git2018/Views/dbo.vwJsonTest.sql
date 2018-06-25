SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJsonTest]
WITH SCHEMABINDING AS 
SELECT
  id,
  [4]   = JSON_VALUE(jt.jdata,'$."4"'),
  [11]  = JSON_VALUE(jt.jdata,'$."11"'),
  [12]  = JSON_VALUE(jt.jdata,'$."12"'),
  [14]  = JSON_VALUE(jt.jdata,'$."14"'),
  [15]  = JSON_VALUE(jt.jdata,'$."15"'),
  [16]  = JSON_VALUE(jt.jdata,'$."16"'),
  [19]  = JSON_VALUE(jt.jdata,'$."19"'),
  [31]  = JSON_VALUE(jt.jdata,'$."31"'),
  [36]  = JSON_VALUE(jt.jdata,'$."36"'),
  [37]  = JSON_VALUE(jt.jdata,'$."37"'),
  [38]  = JSON_VALUE(jt.jdata,'$."38"'),
  [65]  = JSON_VALUE(jt.jdata,'$."65"'),
  [67]  = JSON_VALUE(jt.jdata,'$."67"'),
  [137] = JSON_VALUE(jt.jdata,'$."137"'),
  [142] = JSON_VALUE(jt.jdata,'$."142"'),
  [154] = JSON_VALUE(jt.jdata,'$."154"'),
  [155] = JSON_VALUE(jt.jdata,'$."155"'),
  [190] = JSON_VALUE(jt.jdata,'$."190"'),
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
CREATE UNIQUE CLUSTERED INDEX [cl_uq_jsonTest] ON [dbo].[vwJsonTest] ([id]) ON [PRIMARY]
GO
