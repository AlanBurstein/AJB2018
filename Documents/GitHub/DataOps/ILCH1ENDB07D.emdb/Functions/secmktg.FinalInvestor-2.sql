SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [secmktg].[FinalInvestor-2]
(@Investor varchar(64))
RETURNS varchar(64)
AS
BEGIN
declare @return varchar(64)
select @return = case 

when @Investor like 'Accredited%Home%' then 'Accredited Home'
when @Investor in ('AFFILIATED CORRESPONDENT') then 'AMC'
when @Investor like 'Alliant%' then 'Alliant Credit Union'
when @Investor in ('Alliant Credit Union') then 'Alliant Credit Union'
when @Investor like 'ALS%' then 'ALS'
when @Investor in ('ARGENT','ARGENT MORTGAGE') then 'Argent'
when @Investor like 'Astoria%' then 'Astoria'
when @Investor in ('BANK OF ANN ARBOR') then 'Bank of Ann Arbor'
when @Investor in ('Bear Stearns','Bear Sterns') then 'Bear Stearns'
when @Investor in ('Bank of America Correspondent','BOA','Countrywide','Bank of America','b of a','Countrywide Correspondent','Countrywide Securities Corporation') then 'BofA'
when @Investor in ('ANK OF AMERICA CORRESPONDENT') then 'BofA'
when @Investor like ('Bank%America%') then 'BofA'
when @Investor in ('BNC BROKER') then 'BNC'
when @Investor in ('Centennial Mortgage & Funding, Inc.') then 'Centennial Mortgage'
when @Investor in ('CHASE RURAL','Chase Rural Development - Corresponde','Chase Rural Development - Correspondent') then 'Chase RD'
when @Investor like 'Chase%Rural%' then 'Chase RD'
when @Investor like 'Chase%' then 'Chase'
when @Investor like 'Citi%' then 'Citi Mortgage'
when @Investor in ('decision 1','Decision One') then 'Decision One'
when @Investor like 'Everbank%' then 'Everbank'
when @Investor like 'Evergreen%' then 'Evergreen Private Bank'
when @Investor like 'GRI - Fannie Mae%' then 'Fannie Mae'
when @Investor like 'Fannie Mae%' then 'Fannie Mae'
when @Investor like 'Fifth%third%' then 'Fifth Third Bank'
when @Investor like '5%3%' then 'Fifth Third Bank'
when @Investor in ('5th 3rd') then 'Fifth Third Bank'
when @Investor in ('FIRST AMERICAN BANK','First American') then 'First American Bank'
when @Investor like 'Flagstar%' then 'Flagstar'
when @Investor like 'Financial%Freedom%' then 'Financial Freedom'
when @Investor like 'Franklin%American%' then 'Franklin American'
when @Investor like 'Freddie%' then 'Freddie Mac'
when @Investor like 'GRI - Freddie Mac%' then 'Freddie Mac'
when @Investor in ('FREEMONT INVESTMENT & LOAN','FREMONT INVESTMENT AND LOAN') then 'Freemont Investment & Loan'
when @Investor like 'GB%Home%Equity' then 'GB Home Equity'
when @Investor like 'GMAC%' then 'GMAC'
when @Investor in ('GR','Guaranteed Rate','GUARANTEED RATE, INC.','REPURCHASE') then 'Guaranteed Rate'
when @Investor in ('017445181','655753066','abc') then 'Guaranteed Rate'
when @Investor in ('harris','HARRIS BANK','Harris Bank Broker','HARRIS BANK N.A.') then 'Harris Bank'
when @Investor like 'HSBC%' then 'HSBC'
when @Investor like 'IndyMac%' then 'IndyMac'
when @Investor like 'ING%' then 'ING'
when @Investor in ('JAMES B. NUTTER','JAMES B. NUTTER','JAMES B NUTTER') then 'JB Nutter'
when @Investor in ('M & I BANK','M&I Bank','M&I Broker') then 'M&I Bank'
when @Investor like 'MN%Bond%' then 'MN Bond'
when @Investor in ('National Broker','National City','National City Broker','National City Correspondent','NATIONAL CITY HOME EQUITY','National City Mortgage Broker','National City Mortgage Correspondent') then 'National City'
when @Investor in ('NCM','NCM Broker','NCM Correspondent','New Century','New Century Correspondent') then 'New Century'
when @Investor in ('OHIO','Ohio Savings') then 'Ohio Savings'
when @Investor in ('OWN IT') then 'Own It'
when @Investor in ('Radian Guaranty, Inc') then 'Radian Guaranty'
when @Investor in ('Redwood') then 'Redwood'
when @Investor in ('SOUTHSTAR FUNDING') then 'Southstar Funding'
when @Investor in ('PNA Bank','PNA Bank Broker') then 'PNA Bank'
when @Investor like 'Suntrust%' then 'Suntrust'
when @Investor in ('Taylor Bean','Taylor Bean & Whitaker','TAYLOR BEAN AND WHITAKER','TAYLOR BEAN WHITAKER','Taylor Bean Whitaker Correspondent') then 'Taylor Bean & Whitaker'
when @Investor in ('TCF','TCF BANK','TCF Bank Broker') then 'TCF Bank'
when @Investor in ('U.S. Bank Home Mortgage','U.S. BANK','US Bank','US Bank  EZD','US Bank - EZD','US Bank Broker','US Bank Correspondent','US Bank Correspondent - EZD','US Bank EZD','US Bank -EZD','USBANK') then 'US Bank'
when @Investor like 'USBANK%' then 'US Bank'
when @Investor in ('Wachovia Broker') then 'Wachovia'
when @Investor in ('WAMU Broker','WAMU Correspondent','Washington Mutual','Washington Mutual Bank WHS','Washington Mutual Broker') then 'Washington Mutual'
when @Investor in ('WC','Wells','WELLS CORRESPONDANT') then 'Wells Fargo'
when @Investor like 'Well%' then 'Wells Fargo'
when @Investor in ('WMC','WMC Broker','WMC Mortgage') then 'WMC Mortgage'
when len(@Investor)<3 then 'Blank'
else @Investor
end

return @return
end















GO
