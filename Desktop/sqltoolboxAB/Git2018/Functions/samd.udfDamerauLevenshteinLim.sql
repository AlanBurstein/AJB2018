SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Copyright 2011-2012 Tom Keller Consulting (free to use if you keep this notice) http://fuzzy-string.com/
CREATE FUNCTION [samd].[udfDamerauLevenshteinLim] ( -- Ignite=Lim v1.1.0
	@Str1 NVARCHAR(253), @Str2 NVARCHAR(253) -- two less than TINYINT limit
	, @Threshold INT -- limit for edits (must be positive, and should be less than longer string length)
	, @Len2 INT -- columns (precalculate since it will be the same on every comparison in a search)
	, @thisCosts VARCHAR(253) -- precalculate 0th row -- NVARCHAR if lengths allowed >253
) /* Returns the Damerau-Levenshtein Distance between strings; NULL if more than @Threshold
 (that is, if you want to exclude diffs of more than 2 edits, pass 2 and check NOT NULL)
Warning: for performance, parameter checks are not done here.
 See prcDamerauLevenshteinSearch for recommended usage!
Note: If you need to override your database default case-sensitivity and accent-sensitivity,
 uncomment and modify the COLLATE clauses in the character equality comparisons.
 (See all the comments including Latin1_General_CS_AS_KS_WS.)
 (Use the same collation in udfDamerauLevenshteinOpHTML if the same Threshold will be used.)
 (Unicode Canonical Equivalence of multi-character sequences cannot be considered here).
*/
RETURNS INT -- see udfDamerauLevenshteinRow0 for more notes, background, and references.
-- WITH RETURNS NULL ON NULL INPUT -- no match if missing parameters (not avail in SQL2000)
-- WITH SCHEMABINDING -- would prevent changing database default collation
AS BEGIN
	DECLARE @prevCosts VARCHAR(253), @prevCosts2 VARCHAR(253) -- NVARCHAR if lengths allowed >253
		, @thisChr1 NCHAR(1), @thisChr2 NCHAR(1), @prevChr1 NCHAR(1), @prevChr2 NCHAR(1) -- UNICODE
		, @thisChg TINYINT -- cost of changing character: zero if same character, else one
		, @Pos2StartBound INT, @Pos2StopBound INT, @Pos2Min INT -- stripe and diagonal
		, @Pos2Start INT, @Pos2Stop INT -- stripe limited to 1..Len2
		, @Pos1 INT, @Pos2 INT -- rows, columns
		, @Len1 INT -- rows (@Len2 columns precalculated)
		-- all the following should be SMALLINT if lengths allowed >253
		, @thisVal TINYINT, @prevVal TINYINT, @aboveVal TINYINT, @diagVal TINYINT, @transVal TINYINT
	
	-- get rows (@Len2 columns precalculated)
	SELECT @Len1 = LEN( @Str1) -- Ignite=Lim Len1
		, @Pos1 = 0
		, @Pos2Min = @Len2 - @Len1
		, @Pos2StartBound = CASE SIGN( @Pos2Min) WHEN 1 THEN @Pos2Min ELSE 0 END -@Threshold
			-- Threshold cells to the left of rightmost diagonal <= leftmost diagonal
		, @Pos2StopBound = CASE SIGN( @Pos2Min) WHEN -1 THEN @Pos2Min ELSE 0 END +@Threshold
			-- Threshold cells to the right of leftmost diagonal >= rightmost diagonal

	WHILE @Pos1 < @Len1 -- Ignite=Lim Loop1
	BEGIN
		SELECT @Pos1 = @Pos1 +1 -- Ignite=Lim Loop1 Start
			, @prevChr1 = @thisChr1 -- NULL on first row so Check Transposed fails
			, @prevCosts2 = @prevCosts -- NULL on first row but unused since Check Transposed fails
			, @thisChr1 = SUBSTRING( @Str1, @Pos1, 1)
			, @Pos2Min = @Pos2Min +1 -- just increment instead of re-calculating from Pos and Len
			, @Pos2StartBound = @Pos2StartBound +1
			, @Pos2StopBound = @Pos2StopBound +1

		-- columns MAX(1,@Pos2StartBound)..MIN(@Len2,@Pos2StopBound)
		IF (@Pos2StopBound > @Len2) -- Ignite=Lim Check Stop
			SELECT @Pos2Stop = @Len2 -- Ignite=Lim Stop
				, @prevCosts = @thisCosts
		ELSE -- previous @Pos2StopBound < @Len2
			SELECT @Pos2Stop = @Pos2StopBound -- Ignite=Lim Not Stop
				, @prevCosts = @thisCosts + CHAR( @Threshold +1) -- needed for aboveVal in last cell of stripe
		IF ( @Pos2StartBound > 1 ) -- Ignite=Lim Check Start
			SELECT @Pos2Start = @Pos2StartBound -- stripe no longer includes first column
				, @prevChr2 = SUBSTRING( @Str2, @Pos2Start -1, 1) -- Ignite=Lim Loop2 Continue
				, @thisCosts = REPLICATE(CHAR(0), @Pos2Start -1) -- place holder before stripe
				, @prevVal = @Threshold +2 -- (@Threshold +1) plus one for insert op
				, @diagVal = ASCII(SUBSTRING( @prevCosts, @Pos2Start -1, 1))
		ELSE
			SELECT @Pos2Start = 1 -- Ignite=Lim Loop2 Init
				, @prevChr2 = NULL
				, @thisCosts = ''
				, @prevVal = @Pos1 +1 -- 0th column plus one for insert op (Pos1 = Threshold+1 if Pos2Start = 1)
				, @diagVal = @Pos1 -1 -- 0th column of row above

		-- actual columns in stripe
		SET @Pos2 = @Pos2Start -- Ignite=Lim Loop2 For
		WHILE @Pos2 <= @Pos2Stop -- Ignite=Lim Loop2
		BEGIN
			SELECT @thisChr2 = SUBSTRING( @Str2, @Pos2, 1) -- 50% -- Ignite=Lim Loop2 Start
				, @aboveVal = ASCII(SUBSTRING( @prevCosts, @Pos2, 1)) +1 -- 40% -- plus one for delete op

			-- whether chars are different (uncomment and modify the COLLATE clauses if desired)
				, @thisChg = CASE @thisChr2 -- COLLATE Latin1_General_CS_AS_KS_WS
				  WHEN @thisChr1 -- COLLATE Latin1_General_CS_AS_KS_WS
				  THEN 0 ELSE 1 END -- 50%
			
			-- standard Levenshtein
				, @thisVal = @diagVal + @thisChg -- 10%
			IF ( @aboveVal < @thisVal) -- Ignite=Lim Check Delete
				SET @thisVal = @aboveVal -- deletion of @thisChr1 from @Str1 -- Ignite=Lim Delete
			IF ( @prevVal < @thisVal) -- Ignite=Lim Check Insert
				SET @thisVal = @prevVal -- insertion of @thisChr2 into @Str1 AFTER @thisChr1 -- Ignite=Lim Insert
			
			-- direct Damerau: check for transposition (uncomment and modify the COLLATE clauses if desired)
			IF ( @thisChr1 -- COLLATE Latin1_General_CS_AS_KS_WS
			  = @prevChr2 -- COLLATE Latin1_General_CS_AS_KS_WS
			  AND @prevChr1 -- COLLATE Latin1_General_CS_AS_KS_WS
			  = @thisChr2 -- COLLATE Latin1_General_CS_AS_KS_WS
			  AND @prevChr1 -- COLLATE Latin1_General_CS_AS_KS_WS
			  <> @thisChr1 -- COLLATE Latin1_General_CS_AS_KS_WS
			  ) -- Ignite=Lim Check Transposed
			BEGIN
				SET @transVal = CASE @Pos2 WHEN 2 THEN @Pos1 -2 -- 0th column of 2nd row above -- Ignite=Lim TransCost
					ELSE ASCII(SUBSTRING( @prevCosts2, @Pos2 -2, 1)) END +1 -- plus one for transpose op
				IF ( @transVal < @thisVal ) -- do not overlap consecutive transpositions -- Ignite=Lim Chk TransCost
					SET @thisVal = @transVal -- Ignite=Lim Transposed
			END

			-- if on diagonal to bottom-right, and past threshold, stop!
			IF ( @Pos2 = @Pos2Min ) -- Ignite=Lim Check Diagonal
				IF ( @thisVal > @Threshold ) -- Ignite=Lim Check Threshold
					RETURN (NULL)
			SELECT @thisCosts = @thisCosts + CHAR( @thisVal) -- Ignite=Lim Loop2 End
				, @prevVal = @thisVal +1 -- plus one for insert op
				, @Pos2 = @Pos2 +1
				, @prevChr2 = @thisChr2
				, @diagVal = @aboveVal -1 -- no longer plus one for delete op
		END
	END
	RETURN (@thisVal) -- bottom-right cell is actual cost -- Ignite=Lim RETURN
END
GO
