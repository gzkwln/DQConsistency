USE [WRKDQHARMONIZE]
GO
/****** Object:  UserDefinedFunction [dbo].[boaGetWord]    Script Date: 4/23/2026 1:34:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*Copyright (c) 2004 BackOffice Associates, Inc.  All rights reserved. */
/*			Modification Log 			 */
/* Date   		Programmer		Mod No 	 */
/* ------------------------------------------------------------------------------------------------------- */
/*06/22/2004				0		 */
/* This function takes two arguments.  The first is a string and the second is */
/* an int.  The second argument is the index of the word that you want to */
/* from the string.							*/
/* Example: boaGetWord('Hello how are you today', 4) = you		*/
/* 	      boaGetWord('Hello how are you today, 2) = how		*/

CREATE FUNCTION [dbo].[boaGetWord]
(
  @varString AS NVARCHAR(2000),
  @intPosition AS INTEGER)
RETURNS NVARCHAR(2000)
AS
BEGIN
	DECLARE @i AS INTEGER
	DECLARE @j AS INTEGER
	DECLARE @k AS INTEGER
	DECLARE @varResult AS NVARCHAR(2000)

	SET @j = 0
	SET @k = 1
	SET @i = 1
	SET @varString = WRKDQHARMONIZE.dbo.boaTrim(@varString)
						 + ' ^'

	WHILE( @i <= Len(@varString) )
	BEGIN
		IF ( Substring(@varString, @i, 1) = ' '
			  OR Substring(@varString, @i, 1) = '.'
			  /*OR Substring(@varString, @i, 1) = '&'*/
			  OR Substring(@varString, @i, 1) = ','
			  OR Substring(@varString, @i, 1) = '-' 
			  OR Substring(@varString, @i, 1) = '_'
			  OR Substring(@varString, @i, 1) = '|'
			  OR Substring(@varString, @i, 1) = '*')
		   AND Substring(@varString, @k, @i - @k + 1) <> ' '
		BEGIN
			SET @j = @j + 1

			IF @j = @intPosition
			   AND Substring(@varString, @k, @i - @k + 1) <> '^'
			BEGIN
				--SET @varResult = Ltrim(Rtrim(Substring(@varString, @k, @i - @k + 1)))
				SET @varResult = /*REPLACE(*/REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Ltrim(Rtrim(Substring(@varString, @k, @i - @k + 1))), '.', '')/*, '&', '')*/, ',', ''), '-', ''), '_', ''), '|', ''), '*', '')

				RETURN @varResult
				
			END
			ELSE
			BEGIN
				SET @k = @i + 1
			END
		END

		SET @i = @i + 1
	END

	IF @j < @intPosition
	BEGIN
		SET @varResult = NULL
	END
	ELSE
	BEGIN
		SET @varResult = Substring(@varString, @k, 2000)
		--SET @varResult = REPLACE(Substring(@varString, @k, 2000), '_', '')
	END

	RETURN @varResult
	

END




GO
/****** Object:  UserDefinedFunction [dbo].[boaTrim]    Script Date: 4/23/2026 1:34:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[boaTrim]
(
  @String NVARCHAR(2000))
RETURNS NVARCHAR(2000)
AS
BEGIN
	RETURN
	  (SELECT
		 Ltrim(Rtrim(@String)))
END
GO
