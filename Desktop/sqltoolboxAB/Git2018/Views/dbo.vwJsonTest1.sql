SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJsonTest1]
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
  [190] = JSON_VALUE(jt.jdata,'$."190"')
FROM dbo.jsonTest jt;
GO
CREATE UNIQUE CLUSTERED INDEX [cl_uq_jsonTest1] ON [dbo].[vwJsonTest1] ([id]) ON [PRIMARY]
GO
