USE [WRKDQHARMONIZE]
GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_AttributeTableIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[webAttributeConfig_AttributeTableIns] @AttributeID nvarchar(50)
AS
/*
Drops and creates the table associated to the AttributeID AttributeTable_<AttributeID>
*/
DECLARE @DynamicSQL NVARCHAR(MAX)
DECLARE @SQLQuery01 NVARCHAR(MAX)
DECLARE @SQLQuery02 NVARCHAR(MAX)

DECLARE @DataSourceName		   nvarchar(100)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @WHEREClause		   nvarchar(1000)

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT	 ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN '' ELSE CONCAT('WHERE ', @WHEREClause) END


/*Drop if table exists already*/
BEGIN
SET @SQLQuery01 = '
IF OBJECT_ID (N''dbo.AttributeTable_'+@AttributeID+''', N''U'') IS NOT NULL
DROP TABLE [dbo].[AttributeTable_' + @AttributeID + ']'

--PRINT @SQLQuery01
EXECUTE sp_executesql @SQLQuery01;
END

BEGIN
 
/*Retrieve the SELECT statement string*/

SET @SQLQuery02 = '
SELECT *
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+' a
'+@WHEREClause+'
'
--PRINT @SQLQuery02

 
/*create and insert the data into the AttributeTable per AttributeID*/
SET @SQLQuery01 = N'SELECT * INTO [dbo].[AttributeTable_' + @AttributeID + '] FROM (' + @SQLQuery02 + N') AS InsertData;';

--PRINT @SQLQuery01
EXECUTE sp_executesql @SQLQuery01;


/*update the SelectAttributeTable and the AttributeTableLastRefreshedOn column in ztAttributeConfig*/
BEGIN
UPDATE ztAttributeConfig
SET SelectAttributeTable = CONCAT('SELECT * FROM ', 'AttributeTable_', @AttributeID)
, AttributeTableLastRefreshedOn = GETDATE()
FROM ztAttributeConfig
WHERE AttributeID = @AttributeID 
END
 
END


GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryCompleteRecordsUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryCompleteRecordsUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field CompleteRecords of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @WHEREClause		   nvarchar(1000) 

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN 'WHERE ISNULL(CONVERT(NVARCHAR(100),'+@Attribute+'), '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClause, ' AND ISNULL(CONVERT(NVARCHAR(100),'+@Attribute+'), '''') <> '''' ') END



/*get the distinct values from the source table and the checktable*/
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET CompleteRecords = (
SELECT COUNT(*) 
FROM AttributeTable_'+@AttributeID+' a
'+@WHEREClause+'
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)


GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryConsistentMatchGroupsUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryConsistentMatchGroupsUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field ConsistentMatchGroups of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @MatchGroupIDColumn	   nvarchar(100)
DECLARE @WHEREClause		   nvarchar(1000) 
DECLARE @CaseSensitive		   nvarchar(1)

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MatchGroupIDColumn 	= (SELECT ISNULL(MatchGroupIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CaseSensitive			= (SELECT ISNULL(CaseSensitive, 0)			FROM webAttributeConfigVer WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN 'WHERE ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClause, ' AND ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ') END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 0
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET ConsistentMatchGroups = (
SELECT COUNT(*) AS ConsistentMatchGroups
FROM (
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 1
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET ConsistentMatchGroups = (
SELECT COUNT(*) AS ConsistentMatchGroups
FROM (
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END


IF @CheckTable = 'No Checktable'
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET ConsistentMatchGroups = (
SELECT COUNT(*) AS ConsistentMatchGroups
FROM (
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
FROM AttributeTable_'+@AttributeID+'
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END




GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryConsistentRecordsSelectExcelUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryConsistentRecordsSelectExcelUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field ConsistentRecordsSelect of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @MatchGroupIDColumn	   nvarchar(100)
DECLARE @WHEREClauseExcel		   nvarchar(1000) 

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MatchGroupIDColumn 	= (SELECT ISNULL(MatchGroupIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClauseExcel			= (SELECT ISNULL(WHEREClauseExcel, '')			FROM ztAttributeConfig WHERE AttributeID = @AttributeID) 

SET @WHEREClauseExcel = CASE WHEN @WHEREClauseExcel = '' THEN 'WHERE ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClauseExcel, ' AND ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ') END


IF @CheckTable <> 'No Checktable'
BEGIN
SET @SQLQuery02 = '
SELECT /*'+@AttributeTable+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, '+@AttributeTable+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, '+@AttributeTable+'.'+@Attribute+' AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
, [Group] AS AttributeGroup, '+@AttributeTable+'.*
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  '+@AttributeTable+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND '+@AttributeTable+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClauseExcel+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = '+@AttributeTable+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  '+@AttributeTable+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND '+@AttributeTable+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
INNER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY '+@AttributeTable+'.'+@MatchGroupIDColumn+', [Group]*/
'


UPDATE ztAttributeConsistencySummary
SET ConsistentRecordsSelectExcel = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
--EXEC (@SQLQuery02)
END


IF @CheckTable = 'No Checktable'
BEGIN
SET @SQLQuery02 = '
SELECT /*'+@AttributeTable+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, '+@AttributeTable+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, '+@AttributeTable+'.'+@Attribute+' AS AttributeValue
, '+@AttributeTable+'.*
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', '+@AttributeTable+'.'+@Attribute+'
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
'+@WHEREClauseExcel+'
GROUP BY '+@MatchGroupIDColumn+', '+@AttributeTable+'.'+@Attribute+'
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = '+@AttributeTable+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY '+@AttributeTable+'.'+@MatchGroupIDColumn+', '+@AttributeTable+'.'+@Attribute+'*/
'


UPDATE ztAttributeConsistencySummary
SET ConsistentRecordsSelectExcel = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
--EXEC (@SQLQuery02)
END




GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryConsistentRecordsSelectUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryConsistentRecordsSelectUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field ConsistentRecordsSelect of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @MatchGroupIDColumn	   nvarchar(100)
DECLARE @WHEREClause		   nvarchar(1000) 
DECLARE @CaseSensitive		   nvarchar(1)

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MatchGroupIDColumn 	= (SELECT ISNULL(MatchGroupIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CaseSensitive			= (SELECT ISNULL(CaseSensitive, 0)			FROM webAttributeConfigVer WHERE AttributeID = @AttributeID)

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN 'WHERE ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClause, ' AND ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ') END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 0
BEGIN
SET @SQLQuery02 = '
SELECT /*AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, AttributeTable_'+@AttributeID+'.'+@Attribute+' AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
, [Group] AS AttributeGroup, AttributeTable_'+@AttributeID+'.*
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
INNER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+', [Group]*/
'


UPDATE ztAttributeConsistencySummary
SET ConsistentRecordsSelect = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
--EXEC (@SQLQuery02)
END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 1
BEGIN
SET @SQLQuery02 = '
SELECT /*AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
, [Group] AS AttributeGroup, AttributeTable_'+@AttributeID+'.*
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
INNER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+', [Group]*/
'


UPDATE ztAttributeConsistencySummary
SET ConsistentRecordsSelect = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
--EXEC (@SQLQuery02)
END


IF @CheckTable = 'No Checktable'
BEGIN
SET @SQLQuery02 = '
SELECT /*AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, AttributeTable_'+@AttributeID+'.'+@Attribute+' AS AttributeValue
, AttributeTable_'+@AttributeID+'.*
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
FROM AttributeTable_'+@AttributeID+'
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'*/
'


UPDATE ztAttributeConsistencySummary
SET ConsistentRecordsSelect = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
--EXEC (@SQLQuery02)
END




GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryConsistentRecordsUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryConsistentRecordsUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field ConsistentRecords of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @MatchGroupIDColumn	   nvarchar(100)
DECLARE @WHEREClause		   nvarchar(1000) 
DECLARE @CaseSensitive		   nvarchar(1)

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MatchGroupIDColumn 	= (SELECT ISNULL(MatchGroupIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CaseSensitive			= (SELECT ISNULL(CaseSensitive, 0)			FROM webAttributeConfigVer WHERE AttributeID = @AttributeID)

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN 'WHERE ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClause, ' AND ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ') END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 0
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET ConsistentRecords = (
SELECT COUNT(*) AS ConsistentRecords
FROM (
SELECT AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupID, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
, webWebAppCatalogLanguagePhraseList.PhraseOut AS AttributeColumn
, AttributeTable_'+@AttributeID+'.'+@Attribute+' AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
, [Group], AttributeTable_'+@AttributeID+'.*
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
INNER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
) c)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 1
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET ConsistentRecords = (
SELECT COUNT(*) AS ConsistentRecords
FROM (
SELECT AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupID, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
, webWebAppCatalogLanguagePhraseList.PhraseOut AS AttributeColumn
, AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
, [Group], AttributeTable_'+@AttributeID+'.*
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
INNER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
) c)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END



IF @CheckTable = 'No Checktable'
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET ConsistentRecords = (
SELECT COUNT(*) AS ConsistentRecords
FROM (
SELECT AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupID, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
, webWebAppCatalogLanguagePhraseList.PhraseOut AS AttributeColumn
, AttributeTable_'+@AttributeID+'.'+@Attribute+' AS AttributeValue
, AttributeTable_'+@AttributeID+'.*
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
FROM AttributeTable_'+@AttributeID+'
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) = 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
) c)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END




GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryIncompleteRecordsUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryIncompleteRecordsUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field IncompleteRecords of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @WHEREClause		   nvarchar(1000) 

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN 'WHERE ISNULL(CONVERT(NVARCHAR(100),'+@Attribute+'), '''') = '''' ' ELSE CONCAT('WHERE ', @WHEREClause, ' AND ISNULL(CONVERT(NVARCHAR(100),'+@Attribute+'), '''') = '''' ') END



/*get the distinct values from the source table and the checktable*/
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET IncompleteRecords = (
SELECT COUNT(*) 
FROM AttributeTable_'+@AttributeID+' a
'+@WHEREClause+'
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)


GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentMatchGroupsUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentMatchGroupsUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field InconsistentMatchGroups of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @MatchGroupIDColumn	   nvarchar(100)
DECLARE @WHEREClause		   nvarchar(1000)
DECLARE @CaseSensitive		   nvarchar(1)

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MatchGroupIDColumn 	= (SELECT ISNULL(MatchGroupIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CaseSensitive			= (SELECT ISNULL(CaseSensitive, 0)			FROM webAttributeConfigVer WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN 'WHERE ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClause, ' AND ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ') END

print @CheckTable

IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 0
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET InconsistentMatchGroups = (
SELECT COUNT(*) AS InconsistentMatchGroups
FROM (
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END

print @CheckTable


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 1
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET InconsistentMatchGroups = (
SELECT COUNT(*) AS InconsistentMatchGroups
FROM (
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
INNER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS  = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END

print @CheckTable


IF @CheckTable = 'No Checktable'
BEGIN
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET InconsistentMatchGroups = (
SELECT COUNT(*) AS InconsistentMatchGroups
FROM (
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
FROM AttributeTable_'+@AttributeID+'
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)
END

GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentRecordsSelectExcelUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentRecordsSelectExcelUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field InconsistentRecordsSelect of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @MatchGroupIDColumn	   nvarchar(100)
DECLARE @WHEREClauseExcel		   nvarchar(1000) 

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MatchGroupIDColumn 	= (SELECT ISNULL(MatchGroupIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClauseExcel			= (SELECT ISNULL(WHEREClauseExcel, '')			FROM ztAttributeConfig WHERE AttributeID = @AttributeID) 

SET @WHEREClauseExcel = CASE WHEN @WHEREClauseExcel = '' THEN 'WHERE ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClauseExcel, ' AND ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ') END


IF @CheckTable <> 'No Checktable'
BEGIN
SET @SQLQuery02 = '
SELECT /*'+@AttributeTable+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, '+@AttributeTable+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, '+@AttributeTable+'.'+@Attribute+' AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
/*, [Group]  AS AttributeGroup*/
, '+@AttributeTable+'.*
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  '+@AttributeTable+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND '+@AttributeTable+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClauseExcel+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
ON b.'+@MatchGroupIDColumn+' = '+@AttributeTable+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  '+@AttributeTable+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND '+@AttributeTable+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY '+@AttributeTable+'.'+@MatchGroupIDColumn+', [Group]*/
'


UPDATE ztAttributeConsistencySummary
SET InconsistentRecordsSelectExcel = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
EXEC (@SQLQuery02)
END



IF @CheckTable = 'No Checktable'
BEGIN
SET @SQLQuery02 = '
SELECT /*'+@AttributeTable+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, '+@AttributeTable+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, '+@AttributeTable+'.'+@Attribute+' AS AttributeValue
, '+@AttributeTable+'.*
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', '+@AttributeTable+'.'+@Attribute+'
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+'
'+@WHEREClauseExcel+'
GROUP BY '+@MatchGroupIDColumn+', '+@AttributeTable+'.'+@Attribute+'
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
ON b.'+@MatchGroupIDColumn+' = '+@AttributeTable+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY '+@AttributeTable+'.'+@MatchGroupIDColumn+', '+@AttributeTable+'.'+@Attribute+'*/
'


UPDATE ztAttributeConsistencySummary
SET InconsistentRecordsSelectExcel = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
EXEC (@SQLQuery02)
END



GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentRecordsSelectUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentRecordsSelectUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field InconsistentRecordsSelect of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @MatchGroupIDColumn	   nvarchar(100)
DECLARE @WHEREClause		   nvarchar(1000) 
DECLARE @MasterDifferentOrBlankCheck		   nvarchar(1)
DECLARE @CaseSensitive		   nvarchar(1)
DECLARE @ReportType			   nvarchar(50)


SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MatchGroupIDColumn 	= (SELECT ISNULL(MatchGroupIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @MasterDifferentOrBlankCheck			= (SELECT ISNULL(MasterDifferentOrBlankCheck, '0')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CaseSensitive			= (SELECT ISNULL(CaseSensitive, 0)			FROM webAttributeConfigVer WHERE AttributeID = @AttributeID)
SET @ReportType				= (SELECT ISNULL(ReportType, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 


SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN 'WHERE ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ' ELSE CONCAT('WHERE ', @WHEREClause, ' AND ISNULL('+@MatchGroupIDColumn+', '''') <> '''' ') END


IF @CheckTable NOT IN ('No Checktable', '') AND @CaseSensitive = 0
BEGIN
SET @SQLQuery02 = '
SELECT /*AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, CONVERT(NVARCHAR(100),AttributeTable_'+@AttributeID+'.'+@Attribute+') AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
/*, [Group]  AS AttributeGroup*/
, AttributeTable_'+@AttributeID+'.*
, '''+@ReportType+''' AS ReportType
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' = '+@CheckTable+'.LegacyValue01
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+', [Group]*/
'


UPDATE ztAttributeConsistencySummary
SET InconsistentRecordsSelect = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
EXEC (@SQLQuery02)
END



IF @CheckTable NOT IN ('No Checktable', '') AND @CaseSensitive = 1
BEGIN
SET @SQLQuery02 = '
SELECT /*AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, CONVERT(NVARCHAR(100),AttributeTable_'+@AttributeID+'.'+@Attribute+') COLLATE SQL_Latin1_General_CP1_CS_AS AS AttributeValue
, web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01Description AS AttributeDescription
/*, [Group]  AS AttributeGroup*/
, AttributeTable_'+@AttributeID+'.*
, '''+@ReportType+''' AS ReportType
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', [Group]
FROM AttributeTable_'+@AttributeID+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', [Group]
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.'+@CheckTable+'
ON  AttributeTable_'+@AttributeID+'.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
AND AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' = '+@CheckTable+'.SourceSystemID
LEFT OUTER JOIN WRKDQHARMONIZE.dbo.web'+@CheckTable+'LegacyValue01DescriptionList
ON '+@CheckTable+'.zSource = web'+@CheckTable+'LegacyValue01DescriptionList.zSource
AND '+@CheckTable+'.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS = web'+@CheckTable+'LegacyValue01DescriptionList.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+', [Group]*/
'


UPDATE ztAttributeConsistencySummary
SET InconsistentRecordsSelect = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
EXEC (@SQLQuery02)
END


IF @CheckTable IN ('No Checktable', '') AND @MasterDifferentOrBlankCheck = 0
BEGIN
SET @SQLQuery02 = '
SELECT /*AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+' AS MatchGroupIDConsistencyCheck
, AttributeTable_'+@AttributeID+'.'+@SourceSystemIDColumn+' AS SourceSystemID
,*/ CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, CONVERT(NVARCHAR(100),AttributeTable_'+@AttributeID+'.'+@Attribute+') AS AttributeValue
, AttributeTable_'+@AttributeID+'.*
, '''+@ReportType+''' AS ReportType
FROM AttributeTable_'+@AttributeID+'
INNER JOIN
(
SELECT a.'+@MatchGroupIDColumn+', COUNT(*) AS Count
FROM
(
SELECT '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
FROM AttributeTable_'+@AttributeID+'
'+@WHEREClause+'
GROUP BY '+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'
) a
GROUP BY a.'+@MatchGroupIDColumn+'
HAVING COUNT(*) > 1 ) b
ON b.'+@MatchGroupIDColumn+' = AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+'
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
/*ORDER BY AttributeTable_'+@AttributeID+'.'+@MatchGroupIDColumn+', AttributeTable_'+@AttributeID+'.'+@Attribute+'*/
'

UPDATE ztAttributeConsistencySummary
SET InconsistentRecordsSelect = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
EXEC (@SQLQuery02)
END

IF @CheckTable IN ('No Checktable', '') AND @MasterDifferentOrBlankCheck = 1
BEGIN
SET @SQLQuery02 = '
SELECT
    CONCAT('''+@Attribute+''', '' - '', webWebAppCatalogLanguagePhraseList.PhraseOut) AS AttributeColumn
, CONVERT(NVARCHAR(100),T.'+@Attribute+') AS AttributeValue
, T.*
, '''+@ReportType+''' AS ReportType
FROM AttributeTable_'+@AttributeID+' T
LEFT OUTER JOIN webWebAppCatalogLanguagePhraseList ON '''+@Attribute+''' = webWebAppCatalogLanguagePhraseList.Phrase
'+@WHEREClause+'
    AND ISNULL(T.'+@MatchGroupIDColumn+', '''') <> ''''
    -- Crucial step: Only include groups that are inconsistent
    AND T.'+@MatchGroupIDColumn+' IN (
        -- Subquery to find the list of inconsistent '+@MatchGroupIDColumn+' values
        SELECT Master.'+@MatchGroupIDColumn+'
        FROM AttributeTable_'+@AttributeID+' AS Master
        INNER JOIN (
            -- Sub-Subquery to summarize the rest of the group
            SELECT
                '+@MatchGroupIDColumn+',
                -- Get the min/max non-blank values
                MIN(NULLIF('+@Attribute+', '''')) AS MinNonBlankValue,
                MAX(NULLIF('+@Attribute+', '''')) AS MaxNonBlankValue,
                -- Count of non-blank values
                COUNT(NULLIF('+@Attribute+', '''')) AS NonBlankCount
            FROM AttributeTable_'+@AttributeID+'
            WHERE zMaster <> 1 -- The rest of the group
            GROUP BY '+@MatchGroupIDColumn+'
        ) AS Others ON Master.'+@MatchGroupIDColumn+' = Others.'+@MatchGroupIDColumn+'
        WHERE
            Master.zMaster = 1 -- Only focus on the Master record here
            AND (
                -- Condition 1: Master is blank, others are NOT blank
                ( ISNULL(Master.'+@Attribute+', '''') = ''''
                    AND Others.NonBlankCount > 0 )
                OR
                -- Condition 2: Master has a value, but it is different from the others
                (   ISNULL(Master.'+@Attribute+', '''') <> ''''
                    AND Others.NonBlankCount > 0
                    AND ( ISNULL(Master.'+@Attribute+', '''') <> Others.MinNonBlankValue
                          OR ISNULL(Master.'+@Attribute+', '''') <> Others.MaxNonBlankValue )
                )
            )
    )
	'


UPDATE ztAttributeConsistencySummary
SET InconsistentRecordsSelect = @SQLQuery02
WHERE AttributeID = @AttributeID

PRINT @SQLQuery02
EXEC (@SQLQuery02)
END



GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentRecordsUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentRecordsUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field InconsistentRecords of the table ztAttributeConsistencySummary*/
BEGIN

DECLARE @SQLQuery NVARCHAR(MAX)
DECLARE @InconsistentReportTableName NVARCHAR(200) 

SET @InconsistentReportTableName = (SELECT InconsistentReportTableName FROM ztAttributeConsistencySummary
WHERE AttributeID = @AttributeID AND InconsistentReportTableName IS NOT NULL)


SET @SQLQuery = '
UPDATE ztAttributeConsistencySummary
SET InconsistentRecords = (SELECT COUNT(*) FROM '+@InconsistentReportTableName+')
FROM ztAttributeConsistencySummary
WHERE AttributeID = '+@AttributeID+' AND InconsistentReportTableName IS NOT NULL
'

--PRINT @SQLQuery
EXEC (@SQLQuery)

END
GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameIns] @AttributeID nvarchar(50)
AS
/*
Drops and creates the table associated to the AttributeID and puts the name into the column InconsistentReportTableName of the table ztAttributeConsistencySummary
*/
DECLARE @DynamicSQL NVARCHAR(MAX)
DECLARE @SQLQuery01 NVARCHAR(MAX)

/*Drop if table exists already*/
BEGIN
SET @SQLQuery01 = '
IF OBJECT_ID (N''dbo.InconsistentReport_'+@AttributeID+''', N''U'') IS NOT NULL
DROP TABLE [dbo].[InconsistentReport_' + @AttributeID + ']'

--PRINT @SQLQuery01
EXECUTE sp_executesql @SQLQuery01;
END

BEGIN
 
/*Retrieve the SELECT statement string*/
SELECT @DynamicSQL = InconsistentRecordsSelect
FROM ztAttributeConsistencySummary
WHERE AttributeID = @AttributeID
 
/*create and insert the data into the InconsistenReport per AttributeID*/
SET @SQLQuery01 = N'SELECT * INTO [dbo].[InconsistentReport_' + @AttributeID + '] FROM (' + @DynamicSQL + N') AS InsertData;';

--PRINT @SQLQuery01
EXECUTE sp_executesql @SQLQuery01;


/*update the InconsistentReportTableName and the LastRefreshedOn column in ztAttributeConsistencySummary*/
BEGIN
UPDATE ztAttributeConsistencySummary
SET InconsistentReportTableName = CONCAT('InconsistentReport_', @AttributeID)
, LastRefreshedOn = GETDATE()
FROM ztAttributeConsistencySummary
WHERE AttributeID = @AttributeID 
END
 
END


GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionAllIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionAllIns]  
    @zCheckWithinGroup nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @SQL NVARCHAR(MAX) = N'';
    DECLARE @TableName SYSNAME;
    DECLARE @ColumnList NVARCHAR(MAX); 
    DECLARE @TableSchema SYSNAME = 'dbo'; 
    DECLARE @FirstTableName SYSNAME; 
    DECLARE @LastMasterOrderID INT; -- Variable to hold the highest existing ID
    -------------------------------------------------------------------------
    -- 1. Populate the Table List (@TableList)
    -------------------------------------------------------------------------
 
    DECLARE @TableList TABLE (TableName SYSNAME, TableSchema SYSNAME DEFAULT 'dbo');
 
    INSERT INTO @TableList (TableName)
    SELECT InconsistentReportTableName 
    FROM ztAttributeConfig 
    INNER JOIN ztAttributeConsistencySummary 
        ON ztAttributeConfig.AttributeID = ztAttributeConsistencySummary.AttributeID
    WHERE zActive = 1 
      AND InconsistentReportTableName IS NOT NULL 
      AND ztAttributeConfig.zCheckWithinGroup = @zCheckWithinGroup
    ORDER BY InconsistentReportTableName; 
    -- Capture the name of the first table in the list
    SELECT TOP 1 @FirstTableName = TableName FROM @TableList ORDER BY TableName;
 
    -------------------------------------------------------------------------
    -- 2. Auto-Populate/Maintain ztColumnOrderConfig for the current group
    -------------------------------------------------------------------------
 
    -- 2a. Determine the starting point for new MasterOrderIDs: 
    --     Start at 100 if no entries exist, otherwise start after the highest existing ID.
    SELECT @LastMasterOrderID = ISNULL(MAX(MasterOrderID), 0)
    FROM dbo.ztColumnOrderConfig 
    WHERE zCheckWithinGroup = @zCheckWithinGroup AND Active = 1;
 
    -- Set the base offset: if no entries exist, we start the first new ID at 100.
    -- Otherwise, we start numbering from the last existing ID + 5.
    IF @LastMasterOrderID = 0
        SET @LastMasterOrderID = 95; -- 95 + 5 * 1 = 100 for the first new column
 
    IF @FirstTableName IS NOT NULL
    BEGIN
        -- Insert columns only if they do not already exist for this group
        INSERT INTO dbo.ztColumnOrderConfig (zCheckWithinGroup, MasterOrderID, COLUMN_NAME, DATA_TYPE)
        SELECT 
            @zCheckWithinGroup AS zCheckWithinGroup,
            -- Calculation for new MasterOrderID: (Last existing ID) + (ROW_NUMBER * 5)
            @LastMasterOrderID + (ROW_NUMBER() OVER (ORDER BY c.ORDINAL_POSITION) * 5) AS MasterOrderID, 
            c.COLUMN_NAME,
            c.DATA_TYPE
        FROM 
            INFORMATION_SCHEMA.COLUMNS c
        WHERE 
            c.TABLE_NAME = @FirstTableName 
            AND c.TABLE_SCHEMA = @TableSchema
            -- Exclude the zCheckWithinGroup column from the managed list
            AND c.COLUMN_NAME <> 'zCheckWithinGroup' 
            -- Only insert columns that don't already exist for this group
            AND c.COLUMN_NAME NOT IN (
                SELECT COLUMN_NAME 
                FROM dbo.ztColumnOrderConfig 
                WHERE zCheckWithinGroup = @zCheckWithinGroup
            )
        ORDER BY
            c.ORDINAL_POSITION;
    END
 
    -------------------------------------------------------------------------
    -- 3. Generate the Dynamic SQL
    -------------------------------------------------------------------------
 
    DECLARE table_cursor CURSOR LOCAL FOR
        SELECT TableName 
        FROM @TableList;
 
    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @TableName;
 
    -- Safely quote the input variable for use as a string literal in dynamic SQL
    DECLARE @QuotedCheckGroup NVARCHAR(100) = QUOTENAME(@zCheckWithinGroup, '''');
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
 
        -- STEP 3a: Build the column expression string based on config table
        SELECT 
            @ColumnList = STRING_AGG(
                CAST(T.ColumnExpression AS NVARCHAR(MAX)),
                N', '
            ) WITHIN GROUP (ORDER BY T.MasterOrderID) 
        FROM 
            (
                SELECT 
                    mc.MasterOrderID,
                    mc.COLUMN_NAME,
                    CASE 
                        WHEN EXISTS (
                            SELECT 1 
                            FROM INFORMATION_SCHEMA.COLUMNS 
                            WHERE TABLE_NAME = @TableName 
                              AND TABLE_SCHEMA = @TableSchema 
                              AND COLUMN_NAME = mc.COLUMN_NAME
                        ) AND ISNULL(mc.COLUMN_NAMENew, '') = '' --CP 20251215 added condition

                        THEN QUOTENAME(mc.COLUMN_NAME)
						/*CP 20251215 condition for case sensitive columns e.g. where the COLUMN_NAMENew has been used*/
						WHEN EXISTS (
                            SELECT 1 
                            FROM INFORMATION_SCHEMA.COLUMNS 
                            WHERE TABLE_NAME = @TableName 
                              AND TABLE_SCHEMA = @TableSchema 
                              AND COLUMN_NAME = mc.COLUMN_NAME
                        ) AND ISNULL(mc.COLUMN_NAMENew, '') <> '' THEN mc.COLUMN_NAMENew 
                        
                        ELSE N'CAST(NULL AS ' + ISNULL(mc.DATA_TYPE, N'NVARCHAR(MAX)') + N') AS ' + QUOTENAME(mc.COLUMN_NAME)
                    END AS ColumnExpression
                FROM 
                    dbo.ztColumnOrderConfig mc 
                WHERE
                    mc.zCheckWithinGroup = @zCheckWithinGroup  AND mc.Active = 1
            ) AS T;
 
        -- STEP 3b: Concatenate the result into the final @SQL.
        SET @SQL = @SQL + N'
SELECT 
    ' + @QuotedCheckGroup + N' AS zCheckWithinGroup, -- ADDED ONCE AT THE END
    ' + @ColumnList + N'
FROM 
    ' + QUOTENAME(@TableSchema) + N'.' + QUOTENAME(@TableName) + N'
UNION ALL ';
 
        FETCH NEXT FROM table_cursor INTO @TableName;
    END
 
    CLOSE table_cursor;
    DEALLOCATE table_cursor;
 
    -------------------------------------------------------------------------
    -- 4. Final Cleanup and Execution
    -------------------------------------------------------------------------
 
    DECLARE @TargetTableName SYSNAME = 'InconsistentReport_Union_' + @zCheckWithinGroup;
    DECLARE @TargetTableFullName SYSNAME = QUOTENAME(@TableSchema) + '.' + QUOTENAME(@TargetTableName);
 
    IF @SQL LIKE '%UNION ALL '
    BEGIN
        SET @SQL = LEFT(@SQL, LEN(@SQL) - LEN('UNION ALL ')); 
    END
 
    DECLARE @FinalExecSQL NVARCHAR(MAX);
 
    SET @FinalExecSQL = 
        N'IF OBJECT_ID(' + QUOTENAME(@TargetTableFullName, '''') + N') IS NOT NULL 
          DROP TABLE ' + @TargetTableFullName + N';' +
        N'
        SELECT * INTO ' + @TargetTableFullName + N'
        FROM (
            ' + @SQL + N'
        ) AS UnionedData;';
 
    EXEC sp_executesql @FinalExecSQL;
    PRINT 'Successfully created and populated table ' + @TargetTableName;
END

GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionConflictReportsIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionConflictReportsIns]  
    @zCheckWithinGroup nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @SQL NVARCHAR(MAX) = N'';
    DECLARE @TableName SYSNAME;
    DECLARE @ColumnList NVARCHAR(MAX); 
    DECLARE @TableSchema SYSNAME = 'dbo'; 
    DECLARE @FirstTableName SYSNAME; 
    DECLARE @LastMasterOrderID INT; -- Variable to hold the highest existing ID
    -------------------------------------------------------------------------
    -- 1. Populate the Table List (@TableList)
    -------------------------------------------------------------------------
 
    DECLARE @TableList TABLE (TableName SYSNAME, TableSchema SYSNAME DEFAULT 'dbo');
 
    INSERT INTO @TableList (TableName)
    SELECT InconsistentReportTableName 
    FROM ztAttributeConfig 
    INNER JOIN ztAttributeConsistencySummary 
        ON ztAttributeConfig.AttributeID = ztAttributeConsistencySummary.AttributeID
    WHERE zActive = 1 
      AND InconsistentReportTableName IS NOT NULL 
      AND ztAttributeConfig.zCheckWithinGroup = @zCheckWithinGroup
	  AND ReportType = 'Conflict'
    ORDER BY InconsistentReportTableName; 
    -- Capture the name of the first table in the list
    SELECT TOP 1 @FirstTableName = TableName FROM @TableList ORDER BY TableName;
 
    -------------------------------------------------------------------------
    -- 2. Auto-Populate/Maintain ztColumnOrderConfig for the current group
    -------------------------------------------------------------------------
 
    -- 2a. Determine the starting point for new MasterOrderIDs: 
    --     Start at 100 if no entries exist, otherwise start after the highest existing ID.
    SELECT @LastMasterOrderID = ISNULL(MAX(MasterOrderID), 0)
    FROM dbo.ztColumnOrderConfig 
    WHERE zCheckWithinGroup = @zCheckWithinGroup AND Active = 1;
 
    -- Set the base offset: if no entries exist, we start the first new ID at 100.
    -- Otherwise, we start numbering from the last existing ID + 5.
    IF @LastMasterOrderID = 0
        SET @LastMasterOrderID = 95; -- 95 + 5 * 1 = 100 for the first new column
 
    IF @FirstTableName IS NOT NULL
    BEGIN
        -- Insert columns only if they do not already exist for this group
        INSERT INTO dbo.ztColumnOrderConfig (zCheckWithinGroup, MasterOrderID, COLUMN_NAME, DATA_TYPE)
        SELECT 
            @zCheckWithinGroup AS zCheckWithinGroup,
            -- Calculation for new MasterOrderID: (Last existing ID) + (ROW_NUMBER * 5)
            @LastMasterOrderID + (ROW_NUMBER() OVER (ORDER BY c.ORDINAL_POSITION) * 5) AS MasterOrderID, 
            c.COLUMN_NAME,
            c.DATA_TYPE
        FROM 
            INFORMATION_SCHEMA.COLUMNS c
        WHERE 
            c.TABLE_NAME = @FirstTableName 
            AND c.TABLE_SCHEMA = @TableSchema
            -- Exclude the zCheckWithinGroup column from the managed list
            AND c.COLUMN_NAME <> 'zCheckWithinGroup' 
            -- Only insert columns that don't already exist for this group
            AND c.COLUMN_NAME NOT IN (
                SELECT COLUMN_NAME 
                FROM dbo.ztColumnOrderConfig 
                WHERE zCheckWithinGroup = @zCheckWithinGroup
            )
        ORDER BY
            c.ORDINAL_POSITION;
    END
 
    -------------------------------------------------------------------------
    -- 3. Generate the Dynamic SQL
    -------------------------------------------------------------------------
 
    DECLARE table_cursor CURSOR LOCAL FOR
        SELECT TableName 
        FROM @TableList;
 
    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @TableName;
 
    -- Safely quote the input variable for use as a string literal in dynamic SQL
    DECLARE @QuotedCheckGroup NVARCHAR(100) = QUOTENAME(@zCheckWithinGroup, '''');
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
 
        -- STEP 3a: Build the column expression string based on config table
        SELECT 
            @ColumnList = STRING_AGG(
                CAST(T.ColumnExpression AS NVARCHAR(MAX)),
                N', '
            ) WITHIN GROUP (ORDER BY T.MasterOrderID) 
        FROM 
            (
                SELECT 
                    mc.MasterOrderID,
                    mc.COLUMN_NAME,
                    CASE 
                        WHEN EXISTS (
                            SELECT 1 
                            FROM INFORMATION_SCHEMA.COLUMNS 
                            WHERE TABLE_NAME = @TableName 
                              AND TABLE_SCHEMA = @TableSchema 
                              AND COLUMN_NAME = mc.COLUMN_NAME
                        ) AND ISNULL(mc.COLUMN_NAMENew, '') = '' --CP 20251215 added condition

                        THEN QUOTENAME(mc.COLUMN_NAME)
						/*CP 20251215 condition for case sensitive columns e.g. where the COLUMN_NAMENew has been used*/
						WHEN EXISTS (
                            SELECT 1 
                            FROM INFORMATION_SCHEMA.COLUMNS 
                            WHERE TABLE_NAME = @TableName 
                              AND TABLE_SCHEMA = @TableSchema 
                              AND COLUMN_NAME = mc.COLUMN_NAME
                        ) AND ISNULL(mc.COLUMN_NAMENew, '') <> '' THEN mc.COLUMN_NAMENew 
                        
                        ELSE N'CAST(NULL AS ' + ISNULL(mc.DATA_TYPE, N'NVARCHAR(MAX)') + N') AS ' + QUOTENAME(mc.COLUMN_NAME)
                    END AS ColumnExpression
                FROM 
                    dbo.ztColumnOrderConfig mc 
                WHERE
                    mc.zCheckWithinGroup = @zCheckWithinGroup  AND mc.Active = 1
            ) AS T;
 
        -- STEP 3b: Concatenate the result into the final @SQL.
        SET @SQL = @SQL + N'
SELECT 
    ' + @QuotedCheckGroup + N' AS zCheckWithinGroup, -- ADDED ONCE AT THE END
    ' + @ColumnList + N'
FROM 
    ' + QUOTENAME(@TableSchema) + N'.' + QUOTENAME(@TableName) + N'
UNION ALL ';
 
        FETCH NEXT FROM table_cursor INTO @TableName;
    END
 
    CLOSE table_cursor;
    DEALLOCATE table_cursor;
 
    -------------------------------------------------------------------------
    -- 4. Final Cleanup and Execution
    -------------------------------------------------------------------------
 
    DECLARE @TargetTableName SYSNAME = 'InconsistentReport_UnionConflict_' + @zCheckWithinGroup;
    DECLARE @TargetTableFullName SYSNAME = QUOTENAME(@TableSchema) + '.' + QUOTENAME(@TargetTableName);
 
    IF @SQL LIKE '%UNION ALL '
    BEGIN
        SET @SQL = LEFT(@SQL, LEN(@SQL) - LEN('UNION ALL ')); 
    END
 
    DECLARE @FinalExecSQL NVARCHAR(MAX);
 
    SET @FinalExecSQL = 
        N'IF OBJECT_ID(' + QUOTENAME(@TargetTableFullName, '''') + N') IS NOT NULL 
          DROP TABLE ' + @TargetTableFullName + N';' +
        N'
        SELECT * INTO ' + @TargetTableFullName + N'
        FROM (
            ' + @SQL + N'
        ) AS UnionedData;';
 
    EXEC sp_executesql @FinalExecSQL;
    PRINT 'Successfully created and populated table ' + @TargetTableName;
END

GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionInfoReportsIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionInfoReportsIns]  
    @zCheckWithinGroup nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @SQL NVARCHAR(MAX) = N'';
    DECLARE @TableName SYSNAME;
    DECLARE @ColumnList NVARCHAR(MAX); 
    DECLARE @TableSchema SYSNAME = 'dbo'; 
    DECLARE @FirstTableName SYSNAME; 
    DECLARE @LastMasterOrderID INT; -- Variable to hold the highest existing ID
    -------------------------------------------------------------------------
    -- 1. Populate the Table List (@TableList)
    -------------------------------------------------------------------------
 
    DECLARE @TableList TABLE (TableName SYSNAME, TableSchema SYSNAME DEFAULT 'dbo');
 
    INSERT INTO @TableList (TableName)
    SELECT InconsistentReportTableName 
    FROM ztAttributeConfig 
    INNER JOIN ztAttributeConsistencySummary 
        ON ztAttributeConfig.AttributeID = ztAttributeConsistencySummary.AttributeID
    WHERE zActive = 1 
      AND InconsistentReportTableName IS NOT NULL 
      AND ztAttributeConfig.zCheckWithinGroup = @zCheckWithinGroup
	  AND ReportType = 'Info'
    ORDER BY InconsistentReportTableName; 
    -- Capture the name of the first table in the list
    SELECT TOP 1 @FirstTableName = TableName FROM @TableList ORDER BY TableName;
 
    -------------------------------------------------------------------------
    -- 2. Auto-Populate/Maintain ztColumnOrderConfig for the current group
    -------------------------------------------------------------------------
 
    -- 2a. Determine the starting point for new MasterOrderIDs: 
    --     Start at 100 if no entries exist, otherwise start after the highest existing ID.
    SELECT @LastMasterOrderID = ISNULL(MAX(MasterOrderID), 0)
    FROM dbo.ztColumnOrderConfig 
    WHERE zCheckWithinGroup = @zCheckWithinGroup AND Active = 1;
 
    -- Set the base offset: if no entries exist, we start the first new ID at 100.
    -- Otherwise, we start numbering from the last existing ID + 5.
    IF @LastMasterOrderID = 0
        SET @LastMasterOrderID = 95; -- 95 + 5 * 1 = 100 for the first new column
 
    IF @FirstTableName IS NOT NULL
    BEGIN
        -- Insert columns only if they do not already exist for this group
        INSERT INTO dbo.ztColumnOrderConfig (zCheckWithinGroup, MasterOrderID, COLUMN_NAME, DATA_TYPE)
        SELECT 
            @zCheckWithinGroup AS zCheckWithinGroup,
            -- Calculation for new MasterOrderID: (Last existing ID) + (ROW_NUMBER * 5)
            @LastMasterOrderID + (ROW_NUMBER() OVER (ORDER BY c.ORDINAL_POSITION) * 5) AS MasterOrderID, 
            c.COLUMN_NAME,
            c.DATA_TYPE
        FROM 
            INFORMATION_SCHEMA.COLUMNS c
        WHERE 
            c.TABLE_NAME = @FirstTableName 
            AND c.TABLE_SCHEMA = @TableSchema
            -- Exclude the zCheckWithinGroup column from the managed list
            AND c.COLUMN_NAME <> 'zCheckWithinGroup' 
            -- Only insert columns that don't already exist for this group
            AND c.COLUMN_NAME NOT IN (
                SELECT COLUMN_NAME 
                FROM dbo.ztColumnOrderConfig 
                WHERE zCheckWithinGroup = @zCheckWithinGroup
            )
        ORDER BY
            c.ORDINAL_POSITION;
    END
 
    -------------------------------------------------------------------------
    -- 3. Generate the Dynamic SQL
    -------------------------------------------------------------------------
 
    DECLARE table_cursor CURSOR LOCAL FOR
        SELECT TableName 
        FROM @TableList;
 
    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @TableName;
 
    -- Safely quote the input variable for use as a string literal in dynamic SQL
    DECLARE @QuotedCheckGroup NVARCHAR(100) = QUOTENAME(@zCheckWithinGroup, '''');
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
 
        -- STEP 3a: Build the column expression string based on config table
        SELECT 
            @ColumnList = STRING_AGG(
                CAST(T.ColumnExpression AS NVARCHAR(MAX)),
                N', '
            ) WITHIN GROUP (ORDER BY T.MasterOrderID) 
        FROM 
            (
                SELECT 
                    mc.MasterOrderID,
                    mc.COLUMN_NAME,
                    CASE 
                        WHEN EXISTS (
                            SELECT 1 
                            FROM INFORMATION_SCHEMA.COLUMNS 
                            WHERE TABLE_NAME = @TableName 
                              AND TABLE_SCHEMA = @TableSchema 
                              AND COLUMN_NAME = mc.COLUMN_NAME
                        ) AND ISNULL(mc.COLUMN_NAMENew, '') = '' --CP 20251215 added condition

                        THEN QUOTENAME(mc.COLUMN_NAME)
						/*CP 20251215 condition for case sensitive columns e.g. where the COLUMN_NAMENew has been used*/
						WHEN EXISTS (
                            SELECT 1 
                            FROM INFORMATION_SCHEMA.COLUMNS 
                            WHERE TABLE_NAME = @TableName 
                              AND TABLE_SCHEMA = @TableSchema 
                              AND COLUMN_NAME = mc.COLUMN_NAME
                        ) AND ISNULL(mc.COLUMN_NAMENew, '') <> '' THEN mc.COLUMN_NAMENew 
                        
                        ELSE N'CAST(NULL AS ' + ISNULL(mc.DATA_TYPE, N'NVARCHAR(MAX)') + N') AS ' + QUOTENAME(mc.COLUMN_NAME)
                    END AS ColumnExpression
                FROM 
                    dbo.ztColumnOrderConfig mc 
                WHERE
                    mc.zCheckWithinGroup = @zCheckWithinGroup  AND mc.Active = 1
            ) AS T;
 
        -- STEP 3b: Concatenate the result into the final @SQL.
        SET @SQL = @SQL + N'
SELECT 
    ' + @QuotedCheckGroup + N' AS zCheckWithinGroup, -- ADDED ONCE AT THE END
    ' + @ColumnList + N'
FROM 
    ' + QUOTENAME(@TableSchema) + N'.' + QUOTENAME(@TableName) + N'
UNION ALL ';
 
        FETCH NEXT FROM table_cursor INTO @TableName;
    END
 
    CLOSE table_cursor;
    DEALLOCATE table_cursor;
 
    -------------------------------------------------------------------------
    -- 4. Final Cleanup and Execution
    -------------------------------------------------------------------------
 
    DECLARE @TargetTableName SYSNAME = 'InconsistentReport_UnionInfo_' + @zCheckWithinGroup;
    DECLARE @TargetTableFullName SYSNAME = QUOTENAME(@TableSchema) + '.' + QUOTENAME(@TargetTableName);
 
    IF @SQL LIKE '%UNION ALL '
    BEGIN
        SET @SQL = LEFT(@SQL, LEN(@SQL) - LEN('UNION ALL ')); 
    END
 
    DECLARE @FinalExecSQL NVARCHAR(MAX);
 
    SET @FinalExecSQL = 
        N'IF OBJECT_ID(' + QUOTENAME(@TargetTableFullName, '''') + N') IS NOT NULL 
          DROP TABLE ' + @TargetTableFullName + N';' +
        N'
        SELECT * INTO ' + @TargetTableFullName + N'
        FROM (
            ' + @SQL + N'
        ) AS UnionedData;';
 
    EXEC sp_executesql @FinalExecSQL;
    PRINT 'Successfully created and populated table ' + @TargetTableName;
END

GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryRefreshAllReportsScheduledUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryRefreshAllReportsScheduledUpd] --@zCheckWithinGroup nvarchar(10)
AS
BEGIN
DECLARE @AttributeID nvarchar(10)
DECLARE @zCheckWithinGroup nvarchar(10)

DECLARE cur0 CURSOR LOCAL for

SELECT zCheckWithinGroup FROM ztParameter WHERE zActive = 1

OPEN cur0
FETCH NEXT FROM cur0 into @zCheckWithinGroup
WHILE @@FETCH_STATUS = 0
      BEGIN

    DECLARE cur CURSOR LOCAL for
     
	 SELECT AttributeID
      FROM   ztAttributeConfig
      WHERE  zActive = 1 AND 
	  zCheckWithinGroup = @zCheckWithinGroup


    OPEN cur;

    FETCH NEXT FROM cur into @AttributeID

    WHILE @@FETCH_STATUS = 0
      BEGIN
	  print 'Start with: ' + @AttributeID
	  EXEC webAttributeConfig_AttributeTableIns @AttributeID --Drops and creates the table associated to the AttributeID AttributeTable_<AttributeID> and update the SelectAttributeTable and the AttributeTableLastRefreshedOn column in ztAttributeConfig
	  
	  EXEC webAttributeConfigAttributeConsistencySummaryInsSel @AttributeID --Updates the field TotalRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryCompleteRecordsUpdSel @AttributeID --Updates the field CompleteRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryIncompleteRecordsUpdSel @AttributeID --Updates the field IncompleteRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentMatchGroupsUpdSel @AttributeID --Updates the field InconsistentMatchGroups of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryConsistentMatchGroupsUpdSel @AttributeID --Updates the field ConsistentMatchGroups of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentRecordsSelectUpdSel @AttributeID --Updates the field InconsistentRecordsSelect of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentRecordsUpdSel @AttributeID--Updates the field InconsistentRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryConsistentRecordsSelectUpdSel @AttributeID --Updates the field ConsistentRecordsSelect of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryConsistentRecordsUpdSel @AttributeID --Updates the field ConsistentRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameIns @AttributeID --Drops and Creates/Inserts the Inconsistent records into the table InconsistentReport_AttributeID



	  EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameIns @AttributeID
	  print 'End of: ' + @AttributeID
	  

          FETCH NEXT FROM cur into @AttributeID
      END;

    CLOSE cur;

    DEALLOCATE cur;


	  print 'Union of all reports of Batch Group: ' + @zCheckWithinGroup
      
	  DECLARE @UnionReports int
	  SET @UnionReports = (SELECT UnionReports FROM ztParameter WHERE zCheckWithinGroup = @zCheckWithinGroup)
	  IF @UnionReports = 1
	  BEGIN
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionAllIns @zCheckWithinGroup
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionConflictReportsIns @zCheckWithinGroup
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionInfoReportsIns @zCheckWithinGroup
	  END


      UPDATE ztParameter
      SET LastAllRefreshOn = GETDATE()
      FROM ztParameter
      WHERE zCheckWithinGroup = @zCheckWithinGroup



	  FETCH NEXT FROM cur0 into @zCheckWithinGroup
      END;

    CLOSE cur0;

    DEALLOCATE cur0;


END
GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryRefreshAllReportsUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryRefreshAllReportsUpd] @zCheckWithinGroup nvarchar(10)
AS



BEGIN
DECLARE @AttributeID nvarchar(10)

    DECLARE cur CURSOR LOCAL for
     
	 SELECT AttributeID
      FROM   ztAttributeConfig
      WHERE  ztAttributeConfig.zActive = 1
	  AND ztAttributeConfig.zCheckWithinGroup = @zCheckWithinGroup


    OPEN cur;

    FETCH NEXT FROM cur into @AttributeID

    WHILE @@FETCH_STATUS = 0
      BEGIN

	  EXEC webAttributeConfig_AttributeTableIns @AttributeID --Drops and creates the table associated to the AttributeID AttributeTable_<AttributeID> and update the SelectAttributeTable and the AttributeTableLastRefreshedOn column in ztAttributeConfig
	  
	  EXEC webAttributeConfigAttributeConsistencySummaryInsSel @AttributeID --Updates the field TotalRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryCompleteRecordsUpdSel @AttributeID --Updates the field CompleteRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryIncompleteRecordsUpdSel @AttributeID --Updates the field IncompleteRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentMatchGroupsUpdSel @AttributeID --Updates the field InconsistentMatchGroups of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryConsistentMatchGroupsUpdSel @AttributeID --Updates the field ConsistentMatchGroups of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentRecordsSelectUpdSel @AttributeID --Updates the field InconsistentRecordsSelect of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentRecordsUpdSel @AttributeID--Updates the field InconsistentRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryConsistentRecordsSelectUpdSel @AttributeID --Updates the field ConsistentRecordsSelect of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryConsistentRecordsUpdSel @AttributeID --Updates the field ConsistentRecords of the table ztAttributeConsistencySummary
	  EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameIns @AttributeID --Drops and Creates/Inserts the Inconsistent records into the table InconsistentReport_AttributeID



	  EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameIns @AttributeID
	  

          FETCH NEXT FROM cur into @AttributeID
      END;

    CLOSE cur;

    DEALLOCATE cur;

	DECLARE @UnionReports int
	SET @UnionReports = (SELECT UnionReports FROM ztParameter WHERE zCheckWithinGroup = @zCheckWithinGroup)
	IF @UnionReports = 1
	BEGIN
	EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionAllIns @zCheckWithinGroup
	EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionConflictReportsIns @zCheckWithinGroup
	EXEC webAttributeConfig_ConsistencySummaryInconsistentReportTableNameUnionInfoReportsIns @zCheckWithinGroup
	END

	UPDATE ztParameter
	SET LastAllRefreshOn = GETDATE()
	FROM ztParameter
	WHERE zCheckWithinGroup = @zCheckWithinGroup

END
GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfig_ConsistencySummaryTotalRecordsUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webAttributeConfig_ConsistencySummaryTotalRecordsUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field TotalRecords of the table ztAttributeConsistencySummary*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @WHEREClause		   nvarchar(1000) 

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN '' ELSE CONCAT('WHERE ', @WHEREClause) END



/*get the distinct values from the source table and the checktable*/
SET @SQLQuery02 = '
UPDATE ztAttributeConsistencySummary
SET TotalRecords = (
SELECT COUNT(*) 
FROM AttributeTable_'+@AttributeID+' a
'+@WHEREClause+'
)
WHERE AttributeID = '+@AttributeID+'
'
PRINT @SQLQuery02
EXEC (@SQLQuery02)

--SET @SQLQuery01 = sp_execute(@SQLQuery02)
--
--UPDATE ztAttributeConsistencySummary
--SET TotalRecords = @SQLQuery01
--WHERE AttributeID = @AttributeID	 

GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfigAttributeConsistencySummaryInsSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[webAttributeConfigAttributeConsistencySummaryInsSel] @AttributeID nvarchar(50) 
AS

/*insert record if not existing*/

--DECLARE @SQLQuery01			   nvarchar(MAX)
--DECLARE @SQLQuery02			   nvarchar(MAX)
--DECLARE @SQLQuery03			   nvarchar(MAX)
--DECLARE @CheckTable			   nvarchar(100)
--DECLARE @DataSourceName		   nvarchar(100)
--DECLARE @AttributeDatabase	   nvarchar(100)
--DECLARE @AttributeTable		   nvarchar(100)
--DECLARE @Attribute			   nvarchar(100)
--DECLARE @SourceSystemIDColumn  nvarchar(100) 
--DECLARE @WHEREClause		   nvarchar(1000) 

--SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
--SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
--SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
--SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
--SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
--SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
--SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 

--SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN '' ELSE CONCAT('WHERE ', @WHEREClause) END
DECLARE @AttributeIDExisting			   nvarchar(100)
BEGIN
-- Step 0: AttributeID ztAttributeConsistencySummary
    SET @AttributeIDExisting = (SELECT 1
    FROM ztAttributeConsistencySummary
    WHERE AttributeID = @AttributeID)
 
    IF @AttributeIDExisting IS NULL
    BEGIN
       -- RAISERROR('AttributeID %d does not exist in ztAttributeConsistencySummary.', 16, 1, @AttributeID);
       -- RETURN;
    
 
    -- Step 1: Insert entry in table ztAttributeConsistencySummary
    INSERT INTO ztAttributeConsistencySummary (AttributeID)
    SELECT @AttributeID;
	END
END





GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfigCopyEntryIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webAttributeConfigCopyEntryIns] @AttributeID NVARCHAR(50), @boaUserID NVARCHAR(50)
AS
INSERT INTO WRKDQHARMONIZE.[dbo].[ztAttributeConfig]
([Area]
      ,[Description]
      ,[AttributeDatabase]
      ,[AttributeTable]
      ,[Attribute]
      ,[SourceSystemIDColumn]
      ,[MatchGroupIDColumn]
      ,[WHEREClauseInput]
      ,[CheckTable]
      ,[SelectAttributeTable]
      ,[SelectDistinctValues]
	  ,[CaseSensitive]
      ,[Comments]
      ,[ConsistencyCheckMadeByDecision]
      ,[ConsistencyCheckByProposedMatchGroup]
      ,[AddedBy]
      ,[AddedOn]
      ,[AddedVia])

SELECT [Area]
      ,[Description]
      ,[AttributeDatabase]
      ,[AttributeTable]
      ,[Attribute]
      ,[SourceSystemIDColumn]
      ,[MatchGroupIDColumn]
      ,[WHEREClauseInput]
      ,[CheckTable]
      ,[SelectAttributeTable]
      ,[SelectDistinctValues]
	  ,[CaseSensitive]
      ,[Comments]
      ,[ConsistencyCheckMadeByDecision]
      ,[ConsistencyCheckByProposedMatchGroup]
      ,@boaUserID
      ,getdate()
      ,CONCAT('Copy From ',@AttributeID)
  FROM [WRKDQHARMONIZE].[dbo].[ztAttributeConfig]
  WHERE AttributeID = @AttributeID
GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfigSelectAttributeTableUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webAttributeConfigSelectAttributeTableUpdSel] @AttributeID nvarchar(50) 
AS

/*get the source values from the source table and update it to the SelectAttributeTable field*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @WHEREClause		   nvarchar(1000) 

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN '' ELSE CONCAT('WHERE ', @WHEREClause) END



SET @SQLQuery01 = '

SELECT *
FROM '+@DataSourceName+'.dbo.'+@AttributeTable+' a
'+@WHEREClause+'

'
PRINT @SQLQuery01

UPDATE ztAttributeConfig
SET SelectAttributeTable = @SQLQuery01
WHERE AttributeDatabase  = @AttributeDatabase
AND AttributeTable		 = @AttributeTable
AND Attribute			 = @Attribute	
AND AttributeID			 = @AttributeID

GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfigSelectDistinctValuesUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webAttributeConfigSelectDistinctValuesUpdSel] @AttributeID nvarchar(50) 
AS

/*Updates the field SelectDistinctValues to get the select statement over all distinct values.*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @WHEREClause		   nvarchar(1000) 
DECLARE @CaseSensitive		   nvarchar(1)

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CaseSensitive			= (SELECT ISNULL(CaseSensitive, 0)			FROM webAttributeConfigVer WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN '' ELSE CONCAT('WHERE ', @WHEREClause) END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 0
BEGIN
/*get the distinct values from the source table and the checktable*/
SET @SQLQuery02 = '

SELECT DISTINCT '+@SourceSystemIDColumn+', '+@Attribute+', [Group]
FROM AttributeTable_'+@AttributeID+' a
INNER JOIN '+@CheckTable+' b ON 

a.'+@SourceSystemIDColumn+' = b.SourceSystemID
AND a.'+@Attribute+' = b.LegacyValue01 
'+@WHEREClause+'

'
PRINT @SQLQuery02

UPDATE ztAttributeConfig
SET SelectDistinctValues = @SQLQuery02
WHERE AttributeDatabase  = @AttributeDatabase
AND AttributeTable		 = @AttributeTable
AND Attribute			 = @Attribute	 
AND AttributeID			 = @AttributeID

END


IF @CheckTable <> 'No Checktable' AND @CaseSensitive = 1
BEGIN
/*get the distinct values from the source table and the checktable*/
SET @SQLQuery02 = '

SELECT DISTINCT '+@SourceSystemIDColumn+', '+@Attribute+', [Group]
FROM AttributeTable_'+@AttributeID+' a
INNER JOIN '+@CheckTable+' b ON 

a.'+@SourceSystemIDColumn+' = b.SourceSystemID
AND a.'+@Attribute+' COLLATE SQL_Latin1_General_CP1_CS_AS = b.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS
'+@WHEREClause+'

'
PRINT @SQLQuery02

UPDATE ztAttributeConfig
SET SelectDistinctValues = @SQLQuery02
WHERE AttributeDatabase  = @AttributeDatabase
AND AttributeTable		 = @AttributeTable
AND Attribute			 = @Attribute	 
AND AttributeID			 = @AttributeID

END


IF @CheckTable = 'No Checktable'
BEGIN
/*get the distinct values from the source table and the checktable*/
SET @SQLQuery02 = '

SELECT DISTINCT '+@SourceSystemIDColumn+', '+@Attribute+'
FROM AttributeTable_'+@AttributeID+' a
'+@WHEREClause+'

'
PRINT @SQLQuery02

UPDATE ztAttributeConfig
SET SelectDistinctValues = @SQLQuery02
WHERE AttributeDatabase  = @AttributeDatabase
AND AttributeTable		 = @AttributeTable
AND Attribute			 = @Attribute	 

END


GO
/****** Object:  StoredProcedure [dbo].[webAttributeConfigzRelevantInCheckTableUpdSel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webAttributeConfigzRelevantInCheckTableUpdSel] @AttributeID nvarchar(50) 
AS

/*set value to zRelevant = 1 in the checktable*/

DECLARE @SQLQuery01			   nvarchar(MAX)
DECLARE @SQLQuery02			   nvarchar(MAX)
DECLARE @SQLQuery03			   nvarchar(MAX)
DECLARE @CheckTable			   nvarchar(100)
DECLARE @DataSourceName		   nvarchar(100)
DECLARE @AttributeDatabase	   nvarchar(100)
DECLARE @AttributeTable		   nvarchar(100)
DECLARE @Attribute			   nvarchar(100)
DECLARE @SourceSystemIDColumn  nvarchar(100) 
DECLARE @WHEREClause		   nvarchar(1000) 
DECLARE @CaseSensitive		   nvarchar(1)

SET @DataSourceName			= (SELECT ISNULL(DataSourceName, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CheckTable			 	= (SELECT ISNULL(CheckTable, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeDatabase		= (SELECT ISNULL(AttributeDatabase, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @AttributeTable			= (SELECT ISNULL(AttributeTable, '')		FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @Attribute				= (SELECT ISNULL(Attribute, '')				FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @SourceSystemIDColumn 	= (SELECT ISNULL(SourceSystemIDColumn, '') 	FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @WHEREClause			= (SELECT ISNULL(WHEREClause, '')			FROM webAttributeConfigHor WHERE AttributeID = @AttributeID) 
SET @CaseSensitive			= (SELECT ISNULL(CaseSensitive, 0)			FROM webAttributeConfigVer WHERE AttributeID = @AttributeID) 

SET @WHEREClause = CASE WHEN @WHEREClause = '' THEN '' ELSE CONCAT('WHERE ', @WHEREClause) END


PRINT(@WHEREClause) 
--SELECT DataSourceName, AttributeTable, Attribute, CheckTable, SourceSystemIDColumn, WHEREClause
--FROM webAttributeConfigHor

IF (@CheckTable <> 'No Checktable' AND @CheckTable  <> '')  AND @CaseSensitive = 0
BEGIN
SET @SQLQuery03 = '
UPDATE '+@CheckTable+'
SET zRelevant = 1
FROM '+@CheckTable+' b
INNER JOIN AttributeTable_'+@AttributeID+' a ON
a.'+@SourceSystemIDColumn+' = b.SourceSystemID
AND a.'+@Attribute+' = b.LegacyValue01 
'+@WHEREClause+'
'
END

PRINT @SQLQuery03

IF @CheckTable <> 'No Checktable' AND @CheckTable  <> '' AND @CaseSensitive = 1
BEGIN
SET @SQLQuery03 = '
UPDATE '+@CheckTable+'
SET zRelevant = 1
FROM '+@CheckTable+' b
INNER JOIN AttributeTable_'+@AttributeID+' a ON
a.'+@SourceSystemIDColumn+' = b.SourceSystemID
AND a.'+@Attribute+'  COLLATE SQL_Latin1_General_CP1_CS_AS = b.LegacyValue01  COLLATE SQL_Latin1_General_CP1_CS_AS
'+@WHEREClause+'
'

PRINT @SQLQuery03

END
EXEC (@SQLQuery03)
GO
/****** Object:  StoredProcedure [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelSelect]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelSelect] @zCheckWithinGroup nvarchar(10), @AttributeID nvarchar(10)
  AS
  DECLARE @sql nvarchar(MAX)
 
  UPDATE ztAttributeConfig
  SET WHEREClauseExcel = CONCAT(WHEREClause, ' AND zCheckWithinGroup = ', @zCheckWithinGroup)
  WHERE AttributeID = @AttributeID
  EXEC webAttributeConfig_ConsistencySummaryInconsistentRecordsSelectExcelUpdSel @AttributeID
  EXEC webAttributeConfig_ConsistencySummaryConsistentRecordsSelectExcelUpdSel @AttributeID
 
  select @sql = (SELECT [InconsistentRecordsSelect] FROM webAttributeConsistencySummaryMadeByDecisionExcelSelectHor WHERE AttributeID = @AttributeID)
  print @sql
  --exec sp_executesql @sql

GO
/****** Object:  StoredProcedure [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelSelectAll]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  CREATE PROCEDURE [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelSelectAll]
  AS
  DECLARE @zCheckWithinGroup nvarchar(10)
  DECLARE @AttributeID nvarchar(10)
 
  SET @zCheckWithinGroup = 310
 
  BEGIN
 
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 12 -- BUKRS - Company Code
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 26 -- KNVV_LFM1_WAERS - Currency
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 13 -- Terms of Payment
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 16 -- Account Groups customer
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 30 -- Account Groups supplier
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 15 -- Does not make sense
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 17 -- zAttribute03 - ___Name1___
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 18 -- zAttribute04 - ___Name2___
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 19 -- zAttribute05 - Name3
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 20 -- zAttribute06 - Name4
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 22 -- zAttribute08 - Postal Code
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 21 -- zAttribute07 - ___Street___
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 23 -- zAttribute09 - ____City____
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 28 -- zAttribute15 - Country
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 29 -- zAttribute16 - Telephone
  exec webAttributeConsistencySummaryMadeByDecisionExcelSelect 320, 24 -- zAttribute14 - Trading Partner
  
  END

GO
/****** Object:  StoredProcedure [dbo].[webDatasetAvailableTablesDatabaseNameUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webDatasetAvailableTablesDatabaseNameUpd] @DataSourceID nvarchar(50)
AS
BEGIN

DECLARE @DatabaseName NVARCHAR(100)
SET @DatabaseName = (SELECT DataSourceName FROM CranSoft.dbo.DataSource WHERE DataSourceID = @DataSourceID)

UPDATE ztDatasetAvailableTables
SET DatabaseName = @DatabaseName
WHERE DatabaseName IS NULL OR DatabaseName <> @DatabaseName

END
GO
/****** Object:  StoredProcedure [dbo].[webDatasetAvailableTablesDeleteTableColumnRecordsDel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[webDatasetAvailableTablesDeleteTableColumnRecordsDel] @TableId int
as
begin
delete from ztDatasetTableColumns where TableId=@TableId
end
GO
/****** Object:  StoredProcedure [dbo].[webDatasetAvailableTablesGetfields]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webDatasetAvailableTablesGetfields](@TableID int, @TableName nvarchar(100),@DatabaseName nvarchar(100) )  
AS  
  BEGIN  
      SET NOCOUNT ON;  
  
      -- Truncate the TableColumns table to refresh data (optional)  
      --TRUNCATE TABLE TableColumns;  
  
      --DECLARE @TableID INT=20;  
      --DECLARE @DatabaseName SYSNAME;  
      --DECLARE @TableName SYSNAME;  
      DECLARE @SQL NVARCHAR(MAX);  
      -- Cursor to loop through each table in AvailableTables  
      --DECLARE TableCursor CURSOR FOR  
      --  SELECT TableID,  
      --         DatabaseName,  
      --         TableName  
      --  FROM   AvailableTables  
      --  WHERE  IsActive = 1;  
  
      --OPEN TableCursor;  
  
      --FETCH NEXT FROM TableCursor INTO @TableID, @DatabaseName, @TableName;  
  
      --WHILE @@FETCH_STATUS = 0  
      --  BEGIN  
            -- Use QUOTENAME to safely encapsulate database and table names  
        --SET @DatabaseName = (SELECT DataSourceName FROM CranSoft.dbo.DataSource WHERE DataSourceID = @DatabaseName)
		
		DECLARE @QuotedDatabaseName NVARCHAR(258) = Quotename(@DatabaseName);  
        DECLARE @QuotedTableName NVARCHAR(258) = Quotename(@TableName, ''''); -- Single quotes for parameter  
  
        -- Create a temporary table to hold column information  
        IF Object_id('tempdb..#Columns') IS NOT NULL  
            DROP TABLE #Columns;  
  
        CREATE TABLE #Columns  
            (  
                ORDINAL_POSITION         INT,  
                COLUMN_NAME              SYSNAME,  
                DATA_TYPE                SYSNAME,  
                CHARACTER_MAXIMUM_LENGTH INT NULL,  
                IS_NULLABLE              VARCHAR(3),  
                IsPrimaryKey             BIT  
            );  
  
        -- Construct dynamic SQL to query column and primary key information  
        SET @SQL = N' INSERT INTO #Columns (ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, IsPrimaryKey) 
		SELECT C.ORDINAL_POSITION, C.COLUMN_NAME, C.DATA_TYPE, C.CHARACTER_MAXIMUM_LENGTH, C.IS_NULLABLE, CASE WHEN PKCols.COLUMN_NAME IS NOT NULL THEN 1 ELSE 0 END AS IsPrimaryKey FROM '  
                    + @QuotedDatabaseName  
                    + N'.INFORMATION_SCHEMA.COLUMNS C LEFT JOIN ( SELECT KCU.COLUMN_NAME FROM '  
                    + @QuotedDatabaseName  
                    + N'.INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC INNER JOIN '  
                    + @QuotedDatabaseName  
                    + N'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE KCU ON KCU.CONSTRAINT_NAME = TC.CONSTRAINT_NAME AND KCU.TABLE_NAME = TC.TABLE_NAME WHERE TC.CONSTRAINT_TYPE = ''PRIMARY KEY''      
               AND KCU.TABLE_NAME = ' + @QuotedTableName + N' ) AS PKCols ON PKCols.COLUMN_NAME = C.COLUMN_NAME WHERE C.TABLE_NAME = ' + @QuotedTableName + N'; ';  
  
        -- Execute the dynamic SQL  
        PRINT @SQL
		EXEC sp_executesql  
            @SQL;  
			select * from #Columns
  
        -- Check if any columns were retrieved  
        IF EXISTS (SELECT 1  
                    FROM   #Columns)  
            BEGIN  

			--delete first the already retrieved ones if existing
			DELETE FROM ztDatasetTableColumns
			WHERE TableID = @TableID

                -- Insert column details into TableColumns  
                INSERT INTO ztDatasetTableColumns  
                            (TableID,  
                            ColumnName,  
                            DataType,  
                            Active,  
                            AllowedForJoin,  
                            DisplayName)  
                SELECT @TableID,  
                        COLUMN_NAME,  
                        CASE  
                        WHEN DATA_TYPE IN ( 'varchar', 'nvarchar', 'char', 'nchar' ) 
						THEN DATA_TYPE + '(' + COALESCE(Cast(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)), 'MAX') + ')'  
                        ELSE DATA_TYPE  
                        END         AS DataType,  
                        1           AS IsSelectable,-- You can adjust this if needed  
                        IsPrimaryKey,-- Set IsJoinable based on IsPrimaryKey (1 if PK, 0 otherwise)  
                        COLUMN_NAME AS DisplayName  
                FROM   #Columns left outer join ztDatasetTableColumns on COLUMN_NAME=ColumnName and TableId=@TableID where (COLUMN_NAME is null  or COLUMN_NAME!='Not Available')
            END  
        --ELSE if not exists (select 1 from TableColumns where TableID=@TableID)  
        --    BEGIN  
        --        -- Table not found; insert 'Not Available'  
        --        INSERT INTO TableColumns  
        --                    (TableID,  
        --                    ColumnName,  
        --                    DataType,  
        --                    Active,  
        --                    AllowedForJoin,  
        --                    DisplayName)  
        --        VALUES      (@TableID,  
        --                    'Not Available',  
        --                    '',  
        --                    0,  
        --                    0,  
        --                    'Not Available');  
        --    END  
  
        -- Clean up temporary table  
        DROP TABLE #Columns;  
  
          
  END; 
GO
/****** Object:  StoredProcedure [dbo].[webDatasetMasterCleanupDel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[webDatasetMasterCleanupDel] @DatasetID int
as
begin
declare @Dataset nvarchar(100)
declare @SQL nvarchar(200)
delete  from ztDatasetTables where DatasetId=@DatasetID

delete from ztDatasetJoins where DatasetId=@DatasetID
delete from ztDatasetJoinConditions where DatasetId=@DatasetID
delete from ztDatasetSelectFields where DatasetId=@DatasetID

select @Dataset=DatasetName from ztDatasetMaster where DatasetID=@DatasetID

set @SQL = 'drop view if exists '+@Dataset
exec sp_executesql @SQL

end
GO
/****** Object:  StoredProcedure [dbo].[webDatasetMasterGenerateDynamicQuery]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[webDatasetMasterGenerateDynamicQuery]
    @DatasetID INT,
    @DatabaseName SYSNAME = NULL  -- Optional: The database where the tables are located
    --@GeneratedQuery NVARCHAR(MAX) OUTPUT  -- Output parameter to return the generated query
AS
BEGIN
    SET NOCOUNT ON;
	--declare @DatasetId int = 5;
	--declare @DataBaseName nvarchar(100)
 
    -- Variable declarations
	DECLARE @GeneratedQuery NVARCHAR(MAX);
    DECLARE @SelectClause NVARCHAR(MAX) = '';
    DECLARE @FromClause NVARCHAR(MAX) = '';
    DECLARE @JoinClauses NVARCHAR(MAX) = '';
    DECLARE @WhereClause NVARCHAR(MAX) = '';  -- Optional: For future use
    DECLARE @OrderByClause NVARCHAR(MAX) = '';  -- Optional: For future use
    DECLARE @CRLF CHAR(2) = CHAR(13) + CHAR(10);  -- Carriage return and line feed for readability
    DECLARE @ViewName SYSNAME;
    DECLARE @DynamicSQL NVARCHAR(MAX);
 
    -- Temporary tables or table variables to hold intermediate data
    DECLARE @Tables TABLE (
        DatasetTableID INT,
        TableID INT,
        DatabaseName SYSNAME,
        SchemaName SYSNAME,
        TableName SYSNAME,
        Alias SYSNAME
    );
 
    DECLARE @SelectFields TABLE (
        SequenceNumber INT,
        SelectExpression NVARCHAR(MAX),
        Alias SYSNAME,
        IsExpression BIT
    );
 
    DECLARE @Joins TABLE (
        DatasetJoinID INT,
        JoinType VARCHAR(20),
        FromTableAlias SYSNAME,
        ToTableAlias SYSNAME,
        ToDatabaseName SYSNAME,
        ToSchemaName SYSNAME,
        ToTableName SYSNAME,
        OnClause NVARCHAR(MAX),
        AdditionalConditions VARCHAR(500),
		JoinOrder INT
    );
 
    -- Step 0: Retrieve the DatasetName from Dataset_Master
    SELECT @ViewName = DatasetName
    FROM ztDatasetMaster
    WHERE DatasetID = @DatasetID;
 
    IF @ViewName IS NULL
    BEGIN
        RAISERROR('DatasetID %d does not exist in Dataset_Master.', 16, 1, @DatasetID);
        RETURN;
    END
 
    -- Step 1: Retrieve the tables involved in the dataset
    INSERT INTO @Tables (DatasetTableID, TableID, DatabaseName, SchemaName, TableName, Alias)
    SELECT
        dt.DatasetTableID,
        dt.TableID,
        COALESCE(@DatabaseName, at.DatabaseName) AS DatabaseName,  -- Use @DatabaseName if provided
        'dbo' SchemaName,
        at.TableName,
        COALESCE(dt.Alias, at.TableName) AS Alias
    FROM ztDatasetTables dt
        INNER JOIN ztDatasetAvailableTables at ON dt.TableID = at.TableID
    WHERE
        dt.DatasetID = @DatasetID;

		--SELECT * FROM @Tables
 --select '1.Tables' as ord , * from @Tables
    -- Step 2: Build the FROM clause
    SELECT TOP 1 @FromClause = 'FROM ' + QUOTENAME(DatabaseName) + '.' + QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName) + ' AS ' + QUOTENAME(Alias)
    FROM @Tables
    ORDER BY DatasetTableID;  -- Assuming the first table is the base table
 --print('2.From Clause: '+@FromClause)
    -- Step 3: Retrieve the select fields
    INSERT INTO @SelectFields (SequenceNumber, SelectExpression, Alias, IsExpression)
    SELECT
        dsf.SequenceNumber,
        CASE
            WHEN dsf.ColumnID IS NOT NULL 
			THEN QUOTENAME(t.Alias) + '.' + QUOTENAME(tc.ColumnName)
            ELSE dsf.ExpressionText
        END AS SelectExpression,
        COALESCE(dsf.Alias, tc.DisplayName, dsf.ExpressionText) AS Alias,
        CASE WHEN dsf.ColumnID IS NULL THEN 1 ELSE 0 END AS IsExpression
    FROM ztDatasetSelectFields dsf
        LEFT JOIN ztDatasetTableColumns tc ON dsf.ColumnID = tc.ColumnID
        LEFT JOIN @Tables t ON tc.TableID = t.TableID
    WHERE dsf.DatasetID = @DatasetID
    ORDER BY
        dsf.SequenceNumber;
 --select '3. Selectfeilds' as Ord , * from @SelectFields
    -- Step 4: Build the SELECT clause using FOR XML PATH
    SELECT @SelectClause = STUFF((
        SELECT ',' + @CRLF +
            CASE
                WHEN IsExpression = 1 THEN
                    '(' + SelectExpression + ') AS ' + QUOTENAME(Alias)
                ELSE
                    SelectExpression + CASE WHEN Alias IS NOT NULL AND Alias <> SelectExpression THEN ' AS ' + QUOTENAME(Alias) ELSE '' END
            END
        FROM @SelectFields
        ORDER BY SequenceNumber
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, LEN(',' + @CRLF), '');
 
 --print('5.SelectClause '+@SelectClause)
 --select * from Dataset_Joins
    -- Step 5: Retrieve and build the JOIN clauses
    INSERT INTO @Joins (DatasetJoinID, JoinType, FromTableAlias, ToTableAlias, ToDatabaseName, ToSchemaName, ToTableName, OnClause, AdditionalConditions,JoinOrder)
    SELECT
        dj.DatasetJoinID,
        dj.JoinType,
        ft.Alias AS FromTableAlias,
        tt.Alias AS ToTableAlias,
        tt.DatabaseName,
        tt.SchemaName,
        tt.TableName,
        NULL AS OnClause,  -- We'll build this later
        dj.AdditionalConditions,
		dj.JoinOrder
    FROM ztDatasetJoins dj
        left outer JOIN @Tables ft ON dj.FromTableID = ft.DatasetTableID
        left outer JOIN @Tables tt ON dj.ToTableID = tt.DatasetTableID
    WHERE dj.DatasetID = @DatasetID;
 --select  '5.Join ' as ord,* from @Joins
    -- Build the ON clauses by aggregating conditions
    DECLARE @JoinConditions TABLE (
        DatasetJoinID INT,
        Condition NVARCHAR(MAX),
        ConditionOrder INT
    );
 
 --SELECT * FROM @Joins

    INSERT INTO @JoinConditions (DatasetJoinID, Condition, ConditionOrder)
    SELECT
        djc.DatasetJoinID,
        QUOTENAME(ft.Alias) + '.' + QUOTENAME(fc.ColumnName) + ' ' + djc.Operator + ' ' + QUOTENAME(tt.Alias) + '.' + QUOTENAME(tc.ColumnName),
        djc.ConditionOrder
    FROM ztDatasetJoinConditions djc
        INNER JOIN ztDatasetJoins dj ON djc.DatasetJoinID = dj.DatasetJoinID
        INNER JOIN @Tables ft ON dj.FromTableID = ft.DataSetTableID
        INNER JOIN @Tables tt ON dj.ToTableID = tt.DataSetTableID
        INNER JOIN ztDatasetTableColumns fc ON djc.FromColumnID = fc.ColumnID
        INNER JOIN ztDatasetTableColumns tc ON djc.ToColumnID = tc.ColumnID
    WHERE
        dj.DatasetID = @DatasetID;
 --select 'Join COnd'  as ord, * from @JoinConditions
    -- Update @Joins with the aggregated ON clauses
    UPDATE j
    SET OnClause = (
        SELECT STRING_AGG(c.Condition, ' AND ') within group (order by c.ConditionOrder)
        FROM @JoinConditions c
        WHERE c.DatasetJoinID = j.DatasetJoinID
        --ORDER BY c.ConditionOrder
    )
    FROM @Joins j;
 --select '7.' as ord ,* from @Joins
   	-- Build the JOIN clauses
SELECT @JoinClauses = ISNULL(@JoinClauses + @CRLF, '') +
    j.JoinType + ' ' +
    QUOTENAME(j.ToDatabaseName) + '.' + QUOTENAME(j.ToSchemaName) + '.' + QUOTENAME(j.ToTableName) + ' AS ' + QUOTENAME(j.ToTableAlias) +
    ' ON ' + j.OnClause +
    CASE WHEN j.AdditionalConditions IS NOT NULL THEN ' AND ' + j.AdditionalConditions ELSE '' END
FROM @Joins j
ORDER BY j.JoinOrder;
 
 --SELECT * FROM @JoinConditions
 
    -- Step 6: Assemble the complete query
    SET @GeneratedQuery = 'SELECT' + @CRLF + @SelectClause + @CRLF + @FromClause + @CRLF + @JoinClauses;
 --print(@GeneratedQuery)
    -- Step 7: Create or Alter the View
    SET @DynamicSQL = '
    IF OBJECT_ID(''' + QUOTENAME(@ViewName) + ''', ''V'') IS NOT NULL
    BEGIN
        DROP VIEW ' + QUOTENAME(@ViewName) + ';
    END;
 
    EXEC(''CREATE VIEW ' + QUOTENAME(@ViewName) + ' AS
    ' + REPLACE(@GeneratedQuery, '''', '''''') + ''');
    ';
 
    -- Execute the Dynamic SQL to create the view
    EXEC sp_executesql @DynamicSQL;
 
    -- For debugging purposes, you can print the generated query
     PRINT @GeneratedQuery;
     PRINT @DynamicSQL;
END;
GO
/****** Object:  StoredProcedure [dbo].[webDataSetMasterParseSQLInsertIntoSelectFieldsIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webDataSetMasterParseSQLInsertIntoSelectFieldsIns]  @DatasetID INT,    @Select_SQL NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
 
    -- Temporary table to hold each field from the SELECT query
    CREATE TABLE #SelectFieldsTemp (
        SequenceNumber INT IDENTITY(1,1) PRIMARY KEY,
        FieldText NVARCHAR(MAX)
    );
 
    -- Replace CRLF and CR with LF for consistent line breaks
	SET @Select_SQL = REPLACE(@Select_SQL,'''','''''');
    SET @Select_SQL = REPLACE(REPLACE(@Select_SQL, CHAR(13) + CHAR(10), CHAR(10)), CHAR(13), CHAR(10));
 
    -- Split the SELECT query into lines (fields)
    DECLARE @FieldText NVARCHAR(MAX);
    DECLARE @Pos INT = 1;
    DECLARE @NextPos INT;
    DECLARE @Len INT = LEN(@Select_SQL);
 
    WHILE @Pos <= @Len
    BEGIN
        SET @NextPos = CHARINDEX(CHAR(10), @Select_SQL, @Pos);
        IF @NextPos = 0
        BEGIN
            SET @FieldText = SUBSTRING(@Select_SQL, @Pos, @Len - @Pos + 1);
            SET @Pos = @Len + 1;
        END
        ELSE
        BEGIN
            SET @FieldText = SUBSTRING(@Select_SQL, @Pos, @NextPos - @Pos);
            SET @Pos = @NextPos + 1;
        END
 
        -- Trim and check if the line is not empty
        SET @FieldText = LTRIM(RTRIM(@FieldText));
        IF @FieldText <> ''
        BEGIN
            INSERT INTO #SelectFieldsTemp (FieldText)
            VALUES (@FieldText);
        END
    END
 
    -- Variables for parsing
    DECLARE @SequenceNumber INT;
    DECLARE @Expression NVARCHAR(MAX);
    DECLARE @Alias NVARCHAR(100);
    DECLARE @ColumnID INT;
    DECLARE @DatasetTableID INT;
    DECLARE @IsExpression BIT;
    DECLARE @CleanExpression NVARCHAR(MAX);
 
    -- Cursor to loop through each field
    DECLARE FieldCursor CURSOR FOR
    SELECT SequenceNumber, FieldText
    FROM #SelectFieldsTemp
    ORDER BY SequenceNumber;
 
    OPEN FieldCursor;
    FETCH NEXT FROM FieldCursor INTO @SequenceNumber, @FieldText;
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Trim field text and remove trailing commas
        SET @FieldText = LTRIM(RTRIM(@FieldText));
        IF RIGHT(@FieldText, 1) = ','
            SET @FieldText = LEFT(@FieldText, LEN(@FieldText) - 1);
 
        -- Initialize variables
        SET @Expression = NULL;
        SET @Alias = NULL;
        SET @ColumnID = NULL;
        SET @DatasetTableID = NULL;
        SET @IsExpression = 0;
        SET @CleanExpression = NULL;
 
        -- Check for ' AS ' to identify alias
        IF CHARINDEX(' AS ', UPPER(@FieldText)) > 0
        BEGIN
            SET @Expression = LEFT(@FieldText, CHARINDEX(' AS ', UPPER(@FieldText)) - 1);
            SET @Alias = LTRIM(RTRIM(RIGHT(@FieldText, LEN(@FieldText) - CHARINDEX(' AS ', UPPER(@FieldText)) - 3)));
        END
        ELSE
        BEGIN
            SET @Expression = @FieldText;
            SET @Alias = NULL;
        END
 
        -- Attempt to match the expression to a column in TableColumns
        -- Remove any database and schema prefixes for matching
        SET @CleanExpression = @Expression;
 
        -- Remove any brackets or quotes around identifiers
        SET @CleanExpression = REPLACE(REPLACE(@CleanExpression, '[', ''), ']', '');
        SET @CleanExpression = REPLACE(REPLACE(@CleanExpression, '"', ''), '', '');
 
        -- Extract table alias and column name
        DECLARE @TableAlias NVARCHAR(128) = NULL;
        DECLARE @ColumnName NVARCHAR(128) = NULL;
 
        IF CHARINDEX('.', @CleanExpression) > 0
        BEGIN
            -- Split at the last dot to separate table alias and column name
            SET @TableAlias = LEFT(@CleanExpression, LEN(@CleanExpression) - CHARINDEX('.', REVERSE(@CleanExpression)));
            SET @ColumnName = RIGHT(@CleanExpression, CHARINDEX('.', REVERSE(@CleanExpression)) - 1);
        END
        ELSE
        BEGIN
            SET @ColumnName = @CleanExpression;
        END
 
        -- Clean up identifiers
        SET @TableAlias = LTRIM(RTRIM(@TableAlias));
        SET @ColumnName = LTRIM(RTRIM(@ColumnName));
 
        -- Check if the expression is a complex expression (contains parentheses)
        IF CHARINDEX('(', @Expression) > 0 AND CHARINDEX(')', @Expression) > 0
        BEGIN
            SET @IsExpression = 1;
        END
 
        -- Try to find the DatasetTableID from Dataset_Tables using the table alias
        IF @TableAlias IS NOT NULL
        BEGIN
            SELECT TOP 1 @DatasetTableID = dt.DatasetTableID
            FROM ztDatasetTables dt
            INNER JOIN ztDatasetAvailableTables at ON dt.TableID = at.TableID
            WHERE dt.DatasetID = @DatasetID
              AND (dt.Alias = @TableAlias OR at.TableName = @TableAlias)
        END
 
        -- If DatasetTableID is found, get the corresponding TableID
        DECLARE @TableID INT = NULL;
        IF @DatasetTableID IS NOT NULL
        BEGIN
            SELECT @TableID = dt.TableID
            FROM ztDatasetTables dt
            WHERE dt.DatasetTableID = @DatasetTableID;
        END
 
        -- Try to find ColumnID in TableColumns using TableID and ColumnName
        IF @TableID IS NOT NULL
        BEGIN
            SELECT TOP 1 @ColumnID = tc.ColumnID
            FROM ztDatasetTableColumns tc
            WHERE tc.TableID = @TableID
              AND tc.ColumnName = @ColumnName;
        END
        ELSE
        BEGIN
            -- If no TableID, try to find ColumnID without TableID (less accurate)
            SELECT TOP 1 @ColumnID = tc.ColumnID
            FROM ztDatasetTableColumns tc
            WHERE tc.ColumnName = @ColumnName;
        END
 
        IF @ColumnID IS NOT NULL AND @IsExpression = 0
        BEGIN
            -- Simple column reference
            SET @IsExpression = 0;
        END
        ELSE
        BEGIN
            -- Expression or column not found
            SET @IsExpression = 1;
            SET @ColumnID = NULL;
            SET @DatasetTableID = NULL;
        END
 
        -- Insert into Dataset_SelectFields
        INSERT INTO ztDatasetSelectFields(
            DatasetID,
            DatasetTableID,
            ColumnID,
            ExpressionText,
            Alias,
            SequenceNumber,
            IsVisible
        )
        VALUES (
            @DatasetID,
            @DatasetTableID,
            @ColumnID,
            CASE WHEN @IsExpression = 1 THEN @Expression ELSE NULL END,
            @Alias,
            @SequenceNumber,
            1  -- IsVisible
        );
 
        FETCH NEXT FROM FieldCursor INTO @SequenceNumber, @FieldText;
    END
 
    CLOSE FieldCursor;
    DEALLOCATE FieldCursor;
 
    DROP TABLE #SelectFieldsTemp;
END;
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXref_AllValuesByTargetIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --exec [webGlobalXref_AllValuesByTargetIns] 

 
--select * from [DataGarage].dbo.[dgTargetSourceTable] where [target] like '%s4d%'

--select * from T134

--select * from [dbo].[ztGlobalXrefTargetSystem]



CREATE   PROCEDURE [dbo].[webGlobalXref_AllValuesByTargetIns]
AS
DECLARE @SQLQuery nvarchar(MAX)
DECLARE @WaveProcessAreaObjectTargetID nvarchar(50)
DECLARE @CheckTableName nvarchar(50)
 
 
DECLARE cur CURSOR LOCAL for
 
SELECT-- WaveID
      --,zWave
      --,zWaveName
      --,WaveProcessAreaID
      --,ProcessAreaID
      --,ProcessArea
      --,ProcessAreaDescription
      --,WaveProcessAreaObjectID
      --,ObjectID
      --,ObjectName
      --,ObjectDescription
      WaveProcessAreaObjectTargetID
      --,TargetName
      --,TargetDescription
      --,TargetPriority
      ,CheckTableName
  FROM WRKDQHARMONIZE.dbo.webXrefMappingsSel
 
 TRUNCATE TABLE [WRKDQHARMONIZE].dbo.[ztGlobalXref_AllValuesByTarget]
 
OPEN cur;
FETCH NEXT FROM cur into @WaveProcessAreaObjectTargetID, @CheckTableName
 
 
WHILE @@FETCH_STATUS = 0
BEGIN
 
SET @SQLQuery = '
 
      INSERT INTO [WRKDQHARMONIZE].dbo.[ztGlobalXref_AllValuesByTarget]
                  ([CheckTableName]
				   ,[Target]
                   ,[WaveProcessAreaObjectTargetID]
                   ,[zSource]
				   ,[LegacyValue01]
				   ,[TargetValue01]
				   ,[LegacyValue02]
				   ,[TargetValue02]
				   ,[LegacyValue03]
				   ,[TargetValue03]
				   ,[zRelevant]
				   ,SnapshotOn)
      (SELECT DISTINCT '''+@CheckTableName+''' AS [CheckTableName]
              ,ztGlobalXref.CheckTableName AS [Target]
			  ,'''+@WaveProcessAreaObjectTargetID+''' AS WaveProcessAreaObjectTargetID
              ,'+@CheckTableName+'.[zSource]
			  ,'+@CheckTableName+'.[LegacyValue01]
			  ,'+@CheckTableName+'.[TargetValue01]
			  ,'+@CheckTableName+'.[LegacyValue02]
			  ,'+@CheckTableName+'.[TargetValue02]
			  ,'+@CheckTableName+'.[LegacyValue03]
			  ,'+@CheckTableName+'.[TargetValue03]
			  ,'+@CheckTableName+'.[zRelevant]
              , getdate() AS SnapShotOn
       FROM   WRKDQHARMONIZE.dbo.ztGlobalXref
	   CROSS JOIN [dbo].[ztGlobalXrefTargetSystem]
             /* LEFT OUTER JOIN [DataGarage].dbo.[dgTargetSourceTable]
                           ON [DataGarage].dbo.[dgTargetSourceTable].[Table] = WRKDQHARMONIZE.dbo.ztGlobalXref.CheckTableName
                              AND [Target] = ztGlobalXrefTargetSystem.TargetSystem*/
	   CROSS JOIN WRKDQHARMONIZE.dbo.'+@CheckTableName+'
	   --WHERE ztGlobalXref.[Active] = 0
       )
 
 
'
 
--PRINT @SQLQuery
EXEC (@SQLQuery)
 
FETCH NEXT FROM cur into @WaveProcessAreaObjectTargetID, @CheckTableName
END;
CLOSE cur;
DEALLOCATE cur;
 
 

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefAutoMapByDescriptionGroupUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[webGlobalXrefAutoMapByDescriptionGroupUpd] @CheckTableName nvarchar(50),
                                                      @boaUserID      nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @ViewName NVARCHAR(255)

    SET @SQLQuery = 
	/*
	'
UPDATE a
SET [Group] = (dense_rank() over(order by a.LegacyValue01))
, a.ChangedBy = ''' + @boaUserID + '''
, a.ChangedOn = getdate()
, a.ChangedVia = ''AutoMap''
FROM ' + @CheckTableName + ' a
INNER JOIN ' + @CheckTableName + '
ON a.LegacyValue01 = ' + @CheckTableName + '.LegacyValue01
WHERE a.[Group] IS NULL
GROUP BY a.LegacyValue01
'
*/

'
WITH CTE_AutoGroup  
AS  
(SELECT LegacyValue01Description, dense_rank() over(order by LegacyValue01Description) as [GroupNew] 
FROM ' + @CheckTableName + '
INNER JOIN web' + @CheckTableName + 'LegacyValue01DescriptionList
ON ' + @CheckTableName + '.zSource = web' + @CheckTableName + 'LegacyValue01DescriptionList.zSource 
AND ' + @CheckTableName + '.LegacyValue01 = web' + @CheckTableName + 'LegacyValue01DescriptionList.LegacyValue01
WHERE ISNULL(LegacyValue01Description, '''') <> ''''
GROUP BY LegacyValue01Description
HAVING COUNT(*) > 1)  
UPDATE ' + @CheckTableName + ' 
SET [Group] = [GroupNew]
, ChangedBy = ''' + @boaUserID + '''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM ' + @CheckTableName + '
INNER JOIN web' + @CheckTableName + 'LegacyValue01DescriptionList
ON ' + @CheckTableName + '.zSource = web' + @CheckTableName + 'LegacyValue01DescriptionList.zSource 
AND ' + @CheckTableName + '.LegacyValue01 = web' + @CheckTableName + 'LegacyValue01DescriptionList.LegacyValue01
INNER JOIN CTE_AutoGroup 
ON CTE_AutoGroup.LegacyValue01Description = web' + @CheckTableName + 'LegacyValue01DescriptionList.LegacyValue01Description
WHERE [Group] IS NULL
'
    PRINT @SQLQuery
    EXEC (@SQLQuery) 
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefAutoMapGroupUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefAutoMapGroupUpd] @CheckTableName nvarchar(50),
                                                      @boaUserID      nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @ViewName NVARCHAR(255)

SET @SQLQuery = 
	/*
	'
UPDATE a
SET [Group] = (dense_rank() over(order by a.LegacyValue01))
, a.ChangedBy = ''' + @boaUserID + '''
, a.ChangedOn = getdate()
, a.ChangedVia = ''AutoMap''
FROM ' + @CheckTableName + ' a
INNER JOIN ' + @CheckTableName + '
ON a.LegacyValue01 = ' + @CheckTableName + '.LegacyValue01
WHERE a.[Group] IS NULL
GROUP BY a.LegacyValue01
'
*/
/*update the Group field when NO TargetValue is maintained*/
'
WITH CTE_AutoGroup  
AS  
(SELECT LegacyValue01, dense_rank() over(order by LegacyValue01) as [GroupNew] 
FROM ' + @CheckTableName + '
GROUP BY LegacyValue01
HAVING COUNT(*) > 1)  
UPDATE ' + @CheckTableName + ' 
SET [Group] = [GroupNew]
, ChangedBy = ''' + @boaUserID + '''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM CTE_AutoGroup 
WHERE ' + @CheckTableName + '.LegacyValue01 = CTE_AutoGroup.LegacyValue01 
AND [Group] IS NULL
AND ' + @CheckTableName + '.TargetValue01 IS NULL
'
    PRINT @SQLQuery
    EXEC (@SQLQuery) 


SET @SQLQuery = 
/*update the Group field when TargetValue is maintained*/
'
WITH CTE_AutoGroup  
AS  
(SELECT TargetValue01, dense_rank() over(order by TargetValue01) as [GroupNew] 
FROM ' + @CheckTableName + '
GROUP BY TargetValue01
HAVING COUNT(*) > 1)  
UPDATE ' + @CheckTableName + ' 
SET [Group] = [GroupNew]
, ChangedBy = ''' + @boaUserID + '''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM CTE_AutoGroup 
WHERE ' + @CheckTableName + '.TargetValue01 = CTE_AutoGroup.TargetValue01 
AND [Group] IS NULL
AND ' + @CheckTableName + '.TargetValue01 IS NOT NULL
'
    PRINT @SQLQuery
    EXEC (@SQLQuery) 
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefAutoMapTargetValue01Upd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefAutoMapTargetValue01Upd] @CheckTableName nvarchar(50), @boaUserID nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue01DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )
/*AutoMap*/

SET @SQLQuery = '

UPDATE '+@CheckTableName+'
SET TargetValue01 = (CASE WHEN ISNULL('+@CheckTableName+'.TargetValue01, '''') = '''' THEN web'+@CheckTableName+'TargetValue01DescriptionList.TargetValue01 ELSE '+@CheckTableName+'.TargetValue01 END)
, ChangedBy = '''+@boaUserID+'''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM '+@CheckTableName+'
INNER JOIN web'+@CheckTableName+'TargetValue01DescriptionList
ON '+@CheckTableName+'.LegacyValue01 = web'+@CheckTableName+'TargetValue01DescriptionList.TargetValue01
'

PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefAutoMapTargetValue02Upd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[webGlobalXrefAutoMapTargetValue02Upd] @CheckTableName nvarchar(50), @boaUserID nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue02DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )
/*AutoMap*/

SET @SQLQuery = '

UPDATE '+@CheckTableName+'
SET TargetValue02 = (CASE WHEN ISNULL('+@CheckTableName+'.TargetValue02, '''') = '''' THEN web'+@CheckTableName+'TargetValue02DescriptionList.TargetValue02 ELSE '+@CheckTableName+'.TargetValue02 END)
, ChangedBy = '''+@boaUserID+'''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM '+@CheckTableName+'
INNER JOIN web'+@CheckTableName+'TargetValue02DescriptionList
ON '+@CheckTableName+'.LegacyValue02 = web'+@CheckTableName+'TargetValue02DescriptionList.TargetValue02
'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefAutoMapTargetValue03Upd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[webGlobalXrefAutoMapTargetValue03Upd] @CheckTableName nvarchar(50), @boaUserID nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue03DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )
/*AutoMap*/

SET @SQLQuery = '

UPDATE '+@CheckTableName+'
SET TargetValue03 = (CASE WHEN ISNULL('+@CheckTableName+'.TargetValue03, '''') = '''' THEN web'+@CheckTableName+'TargetValue03DescriptionList.TargetValue03 ELSE '+@CheckTableName+'.TargetValue03 END)
, ChangedBy = '''+@boaUserID+'''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM '+@CheckTableName+'
INNER JOIN web'+@CheckTableName+'TargetValue03DescriptionList
ON '+@CheckTableName+'.LegacyValue03 = web'+@CheckTableName+'TargetValue03DescriptionList.TargetValue03
'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefAutoMapTargetValuesUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webGlobalXrefAutoMapTargetValuesUpd] @CheckTableName nvarchar(50), @boaUserID nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)

/*AutoMap*/

SET @SQLQuery = '

UPDATE '+@CheckTableName+'
SET TargetValue = (CASE WHEN ISNULL('+@CheckTableName+'.TargetValue, '''') = '''' THEN web'+@CheckTableName+'TargetValueList.TargetValue ELSE '+@CheckTableName+'.TargetValue END)
, ChangedBy = '''+@boaUserID+'''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM '+@CheckTableName+'
INNER JOIN web'+@CheckTableName+'TargetValueList
ON '+@CheckTableName+'.LegacyValue = web'+@CheckTableName+'TargetValueList.TargetValue
'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefAutoMapValuesAudit]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  CREATE PROCEDURE [dbo].[webGlobalXrefAutoMapValuesAudit] @CheckTableName nvarchar(50)
  AS
 UPDATE ztGlobalXref
 SET AutoMapValuesOn = getdate()
 FROM WRKDQHARMONIZE.dbo.ztGlobalXref
 WHERE CheckTableName = @CheckTableName
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefcMapCheckTableIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefcMapCheckTableIns]
AS
  BEGIN
      INSERT INTO ztGlobalXref
                  (CheckTableName,
                   Active,
                   Comments)
      (SELECT DISTINCT CheckTable                        AS CheckTableName,
                       1                                 AS Active,
                       'Automatically inserted from Map' AS Comments
       FROM   cMap_webTargetFieldMappingHor
              LEFT OUTER JOIN WRKDQHARMONIZE.dbo.ztGlobalXref
                           ON WRKDQHARMONIZE.dbo.ztGlobalXref.CheckTableName = cMap_webTargetFieldMappingHor.CheckTable
		      INNER JOIN WRKDQHARMONIZE.dbo.Console_webTargetLookupTableHor 
                           ON WRKDQHARMONIZE.dbo.Console_webTargetLookupTableHor.ValueTableName = cMap_webTargetFieldMappingHor.CheckTable
       WHERE  ISNULL(CheckTable, '') <> ''
              AND CheckTableName IS NULL
			  AND [Type] = 'Configuration')
  END 
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTableAudit]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTableAudit] @CheckTableName nvarchar(50)
  AS
 UPDATE ztGlobalXref
 SET CreateCheckTableOn = getdate()
 FROM WRKDQHARMONIZE.dbo.ztGlobalXref
 WHERE CheckTableName = @CheckTableName
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTableGroupGlobalXRef_PowerUserIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTableGroupGlobalXRef_PowerUserIns]
AS

/*inserts the group GlobalXRef_PowerUser to every xref page*/
BEGIN

INSERT INTO CranSoft.dbo.WebAppGroupPage (GroupID, PageID, AllowSelect, AllowInsert, AllowUpdate, AllowDelete)

select 'BE6458A6-12AD-4B1F-AE22-3B2A1EDE5C82' AS GroupID, [Page].PageID, 1 AS AllowSelect, 0 AS AllowInsert, 1 AS AllowUpdate, 0 AS AllowDelete
--, [Page].Description, * 
FROM CranSoft.dbo.[Page]
LEFT OUTER JOIN CranSoft.dbo.WebAppGroupPage
ON WebAppGroupPage.PageID = [Page].PageID
AND GroupID = 'BE6458A6-12AD-4B1F-AE22-3B2A1EDE5C82'
WHERE Description like 'GX_%'
AND GroupID IS NULL 
END
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTableGroupGlobalXRef_ValueMapperIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTableGroupGlobalXRef_ValueMapperIns]
AS

/*inserts the group GlobalXRef_ValueMapper to every xref page*/
BEGIN
INSERT INTO CranSoft.dbo.WebAppGroupPage (GroupID, PageID, AllowSelect, AllowInsert, AllowUpdate, AllowDelete)

select '6138B7D6-4819-4C2C-81F3-4027636CA909' AS GroupID, [Page].PageID, 1 AS AllowSelect, 0 AS AllowInsert, 1 AS AllowUpdate, 0 AS AllowDelete
--, [Page].Description, * 
FROM CranSoft.dbo.[Page]
LEFT OUTER JOIN CranSoft.dbo.WebAppGroupPage
ON WebAppGroupPage.PageID = [Page].PageID
AND GroupID = '6138B7D6-4819-4C2C-81F3-4027636CA909'
WHERE Description like 'GX_%'
AND GroupID IS NULL 
END

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTableHorizontalViewIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTableHorizontalViewIns] @CheckTableName nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
	
    SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[web'
                    + @CheckTableName + 'Hor]''))
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.[web'
                    + @CheckTableName + 'Hor]
AS
SELECT 
zSource
,SourceSystemID
,LegacyValue01
,TargetValue01
,LegacyValue02
,TargetValue02
,LegacyValue03
,TargetValue03
,[Group]
,zRelevant
,AddedBy
,AddedOn
,AddedVia
,ChangedBy
,ChangedOn
,ChangedVia
FROM [' + @CheckTableName + ']''
END'

    --PRINT @SQLQuery
    EXEC (@SQLQuery) 
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTableIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTableIns] @CheckTableName nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @SQLQuery1 nvarchar(MAX)
    DECLARE @SQLQuery2 nvarchar(MAX)
    DECLARE @SQLQuery3 nvarchar(MAX)
	
    SET @SQLQuery1 = '

BEGIN
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].['
                     + @CheckTableName + ']'') AND type in (N''U''))

'

    IF (SELECT ValueField01
        FROM   ztGlobalXref
        WHERE  CheckTableName = @CheckTableName) IS NOT NULL
      BEGIN
          SET @SQLQuery2 = '
BEGIN
CREATE TABLE dbo.['
                     + @CheckTableName + ']
(
zSource [nvarchar](50) NOT NULL,
SourceSystemID [nvarchar](50) NOT NULL,
LegacyValue01 [nvarchar](50) NOT NULL,
TargetValue01 [nvarchar](50) NULL,
LegacyValue02 [nvarchar](50) NULL,
TargetValue02 [nvarchar](50) NULL,
LegacyValue03 [nvarchar](50) NULL,
TargetValue03 [nvarchar](50) NULL,
[Group] [nvarchar](50) NULL,
zRelevant [bit] NULL,
AddedBy [nvarchar](50) NULL,
AddedOn [smalldatetime] NULL,
AddedVia [nvarchar](50) NULL,
ChangedBy [nvarchar](50) NULL,
ChangedOn [smalldatetime] NULL,
ChangedVia [nvarchar](50) NULL,
 CONSTRAINT [PK_'
                     + @CheckTableName
                     + '] PRIMARY KEY CLUSTERED 
(
zSource, LegacyValue01
) '
      END




    IF (SELECT ValueField02
        FROM   ztGlobalXref
        WHERE  CheckTableName = @CheckTableName) IS NOT NULL
      BEGIN
          SET @SQLQuery2 = '
BEGIN
CREATE TABLE dbo.['
                     + @CheckTableName + ']
(
zSource [nvarchar](50) NOT NULL,
SourceSystemID [nvarchar](50) NOT NULL,
LegacyValue01 [nvarchar](50) NOT NULL,
TargetValue01 [nvarchar](50) NULL,
LegacyValue02 [nvarchar](50) NOT NULL,
TargetValue02 [nvarchar](50) NULL,
LegacyValue03 [nvarchar](50) NULL,
TargetValue03 [nvarchar](50) NULL,
[Group] [nvarchar](50) NULL,
zRelevant [bit] NULL,
AddedBy [nvarchar](50) NULL,
AddedOn [smalldatetime] NULL,
AddedVia [nvarchar](50) NULL,
ChangedBy [nvarchar](50) NULL,
ChangedOn [smalldatetime] NULL,
ChangedVia [nvarchar](50) NULL,
 CONSTRAINT [PK_'
                     + @CheckTableName
                     + '] PRIMARY KEY CLUSTERED 
(
zSource, LegacyValue01, LegacyValue02
) '
      END




    IF (SELECT ValueField03
        FROM   ztGlobalXref
        WHERE  CheckTableName = @CheckTableName) IS NOT NULL
      BEGIN
          SET @SQLQuery2 = '
BEGIN
CREATE TABLE dbo.['
                     + @CheckTableName + ']
(
zSource [nvarchar](50) NOT NULL,
SourceSystemID [nvarchar](50) NOT NULL,
LegacyValue01 [nvarchar](50) NOT NULL,
TargetValue01 [nvarchar](50) NULL,
LegacyValue02 [nvarchar](50) NOT NULL,
TargetValue02 [nvarchar](50) NULL,
LegacyValue03 [nvarchar](50) NOT NULL,
TargetValue03 [nvarchar](50) NULL,
[Group] [nvarchar](50) NULL,
zRelevant [bit] NULL,
AddedBy [nvarchar](50) NULL,
AddedOn [smalldatetime] NULL,
AddedVia [nvarchar](50) NULL,
ChangedBy [nvarchar](50) NULL,
ChangedOn [smalldatetime] NULL,
ChangedVia [nvarchar](50) NULL,
 CONSTRAINT [PK_'
                     + @CheckTableName
                     + '] PRIMARY KEY CLUSTERED 
(
zSource, LegacyValue01, LegacyValue02, LegacyValue03
) '
      END




    SET @SQLQuery3 = 'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[' + @CheckTableName
                     + '] ADD  CONSTRAINT [DF_' + @CheckTableName
                     + '_zRelevant]  DEFAULT ((1)) FOR [zRelevant]

END


END'
    SET @SQLQuery = @SQLQuery1 + @SQLQuery2 + @SQLQuery3

    PRINT @SQLQuery

    EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTablePageIDUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTablePageIDUpd] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @Description nvarchar(30)
SET @Description = CASE WHEN (SELECT SUBSTRING([Description],1,30) AS [Description] FROM webSystemTypeTableTargetList WHERE TableName = @CheckTableName) IS NULL THEN '' ELSE ' - ' + (SELECT SUBSTRING([Description],1,30) AS [Description] FROM webSystemTypeTableTargetList WHERE TableName = @CheckTableName) END

SET @SQLQuery = '

BEGIN

DECLARE @PageID nvarchar(50)
SET @PageID = (SELECT PageID FROM CranSoft.dbo.[Page] WHERE [Description] = N''GX_'+@CheckTableName+@Description+''' AND WebAppID = N''61120dc0-1f6c-4e68-83d5-89d0633e0649'')


UPDATE [ztGlobalXref]
SET [PageID] = @PageID
WHERE CheckTableName = N'''+@CheckTableName+'''
AND PageID IS NULL


END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTablePageIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTablePageIns] @CheckTableName nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @Description nvarchar(30)

    SET @Description = CASE
                         WHEN (SELECT Substring([Description], 1, 30) AS [Description]
                               FROM   webSystemTypeTableTargetList
                               WHERE  TableName = @CheckTableName) IS NULL THEN ''
                         ELSE ' - '
                              + (SELECT Substring([Description], 1, 30) AS [Description]
                                 FROM   webSystemTypeTableTargetList
                                 WHERE  TableName = @CheckTableName)
                       END
    --print @Description
    SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[Page] WHERE [Description] = N''GX_'
                    + @CheckTableName + ''' AND WebAppID = N''61120dc0-1f6c-4e68-83d5-89d0633e0649'')

BEGIN

INSERT [CranSoft].[dbo].[Page] ([PageID], [Description], [PageType], [WebAppID], [Priority], [HorizontalMenuID], [VerticalMenuID], [CatalogID], [Table], [HorizontalView], [VerticalView],
[ReportView], [DefaultsView], [MaintainPageLocation], [StaticSource], [InsertMethod], [SupportPersistentInsert], [SupportFullPageInsert],
[UpdateMethod], [DefaultPageMode], [SupportDirectUpdate], [SupportFullPageUpdate], [SupportDelete], [SupportDownload],
[SupportReport], [SearchID], [DuplicateDetectionSearchID], [OrderBy], [RefreshRate], [HorizontalTitlebar], [VerticalTitlebar], [NextServiceDate],
[QueueID], [ServiceQty], [ServiceUOM], [Active], [EnableAuditing], [CopiedFromPageID], [boaStatus], [AddedBy], [AddedOn], [ChangedBy], [ChangedOn],
[LockedBy], [LockedOn], [AddedVia], [ChangedVia], [ShowPercentValues], [ShowValues], [BreadcrumbAliasHorizontal], [BreadcrumbAliasVertical], [LazyLoadLists],
[ForceRecordCountQuery], [DuplicateDetectionBindingFieldNames], [TraceMethodID], [ShortDescription], [HoverView], [PageControlView], [UserControlView], 
[DataControlView], [StaticSourceAsFullScreen], [RequireTrigger], [ParameterView], [LegendLocation], [Title], [YTitle], [XTitle], [ChartType], [ShowValueOnHover],
[YShowMajorGridline], [XShowMajorGridline], [YShowMinorGridline], [XShowMinorGridline], [PieLabelLocation], [PieCollectedThreshold], [PieCollectedLabel],
[PieCollectedExploded], [UseSupplementalPieChart], [SupplementalPieChartSize], [ToolbarView], [ForceFilter], [LayoutID], [ZoomType], [StackedType], 
[AllowExplicitQuickLink], [ExcelDataTypeHeader], [ExcelHelpTextHeader], [ExcelColumnNameBackground], [ExcelColumnNameForeground], [ExcelTranslatedNameBackground],
[ExcelTranslatedNameForeground], [ExcelDataTypeBackground], [ExcelDataTypeForeground], [ExcelHelpTextBackground], [ExcelHelpTextForeground], [ExcelInstructions],
[EnableExcelIntegration], [C3DEnabled], [C3DAlpha], [C3DBeta], [C3DDepth], [ExcelHelpTextAsComment]) 
VALUES (NEWID(), N''GX_'
                    + @CheckTableName + @Description
                    + ''', N''Dynamic'', N''61120dc0-1f6c-4e68-83d5-89d0633e0649'', NULL, N''5eee300d-380a-4bbf-83b7-bc8b004a6ba9'', NULL, NULL, N'''
                    + @CheckTableName + ''', N''web'
                    + @CheckTableName + 'Hor'', NULL, NULL, NULL, 0, NULL, 0, 0, 0, 1, NULL, 0, 1, 1, 1, 1, NULL, NULL, N''zSource, LegacyValue'', 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 0, NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 30, 30, 80, 0)

END


END'

    --PRINT @SQLQuery
    EXEC (@SQLQuery) 
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTableSetPageOnValidatePublicTo1Upd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTableSetPageOnValidatePublicTo1Upd]
AS
BEGIN
UPDATE PageEvent
SET [Public] = 1
FROM CranSoft.dbo.PageEvent
WHERE PageID = '3ff6b69e-74ed-4222-9e37-d0bdf05c2bb1'
AND [Event] = 'OnValidate'
AND [Public] = 0
END
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefCreateCheckTableTargetValueListViewIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefCreateCheckTableTargetValueListViewIns] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery01 nvarchar(MAX)
DECLARE @SQLQuery02 nvarchar(MAX)
DECLARE @SQLQuery03 nvarchar(MAX)
DECLARE @DataBaseName nvarchar(50)
DECLARE @ValueField01 nvarchar(50)
DECLARE @ValueField02 nvarchar(50)
DECLARE @ValueField03 nvarchar(50)

SET @DataBaseName = (SELECT TargetSystem FROM ztGlobalXrefTargetSystem)
SET @ValueField01 = (SELECT ISNULL(ValueField01, '''''''''') FROM ztGlobalXref WHERE CheckTableName = @CheckTableName)
SET @ValueField02 = (SELECT ISNULL(ValueField02, '''''''''') FROM ztGlobalXref WHERE CheckTableName = @CheckTableName)
SET @ValueField03 = (SELECT ISNULL(ValueField03, '''''''''') FROM ztGlobalXref WHERE CheckTableName = @CheckTableName)

SET @SQLQuery01 = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[web'+@CheckTableName+'TargetValue01List]''))
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue01list
AS
SELECT 
'+@ValueField01+' AS TargetValue01
FROM '+@DataBaseName+'.dbo.'+@CheckTableName+'''
END
'

SET @SQLQuery02 = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[web'+@CheckTableName+'TargetValue02List]''))
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue02list
AS
SELECT 
'+@ValueField02+' AS TargetValue02
FROM '+@DataBaseName+'.dbo.'+@CheckTableName+'''
END
'

SET @SQLQuery03 = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[web'+@CheckTableName+'TargetValue03List]''))
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue03list
AS
SELECT 
'+@ValueField03+' AS TargetValue03
FROM '+@DataBaseName+'.dbo.'+@CheckTableName+'''
END

'

--PRINT @SQLQuery01
EXEC (@SQLQuery01)

--PRINT @SQLQuery02
EXEC (@SQLQuery02)

--PRINT @SQLQuery03
EXEC (@SQLQuery03)

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefDataGarageInsertCheckTableIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--USE WRKDQHARMONIZE
----GO 

--EXEC [webGlobalXrefDataGarageInsertCheckTableIns] 

CREATE PROCEDURE [dbo].[webGlobalXrefDataGarageInsertCheckTableIns]
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @SQLQuery2 nvarchar(MAX)
    DECLARE @Target nvarchar(50)
    DECLARE @Source nvarchar(50)
    DECLARE @SystemTypeID nvarchar(50)
    DECLARE cur CURSOR LOCAL for
      SELECT [Target],
             [Source],
			 SystemTypeID
      FROM   DataGarage.dbo.dgTargetSource
      WHERE  ( [Target] like '%dg%[_]%[_]%'
                OR [Target] like '%sdb%[_]%[_]%' )
             AND Active = 1

    OPEN cur;

    FETCH NEXT FROM cur into @Target, @Source, @SystemTypeID

    WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @SQLQuery = '
      INSERT INTO [DataGarage].dbo.[dgTargetSourceTable]
                  ([Target],
                   [Source],
                   [Table],
                   [PackageType],
   AddedOn,
   AddedVia)
      (SELECT DISTINCT ''' + @Target
                          + ''' AS [Target],
              ''' + @Source
                          + '''       AS [Source],
              CheckTableName   AS [Table],
              ''CRANPORT''       AS [PackageType],
  getdate() AS AddedOn,
  ''webGlobalXrefDataGarageInsertCheckTableIns'' AS AddedVia
       FROM   WRKDQHARMONIZE.dbo.ztGlobalXref
              LEFT OUTER JOIN [DataGarage].dbo.[dgTargetSourceTable]
                           ON [DataGarage].dbo.[dgTargetSourceTable].[Table] = WRKDQHARMONIZE.dbo.ztGlobalXref.CheckTableName
                              AND [Target] = '''
                          + @Target + '''
				LEFT OUTER JOIN DSPCommon.dbo.ztSystemTypeTable 
						   ON DSPCommon.dbo.ztSystemTypeTable.SystemTypeID = '''+@SystemTypeID+'''
								AND DSPCommon.dbo.ztSystemTypeTable.TableName = WRKDQHARMONIZE.dbo.ztGlobalXref.CheckTableName

              WHERE  [Table] IS NULL AND DSPCommon.dbo.ztSystemTypeTable.TableName IS NOT NULL)

   /*DescriptionTables*/
   INSERT INTO [DataGarage].dbo.[dgTargetSourceTable]
                  ([Target],
                   [Source],
                   [Table],
                   [PackageType],
   AddedOn,
   AddedVia)
      (SELECT DISTINCT ''' + @Target
                          + ''' AS [Target],
              ''' + @Source
                          + '''       AS [Source],
              DescriptionTable01   AS [Table],
              ''CRANPORT''       AS [PackageType],
  getdate() AS AddedOn,
  ''webGlobalXrefDataGarageInsertCheckTableIns'' AS AddedVia
       FROM   WRKDQHARMONIZE.dbo.ztGlobalXref
              LEFT OUTER JOIN [DataGarage].dbo.[dgTargetSourceTable]
                           ON [DataGarage].dbo.[dgTargetSourceTable].[Table] = WRKDQHARMONIZE.dbo.ztGlobalXref.DescriptionTable01
                              AND [Target] = '''
                          + @Target + '''
			LEFT OUTER JOIN DSPCommon.dbo.ztSystemTypeTable 
						   ON DSPCommon.dbo.ztSystemTypeTable.SystemTypeID = '''+@SystemTypeID+'''
								AND DSPCommon.dbo.ztSystemTypeTable.TableName = WRKDQHARMONIZE.dbo.ztGlobalXref.CheckTableName
       WHERE  [Table] IS NULL AND DescriptionTable01 IS NOT NULL AND DSPCommon.dbo.ztSystemTypeTable.TableName IS NOT NULL)
'

--          PRINT @SQLQuery
          EXEC (@SQLQuery)

   SET @SQLQuery2 = '  /*DescriptionTables*/
   INSERT INTO [DataGarage].dbo.[dgTargetSourceTable]
                  ([Target],
                   [Source],
                   [Table],
                   [PackageType],
   AddedOn,
   AddedVia)
      (SELECT DISTINCT ''' + @Target
                          + ''' AS [Target],
              ''' + @Source
                          + '''       AS [Source],
              DescriptionTable02   AS [Table],
              ''CRANPORT''       AS [PackageType],
  getdate() AS AddedOn,
  ''webGlobalXrefDataGarageInsertCheckTableIns'' AS AddedVia
       FROM   WRKDQHARMONIZE.dbo.ztGlobalXref
              LEFT OUTER JOIN [DataGarage].dbo.[dgTargetSourceTable]
                           ON [DataGarage].dbo.[dgTargetSourceTable].[Table] = WRKDQHARMONIZE.dbo.ztGlobalXref.DescriptionTable02
                              AND [Target] = '''
                          + @Target + '''
			  LEFT OUTER JOIN DSPCommon.dbo.ztSystemTypeTable 
						   ON DSPCommon.dbo.ztSystemTypeTable.SystemTypeID = '''+@SystemTypeID+'''
								AND DSPCommon.dbo.ztSystemTypeTable.TableName = WRKDQHARMONIZE.dbo.ztGlobalXref.CheckTableName
       WHERE  [Table] IS NULL AND DescriptionTable02 IS NOT NULL AND DSPCommon.dbo.ztSystemTypeTable.TableName IS NOT NULL)

   /*DescriptionTables*/
   INSERT INTO [DataGarage].dbo.[dgTargetSourceTable]
                  ([Target],
                   [Source],
                   [Table],
                   [PackageType],
   AddedOn,
   AddedVia)
      (SELECT DISTINCT ''' + @Target
                          + ''' AS [Target],
              ''' + @Source
                          + '''       AS [Source],
              DescriptionTable03   AS [Table],
              ''CRANPORT''       AS [PackageType],
  getdate() AS AddedOn,
  ''webGlobalXrefDataGarageInsertCheckTableIns'' AS AddedVia
       FROM   WRKDQHARMONIZE.dbo.ztGlobalXref
              LEFT OUTER JOIN [DataGarage].dbo.[dgTargetSourceTable]
                           ON [DataGarage].dbo.[dgTargetSourceTable].[Table] = WRKDQHARMONIZE.dbo.ztGlobalXref.DescriptionTable03
                              AND [Target] = '''
                          + @Target + '''
LEFT OUTER JOIN DSPCommon.dbo.ztSystemTypeTable 
						   ON DSPCommon.dbo.ztSystemTypeTable.SystemTypeID = '''+@SystemTypeID+'''
								AND DSPCommon.dbo.ztSystemTypeTable.TableName = WRKDQHARMONIZE.dbo.ztGlobalXref.CheckTableName
       WHERE  [Table] IS NULL AND DescriptionTable03 IS NOT NULL AND DSPCommon.dbo.ztSystemTypeTable.TableName IS NOT NULL)

'

         -- PRINT @SQLQuery2
          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @Target, @Source, @SystemTypeID
      END;

    CLOSE cur;

    DEALLOCATE cur; 
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefDataGarageInsertTableFromDesignIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefDataGarageInsertTableFromDesignIns]
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @Target nvarchar(50)
    DECLARE @Source nvarchar(50)
    DECLARE @SystemTypeID nvarchar(50)
    DECLARE cur CURSOR LOCAL for
      SELECT [Target],
             [Source],
			 SystemTypeID
      FROM   DataGarage.dbo.dgTargetSource
      WHERE  ( [Target] like '%dg%[_]%[_]%'
                OR [Target] like '%sdb%[_]%[_]%' )
             AND Active = 1

    OPEN cur;

    FETCH NEXT FROM cur into @Target, @Source, @SystemTypeID

    WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @SQLQuery = '

INSERT INTO [DataGarage].dbo.[dgTargetSourceTable]([Target], [Source], [Table], [PackageType], AddedOn, AddedVia)
SELECT DISTINCT ''' + @Target
                          + ''' AS [Target], ''' + @Source
                          + ''' AS [Source], TargetSystemTableName AS [Table], 
						  ''CRANPORT'' AS [PackageType],
						  getdate() AS AddedOn,
						  ''webGlobalXrefDataGarageInsertTableFromDesignIns'' AS AddedVia
						  FROM Console.dbo.webTargetHor
				LEFT OUTER JOIN [DataGarage].dbo.[dgTargetSourceTable] ON
					[DataGarage].dbo.[dgTargetSourceTable].[Table] = Console.dbo.webTargetHor.TargetSystemTableName
					AND [Target] = ''' + @Target + '''
				LEFT OUTER JOIN DSPCommon.dbo.ztSystemTypeTable 
						   ON DSPCommon.dbo.ztSystemTypeTable.SystemTypeID = '''+@SystemTypeID+'''
								AND DSPCommon.dbo.ztSystemTypeTable.TableName = Console.dbo.webTargetHor.TargetSystemTableName


WHERE [Table] IS NULL
AND ISNULL(TargetSystemTableName, '''')<>''''
AND DSPCommon.dbo.ztSystemTypeTable.TableName IS NOT NULL
'

          --PRINT @SQLQuery
          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @Target, @Source, @SystemTypeID
      END;

    CLOSE cur;

    DEALLOCATE cur; 
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefDeleteCheckTableEntryDel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefDeleteCheckTableEntryDel] @CheckTableName nvarchar(50),
                                                               @PageID         nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
	
    SET @SQLQuery = '
	

BEGIN

IF OBJECT_ID(''' + @CheckTableName
                    + ''', ''U'') IS NOT NULL DROP TABLE ['
                    + @CheckTableName + ']

IF OBJECT_ID(''web'
                    + @CheckTableName
                    + 'Hor'', ''v'') IS NOT NULL DROP VIEW [web'
                    + @CheckTableName + 'Hor]

IF OBJECT_ID(''web'
                    + @CheckTableName
                    + 'TargetValue01List'', ''v'') IS NOT NULL DROP VIEW [web'
                    + @CheckTableName + 'TargetValue01List]

IF OBJECT_ID(''web'
                    + @CheckTableName
                    + 'TargetValue02List'', ''v'') IS NOT NULL DROP VIEW [web'
                    + @CheckTableName + 'TargetValue02List]

IF OBJECT_ID(''web'
                    + @CheckTableName
                    + 'TargetValue03List'', ''v'') IS NOT NULL DROP VIEW [web'
                    + @CheckTableName
                    + 'TargetValue03List]

DELETE FROM CranSoft.dbo.[Page] WHERE PageID = '''
                    + @PageID + '''
END
'

    --PRINT @SQLQuery
    EXEC (@SQLQuery) 


GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefGroupedUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webGlobalXrefGroupedUpd]
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @PageID nvarchar(50)
    DECLARE @JoinValueField01 nvarchar(50)
    DECLARE @JoinValueField02 nvarchar(50)
    DECLARE @JoinValueField03 nvarchar(50)
    DECLARE @DataBaseName nvarchar(50)
    DECLARE @zSource nvarchar(50)
    DECLARE @SourceSystemID nvarchar(50)
    DECLARE @TotalRecords nvarchar(50)
    DECLARE @GroupedRecords nvarchar(50)
    DECLARE @GroupedRecordsRecords02 nvarchar(50)
    DECLARE @GroupedRecordsRecords03 nvarchar(50)
    DECLARE @CheckTableName nvarchar(50)
    DECLARE @CheckTableNameQuoted nvarchar(50)
    DECLARE cur CURSOR LOCAL for
     
	 SELECT CheckTableName
      FROM   ztGlobalXref
      WHERE  Active = 1

    OPEN cur;

    FETCH NEXT FROM cur into @CheckTableName

    WHILE @@FETCH_STATUS = 0
      BEGIN
          print @PageID
          SET @CheckTableNameQuoted = Quotename(@CheckTableName)
		  
          IF EXISTS (SELECT *
                     FROM   sys.TABLES
                     WHERE  object_id = Object_id(@CheckTableNameQuoted))
            SET @SQLQuery = '

DECLARE @TotalRecords nvarchar(50)
DECLARE @GroupedRecords nvarchar(50)

SET @TotalRecords = (SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ')
SET @GroupedRecords = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE [Group] IS NOT NULL)) IS NULL THEN ''Not Grouped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE [Group] IS NOT NULL)) END

BEGIN

UPDATE ztGlobalXref
SET GroupedRecords = 
CASE WHEN @GroupedRecords = ''Not Grouped'' THEN ''Not Grouped'' ELSE @GroupedRecords END 
+ '' / '' 
+ @TotalRecords 
WHERE ChecktableName = ''' + @CheckTableName + '''

END


DECLARE @RelevantTotalRecords nvarchar(50)
DECLARE @RelevantGroupedRecords nvarchar(50)

SET @RelevantTotalRecords = (SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE zRelevant = 1)
SET @RelevantGroupedRecords = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE zRelevant = 1 AND [Group] IS NOT NULL)) IS NULL THEN ''Not Grouped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE zRelevant = 1 AND [Group] IS NOT NULL)) END

BEGIN

UPDATE ztGlobalXref
SET RelevantGroupedRecords = 
CASE WHEN @RelevantGroupedRecords = ''Not Grouped'' THEN ''Not Grouped'' ELSE @RelevantGroupedRecords END 
+ '' / '' 
+ @RelevantTotalRecords 
WHERE ChecktableName = '''  + @CheckTableName + '''

END

'

          PRINT @SQLQuery

          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @CheckTableName
      END;

    CLOSE cur;

    DEALLOCATE cur;

   


GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnLegacyValueDescription01Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnLegacyValueDescription01Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'LegacyValue01DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''LegacyValue01'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField, ListWhereClause) 
VALUES ('''+@PageID+''', ''LegacyValue01'', ''List'', ''web'+@CheckTableName+'LegacyValue01DescriptionList'', ''FriendlyName'', ''LegacyValue01'', ''zSource = ''''#zSource#'''''')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnLegacyValueDescription02Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnLegacyValueDescription02Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'LegacyValue02DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''LegacyValue02'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField, ListWhereClause) 
VALUES ('''+@PageID+''', ''LegacyValue02'', ''List'', ''web'+@CheckTableName+'LegacyValue02DescriptionList'', ''FriendlyName'', ''LegacyValue02'', ''zSource = ''''#zSource#'''' AND LegacyValue01 = ''''#LegacyValue01#'''''')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnLegacyValueDescription03Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnLegacyValueDescription03Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'LegacyValue03DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''LegacyValue03'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField, ListWhereClause) 
VALUES ('''+@PageID+''', ''LegacyValue03'', ''List'', ''web'+@CheckTableName+'LegacyValue03DescriptionList'', ''FriendlyName'', ''LegacyValue03'', ''zSource = ''''#zSource#'''''')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnsAuditIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnsAuditIns] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''AddedBy'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], [ControlStatus]) 
VALUES ('''+@PageID+''', ''AddedBy'', ''TextBox'', 2)

END

END

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''AddedOn'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], [ControlStatus]) 
VALUES ('''+@PageID+''', ''AddedOn'', ''TextBox'', 2)

END

END

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''AddedVia'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], [ControlStatus]) 
VALUES ('''+@PageID+''', ''AddedVia'', ''TextBox'', 2)

END

END


BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''ChangedBy'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], [ControlStatus]) 
VALUES ('''+@PageID+''', ''ChangedBy'', ''TextBox'', 2)

END

END

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''ChangedOn'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], [ControlStatus]) 
VALUES ('''+@PageID+''', ''ChangedOn'', ''TextBox'', 2)

END

END

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''ChangedVia'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], [ControlStatus]) 
VALUES ('''+@PageID+''', ''ChangedVia'', ''TextBox'', 2)

END

END
'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnTargetValue01Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnTargetValue01Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''TargetValue01'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField) 
VALUES ('''+@PageID+''', ''TargetValue01'', ''List'', ''web'+@CheckTableName+'TargetValue01List'', ''TargetValue01'', ''TargetValue01'')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnTargetValue02Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnTargetValue02Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''TargetValue02'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField) 
VALUES ('''+@PageID+''', ''TargetValue02'', ''List'', ''web'+@CheckTableName+'TargetValue02List'', ''TargetValue02'', ''TargetValue02'')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnTargetValue03Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnTargetValue03Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''TargetValue03'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField) 
VALUES ('''+@PageID+''', ''TargetValue03'', ''List'', ''web'+@CheckTableName+'TargetValue03List'', ''TargetValue03'', ''TargetValue03'')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnTargetValueDescription01Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnTargetValueDescription01Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue01DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''TargetValue01'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField) 
VALUES ('''+@PageID+''', ''TargetValue01'', ''List'', ''web'+@CheckTableName+'TargetValue01DescriptionList'', ''FriendlyName'', ''TargetValue01'')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnTargetValueDescription02Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnTargetValueDescription02Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue02DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''TargetValue02'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField, ListWhereClause) 
VALUES ('''+@PageID+''', ''TargetValue02'', ''List'', ''web'+@CheckTableName+'TargetValue02DescriptionList'', ''FriendlyName'', ''TargetValue02'', ''TargetValue01 = ''''#TargetValue01#'''''')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnTargetValueDescription03Ins]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnTargetValueDescription03Ins] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue03DescriptionList'
   IF EXISTS (
            SELECT *
            FROM sys.VIEWS
            WHERE object_id = OBJECT_ID(@ViewName)
            )

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''TargetValue03'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField, ListWhereClause) 
VALUES ('''+@PageID+''', ''TargetValue03'', ''List'', ''web'+@CheckTableName+'TargetValue03DescriptionList'', ''FriendlyName'', ''TargetValue03'', ''TargetValue01 = ''''#TargetValue01#'''' AND TargetValue02 = ''''#TargetValue02#'''''')

END

END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertPageColumnTargetValueIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webGlobalXrefInsertPageColumnTargetValueIns] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @PageID nvarchar(50)

SET @PageID = (SELECT PageID FROM ztGlobalXref where CheckTableName = @CheckTableName)

--print @PageID

SET @SQLQuery = '

BEGIN
IF NOT EXISTS (SELECT * FROM CranSoft.dbo.[PageColumn] WHERE PageID = '''+@PageID+''' AND [Column] = ''TargetValue'')

BEGIN

INSERT [CranSoft].[dbo].[PageColumn] (PageID, [Column], [Control], ListSource, ListDisplayField, ListValueField) 
VALUES ('''+@PageID+''', ''TargetValue'', ''List'', ''web'+@CheckTableName+'TargetValueList'', ''TargetValue'', ''TargetValue'')

END


END'

--PRINT @SQLQuery
EXEC (@SQLQuery)
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateLegacyValue01DescriptionIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateLegacyValue01DescriptionIns] @CheckTableName nvarchar(50)
AS
  BEGIN
      -- Declare variables 
      DECLARE @Sql NVARCHAR(4000)
      DECLARE @SqlSelect NVARCHAR(4000)
      DECLARE @Sql1 NVARCHAR(4000) = ''
      DECLARE @Sql2 NVARCHAR(4000) = ''
      DECLARE @Sql3 NVARCHAR(4000) = ''
      DECLARE @Sql4 NVARCHAR(4000) = ''
      DECLARE @Sql5 NVARCHAR(4000) = ''
      DECLARE @Sql6 NVARCHAR(4000) = ''
      DECLARE @Sql7 NVARCHAR(4000) = ''
      DECLARE @Sql8 NVARCHAR(4000) = ''
      DECLARE @SQLStringNumber INT = 1
      DECLARE @DataSourceName NVARCHAR(50)
      DECLARE @CacheDatabaseName NVARCHAR(128)
      DECLARE @ReportName NVARCHAR(130)
      DECLARE @ReportType NVARCHAR(50)
      DECLARE @Comment NVARCHAR(900)
      DECLARE @Implication NVARCHAR(2000)
      DECLARE @ViewName NVARCHAR(255)
      DECLARE @SummaryViewName NVARCHAR(255)
      DECLARE @PrimaryKeyFields NVARCHAR(900)
      DECLARE @SQLQuery nvarchar(MAX)
      DECLARE @zSource nvarchar(50)
	  DECLARE @SourceSystem nvarchar(50)
	  DECLARE @SourceSystemID nvarchar(50)
      DECLARE @ValueField01 nvarchar(50)
      DECLARE @DescriptionTable01 nvarchar(50)
      DECLARE @DescriptionField01 nvarchar(50)
      DECLARE @DescriptionTableKeyField01 nvarchar(50)
      DECLARE @DescriptionLanguageField nvarchar(50)
      DECLARE @DescriptionLanguageFieldValue nvarchar(50)
	  DECLARE @DescriptionLanguageValueBySystem nvarchar(50)

      -- =============================================
      -- Add target view name as variable incase of rename in future  
      SET @ViewName = 'web' + @CheckTableName
                      + 'LegacyValue01DescriptionList'

      -- =============================================
      --IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(@ViewName))
      --IF EXISTS (SELECT * FROM 'sdb'+@zSource+.sys.tables WHERE name = ''''+@CheckTableName+'''')
      print @ViewName

      -- Drop target UNION view if exists 
      SET @Sql = 'IF EXISTS (SELECT *
                 FROM   sys.VIEWS
                 WHERE  [name] = ''' + @ViewName +''') 
        DROP VIEW [dbo].' + @ViewName +''

      PRINT @Sql

      EXEC (@sql)

      -- BEGIN creating target UNION view 
      SET @Sql = 'CREATE VIEW ' + @ViewName + ' AS '
                 + Char(13)

      DECLARE cursor1 CURSOR LOCAL FAST_FORWARD FOR
        SELECT zSource,
			   SourceSystem,
			   SourceSystemID,
               ValueField01,
               ISNULL(DescriptionTable01, ''),
               ISNULL(DescriptionField01, ''),
               ISNULL(DescriptionTableKeyField01, ''),
               ISNULL(DescriptionLanguageField, ''),
               ISNULL(DescriptionLanguageFieldValue, ''),
			   ISNULL(DescriptionLanguageValueBySystem, '')
        FROM   ztGlobalXrefSourceSystem
               CROSS JOIN ztGlobalXref
        WHERE  CheckTableName = '' + @CheckTableName + ''
		AND ztGlobalXrefSourceSystem.zActive = 1 /*CP 20241511*/

      OPEN cursor1

      FETCH NEXT FROM cursor1 into @zSource, @SourceSystem, @SourceSystemID, @ValueField01, @DescriptionTable01, @DescriptionField01, @DescriptionTableKeyField01, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @DescriptionLanguageValueBySystem

      WHILE @@FETCH_STATUS = 0
        BEGIN
            IF @DescriptionTable01 = ''
              -- Add the select code
              SET @SqlSelect = 'SELECT DISTINCT ''' + @zSource
                               + ''' AS zSource, ' + @ValueField01 + ' AS LegacyValue01, NULL AS LegacyValue01Description
, '
                               + @ValueField01 + ' AS FriendlyName FROM '
                               + @SourceSystem + '.dbo.' + @CheckTableName + '' + Char(13)

            IF @DescriptionTable01 <> ''
               AND @DescriptionLanguageField = ''
               AND @DescriptionLanguageFieldValue = ''
              SET @SqlSelect = 'SELECT DISTINCT ''' + @zSource
                               + ''' AS zSource, Checktable.'
                               + @ValueField01
                               + ' AS LegacyValue01, DescriptionTable01.'
                               + @DescriptionField01
                               + ' AS LegacyValue01Description
,CONCAT(Checktable.' + @ValueField01
                               + ', '' - '', DescriptionTable01.'
                               + @DescriptionField01
                               + ') AS FriendlyName FROM ' + @SourceSystem
                               + '.dbo.' + @CheckTableName + ' AS Checktable
INNER JOIN '
                               + @SourceSystem + '.dbo.' + @DescriptionTable01
                               + ' as DescriptionTable01 ON
Checktable.' + @ValueField01
                               + ' = DescriptionTable01.'
                               + @DescriptionTableKeyField01 + ' AND 
Checktable.SourceSystemID = DescriptionTable01.SourceSystemID AND Checktable.SourceSystemID = '''+@SourceSystemID + ''''+ '' + Char(13)

            IF @DescriptionTable01 <> ''
               AND @DescriptionLanguageField <> ''
               AND @DescriptionLanguageFieldValue <> ''

	  --print '@DescriptionLanguageValueBySystem: ' + ISNULL(@DescriptionLanguageValueBySystem, '')
	  --print '@DescriptionLanguageFieldValue:' + @DescriptionLanguageFieldValue
	  /*Overwrites the language value if there is one maintained in the xtGlobalXrefSourceSystem table*/
	  SET @DescriptionLanguageFieldValue = (CASE WHEN @DescriptionLanguageValueBySystem = '' THEN @DescriptionLanguageFieldValue ELSE @DescriptionLanguageValueBySystem END )
	  --print '@DescriptionLanguageFieldValue:' + @DescriptionLanguageFieldValue

              SET @SqlSelect = 'SELECT DISTINCT ''' + @zSource
                               + ''' AS zSource, Checktable.'
                               + @ValueField01
                               + ' AS LegacyValue01, DescriptionTable01.'
                               + @DescriptionField01
                               + ' AS LegacyValue01Description
,CONCAT(Checktable.' + @ValueField01
                               + ', '' - '', DescriptionTable01.'
                               + @DescriptionField01
                               + ') AS FriendlyName FROM ' + @SourceSystem
                               + '.dbo.' + @CheckTableName + ' AS Checktable
INNER JOIN '
                               + @SourceSystem + '.dbo.' + @DescriptionTable01
                               + ' as DescriptionTable01 ON
Checktable.' + @ValueField01
                               + ' = DescriptionTable01.'
                               + @DescriptionTableKeyField01 + ' AND 
Checktable.SourceSystemID = DescriptionTable01.SourceSystemID AND Checktable.SourceSystemID = '''+@SourceSystemID + ''''+ '' + ' WHERE '
                               + 'DescriptionTable01.'
							   + @DescriptionLanguageField + ' = '''
                               + @DescriptionLanguageFieldValue + '''' + ''
                               + Char(13)

            IF ( ( Len(@Sql) + Len(@SqlSelect) ) > 4000 )
              BEGIN
                  IF @SQLStringNumber = 1
                    BEGIN
                        SET @Sql1 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 2
                    BEGIN
                        SET @Sql2 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 3
                    BEGIN
                        SET @Sql3 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 4
                    BEGIN
                        SET @Sql4 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 5
                    BEGIN
                        SET @Sql5 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 6
                    BEGIN
                        SET @Sql6 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 7
                    BEGIN
                        SET @Sql7 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 8
                    BEGIN
                        SET @Sql8 = @Sql
                    END
                  ELSE
                    BEGIN
                        PRINT 'ERROR: Exceeded maximum length of SQL String'

                        RETURN
                    END

                  SET @Sql = @SqlSelect
                  SET @SQLStringNumber = @SQLStringNumber + 1
              END
            ELSE
              BEGIN
                  SET @Sql = @Sql + @SqlSelect
              END

            FETCH NEXT FROM cursor1 into @zSource, @SourceSystem, @SourceSystemID, @ValueField01, @DescriptionTable01, @DescriptionField01, @DescriptionTableKeyField01, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @DescriptionLanguageValueBySystem

            -- If the loop continues, add the UNION ALL statement.
            IF @@FETCH_STATUS = 0
              BEGIN
                  SET @SqlSelect = ' UNION ALL ' + Char(13)

                  IF ( ( Len(@Sql) + Len(@SqlSelect) ) > 4000 )
                    BEGIN
                        IF @SQLStringNumber = 1
                          BEGIN
                              SET @Sql1 = @Sql
                          END
                        ELSE IF @SQLStringNumber = 2
                          BEGIN
                              SET @Sql2 = @Sql
                          END
                        ELSE IF @SQLStringNumber = 3
                          BEGIN
                              SET @Sql3 = @Sql
                          END
                        ELSE IF @SQLStringNumber = 4
                          BEGIN
                              SET @Sql4 = @Sql
                          END
                        ELSE IF @SQLStringNumber = 5
                          BEGIN
                              SET @Sql5 = @Sql
                          END
                        ELSE IF @SQLStringNumber = 6
                          BEGIN
                              SET @Sql6 = @Sql
                          END
                        ELSE IF @SQLStringNumber = 7
                          BEGIN
                              SET @Sql7 = @Sql
                          END
                        ELSE IF @SQLStringNumber = 8
                          BEGIN
                              SET @Sql8 = @Sql
                          END
                        ELSE
                          BEGIN
                              PRINT 'ERROR: Exceeded maximum length of SQL String'

                              RETURN
                          END

                        SET @Sql = @SqlSelect
                        SET @SQLStringNumber = @SQLStringNumber + 1
                    END
                  ELSE
                    BEGIN
                        SET @Sql = @Sql + @SqlSelect
                    END
              END
        END

      CLOSE cursor1

      DEALLOCATE cursor1

      PRINT @Sql1

      PRINT @Sql2

      PRINT @Sql3

      PRINT @Sql4

      PRINT @Sql5

      PRINT @Sql6

      PRINT @Sql7

      PRINT @Sql8

      PRINT @Sql

      EXEC (@Sql1 + @Sql2 + @Sql3 + @Sql4 + @Sql5 + @Sql6 + @Sql7 + @Sql8 + @Sql)
  END 


GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateLegacyValue02DescriptionIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateLegacyValue02DescriptionIns] @CheckTableName nvarchar(50)
AS
BEGIN
   
   -- Declare variables 
   DECLARE @Sql NVARCHAR(4000)
   DECLARE @SqlSelect NVARCHAR(4000)
   DECLARE @Sql1 NVARCHAR(4000) = ''
   DECLARE @Sql2 NVARCHAR(4000) = ''
   DECLARE @Sql3 NVARCHAR(4000) = ''
   DECLARE @Sql4 NVARCHAR(4000) = ''
   DECLARE @Sql5 NVARCHAR(4000) = ''
   DECLARE @Sql6 NVARCHAR(4000) = ''
   DECLARE @Sql7 NVARCHAR(4000) = ''
   DECLARE @Sql8 NVARCHAR(4000) = ''
      DECLARE @SQLStringNumber INT = 1
   DECLARE @DataSourceName NVARCHAR(50)
   DECLARE @CacheDatabaseName NVARCHAR(128)
   DECLARE @ReportName NVARCHAR(130)
   DECLARE @ReportType NVARCHAR(50)
   DECLARE @Comment NVARCHAR(900)
   DECLARE @Implication NVARCHAR(2000)
   DECLARE @ViewName NVARCHAR(255)
   DECLARE @SummaryViewName NVARCHAR(255)
   DECLARE @PrimaryKeyFields NVARCHAR(900)

   DECLARE @SQLQuery nvarchar(MAX)
   DECLARE @zSource nvarchar(50)
   DECLARE @SourceSystem nvarchar(50)
   DECLARE @ValueField02 nvarchar(50)
   DECLARE @DescriptionTable02 nvarchar(50)
   DECLARE @DescriptionField02 nvarchar(50)
   DECLARE @DescriptionTableKeyField02 nvarchar(50)
   DECLARE @DescriptionLanguageField nvarchar(50)
   DECLARE @DescriptionLanguageFieldValue nvarchar(50)
   DECLARE @ValueField01 nvarchar(50)
   DECLARE @DescriptionTableKeyField01 nvarchar(50)
   
   
   -- =============================================
   -- Add target view name as variable incase of rename in future  
   SET @ViewName = 'web'+@CheckTableName+'LegacyValue02DescriptionList'
   

   -- =============================================

   
   --IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(@ViewName))
   --IF EXISTS (SELECT * FROM 'sdb'+@zSource+.sys.tables WHERE name = ''''+@CheckTableName+'''')
   print @ViewName

   -- Drop target UNION view if exists 
   SET @Sql = 'IF EXISTS (SELECT *
                 FROM   sys.VIEWS
                 WHERE  [name] = ''' + @ViewName +''') 
        DROP VIEW [dbo].' + @ViewName +''

      PRINT @Sql

      EXEC (@sql)

      -- BEGIN creating target UNION view 
      SET @Sql = 'CREATE VIEW ' + @ViewName + ' AS '
                 + Char(13)
   
   DECLARE cursor1 CURSOR LOCAL FAST_FORWARD
   FOR
   SELECT zSource, SourceSystem, ValueField02, ISNULL(DescriptionTable02, ''), ISNULL(DescriptionField02, ''), ISNULL(DescriptionTableKeyField02, '')
   ,ISNULL(DescriptionLanguageField, ''), ISNULL(DescriptionLanguageFieldValue, ''), ISNULL(ValueField01, ''), ISNULL(DescriptionTableKeyField01, '')
   FROM ztGlobalXrefSourceSystem CROSS JOIN ztGlobalXref WHERE CheckTableName = ''+@CheckTableName+''
   AND ztGlobalXrefSourceSystem.zActive = 1 /*CP 20241511*/
   
   OPEN cursor1
   
   FETCH NEXT FROM cursor1 into @zSource, @SourceSystem, @ValueField02, @DescriptionTable02, @DescriptionField02, @DescriptionTableKeyField02, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @ValueField01, @DescriptionTableKeyField01
   
   WHILE @@FETCH_STATUS = 0
   BEGIN

   IF @DescriptionTable02 = ''
      -- Add the select code
            SET @SqlSelect = 'SELECT DISTINCT '''+@zSource+''' AS zSource, '+@ValueField01+' AS LegacyValue01, '+@ValueField02+' AS LegacyValue02, NULL AS LegacyValue02Description
			, '+@ValueField02+' AS FriendlyName FROM '+@SourceSystem+'.dbo.'+@CheckTableName+'' + CHAR(13)
   IF @DescriptionTable02 <> '' AND (@DescriptionLanguageField = '' OR @DescriptionLanguageFieldValue = '')
            SET @SqlSelect = 'SELECT DISTINCT '''+@zSource+''' AS zSource, Checktable.'+@ValueField01+' AS LegacyValue01, Checktable.'+@ValueField02+' AS LegacyValue02, DescriptionTable02.'+@DescriptionField02+' AS LegacyValue02Description
			,CONCAT(Checktable.'+@ValueField02+', '' - '', DescriptionTable02.'+@DescriptionField02+') AS FriendlyName FROM '+@SourceSystem+'.dbo.'+@CheckTableName+' AS Checktable
			INNER JOIN '+@SourceSystem+'.dbo.'+@DescriptionTable02+' as DescriptionTable02 ON
			Checktable.'+@ValueField01+' = DescriptionTable02.'+@DescriptionTableKeyField01+' AND 
			Checktable.'+@ValueField02+' = DescriptionTable02.'+@DescriptionTableKeyField02+'' + CHAR(13)
   IF @DescriptionTable02 <> '' AND (@DescriptionLanguageField <> '' AND @DescriptionLanguageFieldValue <> '')
			SET @SqlSelect = 'SELECT DISTINCT '''+@zSource+''' AS zSource, Checktable.'+@ValueField01+' AS LegacyValue01, Checktable.'+@ValueField02+' AS LegacyValue02, DescriptionTable02.'+@DescriptionField02+' AS LegacyValue02Description
			,CONCAT(Checktable.'+@ValueField02+', '' - '', DescriptionTable02.'+@DescriptionField02+') AS FriendlyName FROM '+@SourceSystem+'.dbo.'+@CheckTableName+' AS Checktable
			INNER JOIN '+@SourceSystem+'.dbo.'+@DescriptionTable02+' as DescriptionTable02 ON
			Checktable.'+@ValueField01+' = DescriptionTable02.'+@DescriptionTableKeyField01+' AND 
			Checktable.'+@ValueField02+' = DescriptionTable02.'+@DescriptionTableKeyField02+''
			+' WHERE '+ 'DescriptionTable02.'+ @DescriptionLanguageField+' = '''+@DescriptionLanguageFieldValue+''''+'' + CHAR(13)

            IF ( (LEN(@Sql) + LEN(@SqlSelect)) > 4000 )
            BEGIN
              IF @SQLStringNumber = 1
                BEGIN
                    SET @Sql1 = @Sql
                END
              ELSE IF @SQLStringNumber = 2
                BEGIN
                    SET @Sql2 = @Sql
                END
              ELSE IF @SQLStringNumber = 3
                BEGIN
                    SET @Sql3 = @Sql
                END
              ELSE IF @SQLStringNumber = 4
                BEGIN
                    SET @Sql4 = @Sql
                END
              ELSE IF @SQLStringNumber = 5
                BEGIN
                    SET @Sql5 = @Sql
                END
              ELSE IF @SQLStringNumber = 6
                BEGIN
                    SET @Sql6 = @Sql
                END
              ELSE IF @SQLStringNumber = 7
                BEGIN
                    SET @Sql7 = @Sql
                END
              ELSE IF @SQLStringNumber = 8
                BEGIN
                    SET @Sql8 = @Sql
                END
                ELSE
                BEGIN
                  PRINT 'ERROR: Exceeded maximum length of SQL String'
                  RETURN
                END
                  
                   SET @Sql = @SqlSelect
                   SET @SQLStringNumber = @SQLStringNumber + 1
            END 
            ELSE
            BEGIN
         SET @Sql = @Sql + @SqlSelect
            END
   
      FETCH NEXT FROM cursor1 into @zSource, @SourceSystem, @ValueField02, @DescriptionTable02, @DescriptionField02, @DescriptionTableKeyField02, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @ValueField01, @DescriptionTableKeyField01
   
      -- If the loop continues, add the UNION ALL statement.
      IF @@FETCH_STATUS = 0
      BEGIN
            SET @SqlSelect = ' UNION ALL ' + CHAR(13)
                IF ( (LEN(@Sql) + LEN(@SqlSelect)) > 4000 )
                BEGIN
                  IF @SQLStringNumber = 1
                    BEGIN
                        SET @Sql1 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 2
                    BEGIN
                        SET @Sql2 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 3
                    BEGIN
                        SET @Sql3 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 4
                    BEGIN
                        SET @Sql4 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 5
                    BEGIN
                        SET @Sql5 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 6
                    BEGIN
                        SET @Sql6 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 7
                    BEGIN
                        SET @Sql7 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 8
                    BEGIN
                        SET @Sql8 = @Sql
                    END
                    ELSE
                    BEGIN
                      PRINT 'ERROR: Exceeded maximum length of SQL String'
                      RETURN
                    END
                   
                   SET @Sql = @SqlSelect
                   SET @SQLStringNumber = @SQLStringNumber + 1
                END 
                ELSE
                BEGIN
             SET @Sql = @Sql + @SqlSelect
                END
            END
   END
   
   CLOSE cursor1
   
   DEALLOCATE cursor1
   
   PRINT @Sql1
   PRINT @Sql2
   PRINT @Sql3
   PRINT @Sql4
   PRINT @Sql5
   PRINT @Sql6
   PRINT @Sql7
   PRINT @Sql8
   PRINT @Sql
   EXEC (@Sql1 + @Sql2 + @Sql3 + @Sql4 + @Sql5 + @Sql6 + @Sql7 + @Sql8 + @Sql)
   
  
END
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateLegacyValue03DescriptionIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateLegacyValue03DescriptionIns] @CheckTableName nvarchar(50)
AS
BEGIN
   
   -- Declare variables 
   DECLARE @Sql NVARCHAR(4000)
   DECLARE @SqlSelect NVARCHAR(4000)
   DECLARE @Sql1 NVARCHAR(4000) = ''
   DECLARE @Sql2 NVARCHAR(4000) = ''
   DECLARE @Sql3 NVARCHAR(4000) = ''
   DECLARE @Sql4 NVARCHAR(4000) = ''
   DECLARE @Sql5 NVARCHAR(4000) = ''
   DECLARE @Sql6 NVARCHAR(4000) = ''
   DECLARE @Sql7 NVARCHAR(4000) = ''
   DECLARE @Sql8 NVARCHAR(4000) = ''
      DECLARE @SQLStringNumber INT = 1
   DECLARE @DataSourceName NVARCHAR(50)
   DECLARE @CacheDatabaseName NVARCHAR(128)
   DECLARE @ReportName NVARCHAR(130)
   DECLARE @ReportType NVARCHAR(50)
   DECLARE @Comment NVARCHAR(900)
   DECLARE @Implication NVARCHAR(2000)
   DECLARE @ViewName NVARCHAR(255)
   DECLARE @SummaryViewName NVARCHAR(255)
   DECLARE @PrimaryKeyFields NVARCHAR(900)

   DECLARE @SQLQuery nvarchar(MAX)
   DECLARE @zSource nvarchar(50)
   DECLARE @SourceSystem nvarchar(50)
   DECLARE @ValueField03 nvarchar(50)
   DECLARE @DescriptionTable03 nvarchar(50)
   DECLARE @DescriptionField03 nvarchar(50)
   DECLARE @DescriptionTableKeyField03 nvarchar(50)
   DECLARE @DescriptionLanguageField nvarchar(50)
   DECLARE @DescriptionLanguageFieldValue nvarchar(50)
   
   
   -- =============================================
   -- Add target view name as variable incase of rename in future  
   SET @ViewName = 'web'+@CheckTableName+'LegacyValue03DescriptionList'
   

   -- =============================================

   
   --IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(@ViewName))
   --IF EXISTS (SELECT * FROM 'sdb'+@zSource+.sys.tables WHERE name = ''''+@CheckTableName+'''')
   print @ViewName

   -- Drop target UNION view if exists 
   SET @Sql = 'IF EXISTS (SELECT *
                 FROM   sys.VIEWS
                 WHERE  [name] = ''' + @ViewName +''') 
        DROP VIEW [dbo].' + @ViewName +''

      PRINT @Sql

      EXEC (@sql)

      -- BEGIN creating target UNION view 
      SET @Sql = 'CREATE VIEW ' + @ViewName + ' AS '
                 + Char(13)
   
   DECLARE cursor1 CURSOR LOCAL FAST_FORWARD
   FOR
   SELECT zSource, SourceSystem, ValueField03, ISNULL(DescriptionTable03, ''), ISNULL(DescriptionField03, ''), ISNULL(DescriptionTableKeyField03, '')
   ,ISNULL(DescriptionLanguageField, ''), ISNULL(DescriptionLanguageFieldValue, '')
   FROM ztGlobalXrefSourceSystem CROSS JOIN ztGlobalXref WHERE CheckTableName = ''+@CheckTableName+''
   AND ztGlobalXrefSourceSystem.zActive = 1 /*CP 20241511*/
   
   OPEN cursor1
   
   FETCH NEXT FROM cursor1 into @zSource, @SourceSystem, @ValueField03, @DescriptionTable03, @DescriptionField03, @DescriptionTableKeyField03, @DescriptionLanguageField, @DescriptionLanguageFieldValue
   
   WHILE @@FETCH_STATUS = 0
   BEGIN

   IF @DescriptionTable03 = ''
      -- Add the select code
            SET @SqlSelect = 'SELECT DISTINCT '''+@zSource+''' AS zSource, '+@ValueField03+' AS LegacyValue03, NULL AS LegacyValue03Description
			, '+@ValueField03+' AS FriendlyName FROM '+@SourceSystem+'.dbo.'+@CheckTableName+'' + CHAR(13)
   IF @DescriptionTable03 <> '' AND (@DescriptionLanguageField = '' OR @DescriptionLanguageFieldValue = '')
            SET @SqlSelect = 'SELECT DISTINCT '''+@zSource+''' AS zSource, Checktable.'+@ValueField03+' AS LegacyValue03, DescriptionTable03.'+@DescriptionField03+' AS LegacyValue03Description
			,CONCAT(Checktable.'+@ValueField03+', '' - '', DescriptionTable03.'+@DescriptionField03+') AS FriendlyName FROM '+@SourceSystem+'.dbo.'+@CheckTableName+' AS Checktable
			INNER JOIN '+@SourceSystem+'.dbo.'+@DescriptionTable03+' as DescriptionTable03 ON
			Checktable.'+@ValueField03+' = DescriptionTable03.'+@DescriptionTableKeyField03+'' + CHAR(13)
   IF @DescriptionTable03 <> '' AND (@DescriptionLanguageField <> '' AND @DescriptionLanguageFieldValue <> '')
			SET @SqlSelect = 'SELECT DISTINCT '''+@zSource+''' AS zSource, Checktable.'+@ValueField03+' AS LegacyValue03, DescriptionTable03.'+@DescriptionField03+' AS LegacyValue03Description
			,CONCAT(Checktable.'+@ValueField03+', '' - '', DescriptionTable03.'+@DescriptionField03+') AS FriendlyName FROM '+@SourceSystem+'.dbo.'+@CheckTableName+' AS Checktable
			INNER JOIN '+@SourceSystem+'.dbo.'+@DescriptionTable03+' as DescriptionTable03 ON
			Checktable.'+@ValueField03+' = DescriptionTable03.'+@DescriptionTableKeyField03+''
			+' WHERE '+ 'DescriptionTable03.'+ @DescriptionLanguageField+' = '''+@DescriptionLanguageFieldValue+''''+'' + CHAR(13)

            IF ( (LEN(@Sql) + LEN(@SqlSelect)) > 4000 )
            BEGIN
              IF @SQLStringNumber = 1
                BEGIN
                    SET @Sql1 = @Sql
                END
              ELSE IF @SQLStringNumber = 2
                BEGIN
                    SET @Sql2 = @Sql
                END
              ELSE IF @SQLStringNumber = 3
                BEGIN
                    SET @Sql3 = @Sql
                END
              ELSE IF @SQLStringNumber = 4
                BEGIN
                    SET @Sql4 = @Sql
                END
              ELSE IF @SQLStringNumber = 5
                BEGIN
                    SET @Sql5 = @Sql
                END
              ELSE IF @SQLStringNumber = 6
                BEGIN
                    SET @Sql6 = @Sql
                END
              ELSE IF @SQLStringNumber = 7
                BEGIN
                    SET @Sql7 = @Sql
                END
              ELSE IF @SQLStringNumber = 8
                BEGIN
                    SET @Sql8 = @Sql
                END
                ELSE
                BEGIN
                  PRINT 'ERROR: Exceeded maximum length of SQL String'
                  RETURN
                END
                  
                   SET @Sql = @SqlSelect
                   SET @SQLStringNumber = @SQLStringNumber + 1
            END 
            ELSE
            BEGIN
         SET @Sql = @Sql + @SqlSelect
            END
   
      FETCH NEXT FROM cursor1 into @zSource, @SourceSystem, @ValueField03, @DescriptionTable03, @DescriptionField03, @DescriptionTableKeyField03, @DescriptionLanguageField, @DescriptionLanguageFieldValue
   
      -- If the loop continues, add the UNION ALL statement.
      IF @@FETCH_STATUS = 0
      BEGIN
            SET @SqlSelect = ' UNION ALL ' + CHAR(13)
                IF ( (LEN(@Sql) + LEN(@SqlSelect)) > 4000 )
                BEGIN
                  IF @SQLStringNumber = 1
                    BEGIN
                        SET @Sql1 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 2
                    BEGIN
                        SET @Sql2 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 3
                    BEGIN
                        SET @Sql3 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 4
                    BEGIN
                        SET @Sql4 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 5
                    BEGIN
                        SET @Sql5 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 6
                    BEGIN
                        SET @Sql6 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 7
                    BEGIN
                        SET @Sql7 = @Sql
                    END
                  ELSE IF @SQLStringNumber = 8
                    BEGIN
                        SET @Sql8 = @Sql
                    END
                    ELSE
                    BEGIN
                      PRINT 'ERROR: Exceeded maximum length of SQL String'
                      RETURN
                    END
                   
                   SET @Sql = @SqlSelect
                   SET @SQLStringNumber = @SQLStringNumber + 1
                END 
                ELSE
                BEGIN
             SET @Sql = @Sql + @SqlSelect
                END
            END
   END
   
   CLOSE cursor1
   
   DEALLOCATE cursor1
   
   PRINT @Sql1
   PRINT @Sql2
   PRINT @Sql3
   PRINT @Sql4
   PRINT @Sql5
   PRINT @Sql6
   PRINT @Sql7
   PRINT @Sql8
   PRINT @Sql
   EXEC (@Sql1 + @Sql2 + @Sql3 + @Sql4 + @Sql5 + @Sql6 + @Sql7 + @Sql8 + @Sql)
   
  
END
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateTargetValue01DescriptionIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateTargetValue01DescriptionIns] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @zSource nvarchar(50)
DECLARE @TargetSystem nvarchar(50)
DECLARE @TargetSystemID nvarchar(50)
DECLARE @ValueField01 nvarchar(50)
DECLARE @DescriptionTable01 nvarchar(50)
DECLARE @DescriptionField01 nvarchar(50)
DECLARE @DescriptionTableKeyField01 nvarchar(50)
DECLARE @DescriptionLanguageField nvarchar(50)
DECLARE @DescriptionLanguageFieldValue nvarchar(50)
DECLARE @Sql NVARCHAR(4000)

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue01DescriptionList'
   SET @Sql = 'IF EXISTS (SELECT *
                 FROM   sys.VIEWS
                 WHERE  [name] = ''' + @ViewName +''') 
        DROP VIEW [dbo].' + @ViewName +''

      PRINT @Sql

      EXEC (@sql)

DECLARE cur CURSOR LOCAL for

SELECT zSource, TargetSystem, TargetSystemID, ValueField01, ISNULL(DescriptionTable01, ''), ISNULL(DescriptionField01, ''), ISNULL(DescriptionTableKeyField01, '')
,ISNULL(DescriptionLanguageField, ''), ISNULL(DescriptionLanguageFieldValue, '') FROM ztGlobalXrefTargetSystem CROSS JOIN ztGlobalXref WHERE CheckTableName = ''+@CheckTableName+''
OPEN cur;
FETCH NEXT FROM cur into @zSource, @TargetSystem, @TargetSystemID, @ValueField01, @DescriptionTable01, @DescriptionField01, @DescriptionTableKeyField01, @DescriptionLanguageField, @DescriptionLanguageFieldValue

WHILE @@FETCH_STATUS = 0
BEGIN
IF @DescriptionTable01 = ''
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue01DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue01DescriptionList
AS
SELECT DISTINCT 
'+@ValueField01+' AS TargetValue01
,NULL AS TargetValue01Description
,'+@ValueField01+' AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+'
WHERE '+@CheckTableName+'.TargetSystemID = '''''+@TargetSystemID+'''''
''
END'
IF @DescriptionTable01 <> '' AND (@DescriptionLanguageField = '' OR @DescriptionLanguageFieldValue = '')
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue01DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue01DescriptionList
AS
SELECT DISTINCT 
Checktable.'+@ValueField01+' AS TargetValue01
,DescriptionTable01.'+@DescriptionField01+' AS TargetValue01Description
,CONCAT(Checktable.'+@ValueField01+', '''' - '''', DescriptionTable01.'+@DescriptionField01+') AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+' AS Checktable
INNER JOIN '+@TargetSystem+'.dbo.'+@DescriptionTable01+' as DescriptionTable01 ON
Checktable.'+@ValueField01+' = DescriptionTable01.'+@DescriptionTableKeyField01+'
AND Checktable.TargetSystemID = DescriptionTable01.TargetSystemID
WHERE Checktable.TargetSystemID = '''''+@TargetSystemID+'''''
''
END'
IF @DescriptionTable01 <> '' AND (@DescriptionLanguageField <> '' OR @DescriptionLanguageFieldValue <> '')
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue01DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue01DescriptionList
AS
SELECT DISTINCT 
Checktable.'+@ValueField01+' AS TargetValue01
,DescriptionTable01.'+@DescriptionField01+' AS TargetValue01Description
,CONCAT(Checktable.'+@ValueField01+', '''' - '''', DescriptionTable01.'+@DescriptionField01+') AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+' AS Checktable
INNER JOIN '+@TargetSystem+'.dbo.'+@DescriptionTable01+' as DescriptionTable01 ON
Checktable.'+@ValueField01+' = DescriptionTable01.'+@DescriptionTableKeyField01+'
AND Checktable.TargetSystemID = DescriptionTable01.TargetSystemID
 WHERE Checktable.TargetSystemID = '''''+@TargetSystemID+''''' AND DescriptionTable01.'+ @DescriptionLanguageField+' = '''''+@DescriptionLanguageFieldValue+''''''+' 
''
END'

PRINT @SQLQuery
EXEC (@SQLQuery)

FETCH NEXT FROM cur into @zSource, @TargetSystem, @TargetSystemID, @ValueField01, @DescriptionTable01, @DescriptionField01, @DescriptionTableKeyField01, @DescriptionLanguageField, @DescriptionLanguageFieldValue
END;
CLOSE cur;
DEALLOCATE cur;

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateTargetValue02DescriptionIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateTargetValue02DescriptionIns] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @zSource nvarchar(50)
DECLARE @TargetSystem nvarchar(50)
DECLARE @TargetSystemID nvarchar(50)
DECLARE @ValueField02 nvarchar(50)
DECLARE @DescriptionTable02 nvarchar(50)
DECLARE @DescriptionField02 nvarchar(50)
DECLARE @DescriptionTableKeyField02 nvarchar(50)
DECLARE @DescriptionLanguageField nvarchar(50)
DECLARE @DescriptionLanguageFieldValue nvarchar(50)
DECLARE @ValueField01 nvarchar(50)
DECLARE @DescriptionTableKeyField01 nvarchar(50)
DECLARE @Sql NVARCHAR(4000)

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue02DescriptionList'
   SET @Sql = 'IF EXISTS (SELECT *
                 FROM   sys.VIEWS
                 WHERE  [name] = ''' + @ViewName +''') 
        DROP VIEW [dbo].' + @ViewName +''

      PRINT @Sql

      EXEC (@sql)

DECLARE cur CURSOR LOCAL for

SELECT zSource, TargetSystem, TargetSystemID, ValueField02, ISNULL(DescriptionTable02, ''), ISNULL(DescriptionField02, ''), ISNULL(DescriptionTableKeyField02, '')
,ISNULL(DescriptionLanguageField, ''), ISNULL(DescriptionLanguageFieldValue, ''), ISNULL(ValueField01, ''), ISNULL(DescriptionTableKeyField01, '') 
FROM ztGlobalXrefTargetSystem CROSS JOIN ztGlobalXref WHERE CheckTableName = ''+@CheckTableName+''
OPEN cur;
FETCH NEXT FROM cur into @zSource, @TargetSystem, @TargetSystemID, @ValueField02, @DescriptionTable02, @DescriptionField02, @DescriptionTableKeyField02, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @ValueField01, @DescriptionTableKeyField01

WHILE @@FETCH_STATUS = 0
BEGIN
IF @DescriptionTable02 = ''
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue02DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue02DescriptionList
AS
SELECT DISTINCT 
'+@ValueField01+' AS TargetValue01
,'+@ValueField02+' AS TargetValue02
,NULL AS TargetValue02Description
,'+@ValueField02+' AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+'
WHERE '+@CheckTableName+'.TargetSystemID = '''''+@TargetSystemID+'''''
''
END'
IF @DescriptionTable02 <> '' AND (@DescriptionLanguageField = '' OR @DescriptionLanguageFieldValue = '')
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue02DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue02DescriptionList
AS
SELECT DISTINCT 
Checktable.'+@ValueField01+' AS TargetValue01
,Checktable.'+@ValueField02+' AS TargetValue02
,DescriptionTable02.'+@DescriptionField02+' AS TargetValue02Description
,CONCAT(Checktable.'+@ValueField02+', '''' - '''', DescriptionTable02.'+@DescriptionField02+') AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+' AS Checktable
INNER JOIN '+@TargetSystem+'.dbo.'+@DescriptionTable02+' as DescriptionTable02 ON
Checktable.'+@ValueField01+' = DescriptionTable02.'+@DescriptionTableKeyField01+' AND 
Checktable.'+@ValueField02+' = DescriptionTable02.'+@DescriptionTableKeyField02+'
AND Checktable.TargetSystemID = DescriptionTable02.TargetSystemID
WHERE Checktable.TargetSystemID = '''''+@TargetSystemID+'''''
''
END'
IF @DescriptionTable02 <> '' AND (@DescriptionLanguageField <> '' OR @DescriptionLanguageFieldValue <> '')
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue02DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue02DescriptionList
AS
SELECT DISTINCT 
Checktable.'+@ValueField01+' AS TargetValue01
,Checktable.'+@ValueField02+' AS TargetValue02
,DescriptionTable02.'+@DescriptionField02+' AS TargetValue02Description
,CONCAT(Checktable.'+@ValueField02+', '''' - '''', DescriptionTable02.'+@DescriptionField02+') AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+' AS Checktable
INNER JOIN '+@TargetSystem+'.dbo.'+@DescriptionTable02+' as DescriptionTable02 ON
Checktable.'+@ValueField01+' = DescriptionTable02.'+@DescriptionTableKeyField01+' AND 
Checktable.'+@ValueField02+' = DescriptionTable02.'+@DescriptionTableKeyField02+'
AND Checktable.TargetSystemID = DescriptionTable02.TargetSystemID
WHERE Checktable.TargetSystemID = '''''+@TargetSystemID+''''' AND DescriptionTable02.'+ @DescriptionLanguageField+' = '''''+@DescriptionLanguageFieldValue+''''''+' 
''
END'

PRINT @SQLQuery
EXEC (@SQLQuery)

FETCH NEXT FROM cur into @zSource, @TargetSystem, @TargetSystemID, @ValueField02, @DescriptionTable02, @DescriptionField02, @DescriptionTableKeyField02, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @ValueField01, @DescriptionTableKeyField01
END;
CLOSE cur;
DEALLOCATE cur;

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateTargetValue03DescriptionIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateTargetValue03DescriptionIns] @CheckTableName nvarchar(50)
AS

DECLARE @SQLQuery nvarchar(MAX)
DECLARE @zSource nvarchar(50)
DECLARE @TargetSystem nvarchar(50)
DECLARE @TargetSystemID nvarchar(50)
DECLARE @ValueField03 nvarchar(50)
DECLARE @DescriptionTable03 nvarchar(50)
DECLARE @DescriptionField03 nvarchar(50)
DECLARE @DescriptionTableKeyField03 nvarchar(50)
DECLARE @DescriptionLanguageField nvarchar(50)
DECLARE @DescriptionLanguageFieldValue nvarchar(50)
DECLARE @ValueField01 nvarchar(50)
DECLARE @DescriptionTableKeyField01 nvarchar(50)
DECLARE @ValueField02 nvarchar(50)
DECLARE @DescriptionTableKeyField02 nvarchar(50)
DECLARE @Sql NVARCHAR(4000)

 DECLARE @ViewName NVARCHAR(255)
 SET @ViewName = 'web'+@CheckTableName+'TargetValue03DescriptionList'
   SET @Sql = 'IF EXISTS (SELECT *
                 FROM   sys.VIEWS
                 WHERE  [name] = ''' + @ViewName +''') 
        DROP VIEW [dbo].' + @ViewName +''

      PRINT @Sql

      EXEC (@sql)

DECLARE cur CURSOR LOCAL for

SELECT zSource, TargetSystem, TargetSystemID, ValueField03, ISNULL(DescriptionTable03, ''), ISNULL(DescriptionField03, ''), ISNULL(DescriptionTableKeyField03, '')
,ISNULL(DescriptionLanguageField, ''), ISNULL(DescriptionLanguageFieldValue, ''), ISNULL(ValueField01, ''), ISNULL(DescriptionTableKeyField01, '') , ISNULL(ValueField02, ''), ISNULL(DescriptionTableKeyField02, '') 
FROM ztGlobalXrefTargetSystem CROSS JOIN ztGlobalXref WHERE CheckTableName = ''+@CheckTableName+''
OPEN cur;
FETCH NEXT FROM cur into @zSource, @TargetSystem, @TargetSystemID, @ValueField03, @DescriptionTable03, @DescriptionField03, @DescriptionTableKeyField03, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @ValueField01, @DescriptionTableKeyField01, @ValueField02, @DescriptionTableKeyField02

WHILE @@FETCH_STATUS = 0
BEGIN
IF @DescriptionTable03 = ''
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue03DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue03DescriptionList
AS
SELECT DISTINCT 
'+@ValueField01+' AS TargetValue01
,'+@ValueField02+' AS TargetValue02
,'+@ValueField03+' AS TargetValue03
,NULL AS TargetValue03Description
,'+@ValueField03+' AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+'
WHERE '+@CheckTableName+'.TargetSystemID = '''''+@TargetSystemID+'''''
''
END'
IF @DescriptionTable03 <> '' AND (@DescriptionLanguageField = '' OR @DescriptionLanguageFieldValue = '')
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue03DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue03DescriptionList
AS
SELECT DISTINCT 
Checktable.'+@ValueField01+' AS TargetValue01
,Checktable.'+@ValueField02+' AS TargetValue02
,Checktable.'+@ValueField03+' AS TargetValue03
,DescriptionTable03.'+@DescriptionField03+' AS TargetValue03Description
,CONCAT(Checktable.'+@ValueField03+', '''' - '''', DescriptionTable03.'+@DescriptionField03+') AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+' AS Checktable
INNER JOIN '+@TargetSystem+'.dbo.'+@DescriptionTable03+' as DescriptionTable03 ON
Checktable.'+@ValueField01+' = DescriptionTable02.'+@DescriptionTableKeyField01+' AND 
Checktable.'+@ValueField02+' = DescriptionTable02.'+@DescriptionTableKeyField02+' AND
Checktable.'+@ValueField03+' = DescriptionTable03.'+@DescriptionTableKeyField03+'
AND Checktable.TargetSystemID = DescriptionTable02.TargetSystemID
WHERE Checktable.TargetSystemID = '''''+@TargetSystemID+'''''
''
END'
IF @DescriptionTable03 <> '' AND (@DescriptionLanguageField <> '' OR @DescriptionLanguageFieldValue <> '')
SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].web'+@CheckTableName+'TargetValue03DescriptionList''))
IF EXISTS (SELECT * FROM '+@TargetSystem+'.sys.objects WHERE type IN (''U'', ''V'') AND name = '''+@CheckTableName+''')
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.web'+@CheckTableName+'TargetValue03DescriptionList
AS
SELECT DISTINCT 
Checktable.'+@ValueField01+' AS TargetValue01
,Checktable.'+@ValueField02+' AS TargetValue02
,Checktable.'+@ValueField03+' AS TargetValue03
,DescriptionTable03.'+@DescriptionField03+' AS TargetValue03Description
,CONCAT(Checktable.'+@ValueField03+', '''' - '''', DescriptionTable03.'+@DescriptionField03+') AS FriendlyName
FROM '+@TargetSystem+'.dbo.'+@CheckTableName+' AS Checktable
INNER JOIN '+@TargetSystem+'.dbo.'+@DescriptionTable03+' as DescriptionTable03 ON
Checktable.'+@ValueField01+' = DescriptionTable03.'+@DescriptionTableKeyField01+' AND 
Checktable.'+@ValueField02+' = DescriptionTable03.'+@DescriptionTableKeyField02+' AND
Checktable.'+@ValueField03+' = DescriptionTable03.'+@DescriptionTableKeyField03+'
AND Checktable.TargetSystemID = DescriptionTable02.TargetSystemID
WHERE Checktable.TargetSystemID = '''''+@TargetSystemID+''''' AND DescriptionTable03.'+ @DescriptionLanguageField+' = '''''+@DescriptionLanguageFieldValue+''''''+' 
''
END'

--PRINT @SQLQuery
EXEC (@SQLQuery)

FETCH NEXT FROM cur into @zSource, @TargetSystem, @TargetSystemID, @ValueField03, @DescriptionTable03, @DescriptionField03, @DescriptionTableKeyField03, @DescriptionLanguageField, @DescriptionLanguageFieldValue, @ValueField01, @DescriptionTableKeyField01, @ValueField02, @DescriptionTableKeyField02
END;
CLOSE cur;
DEALLOCATE cur;

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateViewDel]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateViewDel] @CheckTableName nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @zSource nvarchar(50)
    DECLARE cur CURSOR LOCAL for
      SELECT zSource
      FROM   ztGlobalXrefSourceSystem

    OPEN cur;

    FETCH NEXT FROM cur into @zSource

    WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @SQLQuery = '

IF OBJECT_ID(''web' + @CheckTableName + '_'
                          + @zSource
                          + 'Sel'', ''v'') IS NOT NULL DROP VIEW [web'
                          + @CheckTableName + '_' + @zSource + 'Sel]

'

          --PRINT @SQLQuery
          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @zSource
      END;

    CLOSE cur;

    DEALLOCATE cur; 

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueCreateViewIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueCreateViewIns] @CheckTableName nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @zSource nvarchar(50)
    DECLARE cur CURSOR LOCAL for
      SELECT zSource
      FROM   ztGlobalXrefSourceSystem
	  WHERE zActive = 1 /*CP 20241511*/

    OPEN cur;

    FETCH NEXT FROM cur into @zSource

    WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @SQLQuery = '

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[web'
                          + @CheckTableName + '_' + @zSource
                          + 'Sel]''))
BEGIN
EXEC dbo.sp_executesql @statement = N''
CREATE VIEW dbo.[web' + @CheckTableName + '_'
                          + @zSource + 'Sel]
AS
SELECT 
zSource
,LegacyValue01
,TargetValue01
,LegacyValue02
,TargetValue02
,LegacyValue03
,TargetValue03
FROM [' + @CheckTableName
                          + '] WHERE zSource = ''''' + @zSource + ''''' ''
END'

          --PRINT @SQLQuery
          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @zSource
      END;

    CLOSE cur;

    DEALLOCATE cur; 

GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValueIns]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValueIns] @CheckTableName nvarchar(50),
                                                           @boaUserID      nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @PageID nvarchar(50)
    DECLARE @ValueField01 nvarchar(50)
    DECLARE @ValueField02 nvarchar(50)
    DECLARE @ValueField03 nvarchar(50)
    DECLARE @JoinValueField01 nvarchar(50)
    DECLARE @JoinValueField02 nvarchar(50)
    DECLARE @JoinValueField03 nvarchar(50)
    DECLARE @DataBaseName nvarchar(50)
    DECLARE @zSource nvarchar(50)
    DECLARE @SourceSystemID nvarchar(50)
	DECLARE @CaseSensitive		   nvarchar(1)

    SET @PageID = (SELECT PageID
                   FROM   ztGlobalXref
                   where  CheckTableName = @CheckTableName)
    SET @ValueField01 = (SELECT ISNULL(ValueField01, '''''')
                         FROM   ztGlobalXref
                         WHERE  CheckTableName = @CheckTableName)
    SET @ValueField02 = (SELECT ISNULL(ValueField02, '''''')
                         FROM   ztGlobalXref
                         WHERE  CheckTableName = @CheckTableName)
    SET @ValueField03 = (SELECT ISNULL(ValueField03, '''''')
                         FROM   ztGlobalXref
                         WHERE  CheckTableName = @CheckTableName)
    SET @JoinValueField01 = (SELECT CASE
                                      WHEN ValueField01 IS NULL THEN ''''''
                                      ELSE 'CheckTable.' + ValueField01
                                    END
                             FROM   ztGlobalXref
                             WHERE  CheckTableName = @CheckTableName)
    SET @JoinValueField02 = (SELECT CASE
                                      WHEN ValueField02 IS NULL THEN ''''''
                                      ELSE 'CheckTable.' + ValueField02
                                    END
                             FROM   ztGlobalXref
                             WHERE  CheckTableName = @CheckTableName)
    SET @JoinValueField03 = (SELECT CASE
                                      WHEN ValueField03 IS NULL THEN ''''''
                                      ELSE 'CheckTable.' + ValueField03
                                    END
                             FROM   ztGlobalXref
                             WHERE  CheckTableName = @CheckTableName)
	SET @CaseSensitive		= (SELECT ISNULL(CaseSensitive, 0) FROM ztGlobalXref  WHERE  CheckTableName = @CheckTableName)

	IF @CaseSensitive = 0
	BEGIN

    DECLARE cur CURSOR LOCAL for
      --SET @DataBaseName = (SELECT SourceSystem FROM ztGlobalXrefSourceSystem)
      --SET @zSource = (SELECT zSource FROM ztGlobalXrefSourceSystem)
      SELECT SourceSystem,
             zSource,
             SourceSystemID
      FROM   ztGlobalXrefSourceSystem
	  WHERE zActive = 1 /*CP 20241511*/

    OPEN cur;

    FETCH NEXT FROM cur into @DataBaseName, @zSource, @SourceSystemID

    WHILE @@FETCH_STATUS = 0
      BEGIN
          --print @PageID
          SET @SQLQuery = '

BEGIN

DELETE FROM [' + @CheckTableName + ']
WHERE zSource = ''' + @zSource + ''' AND LegacyValue01 IS NULL


INSERT INTO [' + @CheckTableName + '] (zSource,SourceSystemID,LegacyValue01,TargetValue01,LegacyValue02,TargetValue02,LegacyValue03,TargetValue03,zRelevant, AddedBy, AddedOn, AddedVia) 
SELECT ''' + @zSource + ''', ''' + @SourceSystemID + ''', '
                          + @ValueField01 + ', NULL, ' + @ValueField02
                          + ', NULL, ' + @ValueField03 + ', NULL, 0, '''
                          + @boaUserID
                          + ''', getdate(), ''UserInterface'' FROM '
                          + @DataBaseName + '.dbo.[' + @CheckTableName
                          + '] CheckTable
WHERE CheckTable.SourceSystemID = ''' + @SourceSystemID + ''' 
AND NOT EXISTS (SELECT zSource,SourceSystemID,LegacyValue01,LegacyValue02,LegacyValue03 FROM ['
                          + @CheckTableName + '] CT WHERE CT.zSource = ''' + @zSource + ''' 
AND CT.LegacyValue01 = ' + @JoinValueField01 + '
AND CT.LegacyValue02 = ' + @JoinValueField02 + ' 
AND CT.LegacyValue03 = ' + @JoinValueField03 + ')


END'

          PRINT @SQLQuery
          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @DataBaseName, @zSource, @SourceSystemID
      END;

    CLOSE cur;

    DEALLOCATE cur; 

	END




	IF @CaseSensitive = 1
	BEGIN

    DECLARE cur CURSOR LOCAL for
      --SET @DataBaseName = (SELECT SourceSystem FROM ztGlobalXrefSourceSystem)
      --SET @zSource = (SELECT zSource FROM ztGlobalXrefSourceSystem)
      SELECT SourceSystem,
             zSource,
             SourceSystemID
      FROM   ztGlobalXrefSourceSystem
	  WHERE zActive = 1 /*CP 20241511*/

    OPEN cur;

    FETCH NEXT FROM cur into @DataBaseName, @zSource, @SourceSystemID

    WHILE @@FETCH_STATUS = 0
      BEGIN
          --print @PageID
          SET @SQLQuery = '

BEGIN

DELETE FROM [' + @CheckTableName + ']
WHERE zSource = ''' + @zSource + ''' AND LegacyValue01 IS NULL


INSERT INTO [' + @CheckTableName + '] (zSource,SourceSystemID,LegacyValue01,TargetValue01,LegacyValue02,TargetValue02,LegacyValue03,TargetValue03,zRelevant, AddedBy, AddedOn, AddedVia) 
SELECT ''' + @zSource + ''', ''' + @SourceSystemID + ''', ' + @ValueField01 + ' COLLATE SQL_Latin1_General_CP1_CS_AS, NULL, ' + @ValueField02 + ', NULL, ' + @ValueField03 + ', NULL, 0, ''' + @boaUserID  + ''', getdate(), ''UserInterface'' FROM '
                          + @DataBaseName + '.dbo.[' + @CheckTableName + '] CheckTable
WHERE CheckTable.SourceSystemID = ''' + @SourceSystemID + ''' 
AND NOT EXISTS (SELECT zSource,SourceSystemID,LegacyValue01,LegacyValue02,LegacyValue03 FROM [' + @CheckTableName + '] CT WHERE CT.zSource = ''' + @zSource + ''' 
AND CT.LegacyValue01 COLLATE SQL_Latin1_General_CP1_CS_AS = ' + @JoinValueField01 + ' COLLATE SQL_Latin1_General_CP1_CS_AS
AND CT.LegacyValue02 = ' + @JoinValueField02 + ' 
AND CT.LegacyValue03 = ' + @JoinValueField03 + ')


END'

          PRINT @SQLQuery
          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @DataBaseName, @zSource, @SourceSystemID
      END;

    CLOSE cur;

    DEALLOCATE cur; 

	END


GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefInsertSourceValuesAudit]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  CREATE PROCEDURE [dbo].[webGlobalXrefInsertSourceValuesAudit] @CheckTableName nvarchar(50)
  AS
 UPDATE ztGlobalXref
 SET InsertSourceValuesOn = getdate()
 FROM WRKDQHARMONIZE.dbo.ztGlobalXref
 WHERE CheckTableName = @CheckTableName
GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefMappedValuesUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[webGlobalXrefMappedValuesUpd]
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @PageID nvarchar(50)
    DECLARE @ValueField01 nvarchar(50)
    DECLARE @ValueField02 nvarchar(50)
    DECLARE @ValueField03 nvarchar(50)
    DECLARE @JoinValueField01 nvarchar(50)
    DECLARE @JoinValueField02 nvarchar(50)
    DECLARE @JoinValueField03 nvarchar(50)
    DECLARE @DataBaseName nvarchar(50)
    DECLARE @zSource nvarchar(50)
    DECLARE @SourceSystemID nvarchar(50)
    DECLARE @TotalRecords nvarchar(50)
    DECLARE @MappedValues01 nvarchar(50)
    DECLARE @MappedValues02 nvarchar(50)
    DECLARE @MappedValues03 nvarchar(50)
    DECLARE @CheckTableName nvarchar(50)
    DECLARE @CheckTableNameQuoted nvarchar(50)
    DECLARE cur CURSOR LOCAL for
      SELECT CheckTableName,
             ValueField01,
             ValueField02,
             ValueField03
      FROM   ztGlobalXref
      WHERE  Active = 1

    OPEN cur;

    FETCH NEXT FROM cur into @CheckTableName, @ValueField01, @ValueField02, @ValueField03

    WHILE @@FETCH_STATUS = 0
      BEGIN
          print @PageID
          SET @CheckTableNameQuoted = Quotename(@CheckTableName)
		  
          IF EXISTS (SELECT *
                     FROM   sys.TABLES
                     WHERE  object_id = Object_id(@CheckTableNameQuoted))
            SET @SQLQuery = '

DECLARE @TotalRecords nvarchar(50)
DECLARE @MappedValues01 nvarchar(50)

SET @TotalRecords = (SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ')
SET @MappedValues01 = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue01 IS NOT NULL)) IS NULL THEN ''Not Mapped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue01 IS NOT NULL)) END

BEGIN

UPDATE ztGlobalXref
SET MappedValues = 
CASE WHEN @MappedValues01 = ''Not Mapped'' THEN ''Not Mapped'' ELSE @MappedValues01 END 
+ '' / '' 
+ @TotalRecords 
WHERE ChecktableName = '''
                            + @CheckTableName + '''

END'

          PRINT @SQLQuery

          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @CheckTableName, @ValueField01, @ValueField02, @ValueField03
      END;

    CLOSE cur;

    DEALLOCATE cur;

    DECLARE cur CURSOR LOCAL for
      SELECT CheckTableName,
             ValueField01,
             ValueField02,
             ValueField03
      FROM   ztGlobalXref
      WHERE  Active = 1
             AND ValueField02 IS NOT NULL

    OPEN cur;

    FETCH NEXT FROM cur into @CheckTableName, @ValueField01, @ValueField02, @ValueField03

    WHILE @@FETCH_STATUS = 0
      BEGIN
          --print @PageID
          SET @CheckTableNameQuoted = Quotename(@CheckTableName)

          IF EXISTS (SELECT *
                     FROM   sys.TABLES
                     WHERE  object_id = Object_id(@CheckTableNameQuoted))
            SET @SQLQuery = '

DECLARE @TotalRecords nvarchar(50)
DECLARE @MappedValues01 nvarchar(50)
DECLARE @MappedValues02 nvarchar(50)

SET @TotalRecords = (SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ')
SET @MappedValues01 = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue01 IS NOT NULL)) IS NULL THEN ''Not Mapped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue01 IS NOT NULL)) END
SET @MappedValues02 = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue02 IS NOT NULL)) IS NULL THEN ''Not Mapped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue02 IS NOT NULL)) END

BEGIN

UPDATE ztGlobalXref
SET MappedValues = 
CASE WHEN @MappedValues01 = ''Not Mapped'' THEN ''Not Mapped'' ELSE @MappedValues01 END 
+ 
CASE WHEN @MappedValues02 = ''Not Mapped'' THEN '''' ELSE '' & '' + @MappedValues02 END 
+ '' / '' 
+ @TotalRecords 
WHERE ChecktableName = '''
                            + @CheckTableName + '''

END'

          PRINT @SQLQuery

          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @CheckTableName, @ValueField01, @ValueField02, @ValueField03
      END;

    CLOSE cur;

    DEALLOCATE cur;

    DECLARE cur CURSOR LOCAL for
      SELECT CheckTableName,
             ValueField01,
             ValueField02,
             ValueField03
      FROM   ztGlobalXref
      WHERE  Active = 1
             AND ValueField03 IS NOT NULL

    OPEN cur;

    FETCH NEXT FROM cur into @CheckTableName, @ValueField01, @ValueField02, @ValueField03

    WHILE @@FETCH_STATUS = 0
      BEGIN
          --print @PageID
          SET @CheckTableNameQuoted = Quotename(@CheckTableName)

          IF EXISTS (SELECT *
                     FROM   sys.TABLES
                     WHERE  object_id = Object_id(@CheckTableNameQuoted))
            SET @SQLQuery = '

DECLARE @TotalRecords nvarchar(50)
DECLARE @MappedValues01 nvarchar(50)
DECLARE @MappedValues02 nvarchar(50)
DECLARE @MappedValues03 nvarchar(50)

SET @TotalRecords = (SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ')
SET @MappedValues01 = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue01 IS NOT NULL)) IS NULL THEN ''Not Mapped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue01 IS NOT NULL)) END
SET @MappedValues02 = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue02 IS NOT NULL)) IS NULL THEN ''Not Mapped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue02 IS NOT NULL)) END
SET @MappedValues03 = CASE WHEN CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue03 IS NOT NULL)) IS NULL THEN ''Not Mapped'' ELSE CONVERT(NVARCHAR(50),(SELECT COUNT(*) FROM '
                            + @CheckTableNameQuoted--@CheckTableName
                            + ' WHERE TargetValue03 IS NOT NULL)) END

BEGIN

UPDATE ztGlobalXref
SET MappedValues = 
CASE WHEN @MappedValues01 = ''Not Mapped'' THEN ''Not Mapped'' ELSE @MappedValues01 END 
+ 
CASE WHEN @MappedValues02 = ''Not Mapped'' THEN '''' ELSE '' & '' + @MappedValues02 END 
+ 
CASE WHEN @MappedValues03 = ''Not Mapped'' THEN '''' ELSE '' & '' + @MappedValues03 END 
+ '' / '' 
+ @TotalRecords 
WHERE ChecktableName = '''
                            + @CheckTableName + '''

END'

          PRINT @SQLQuery

          EXEC (@SQLQuery)

          FETCH NEXT FROM cur into @CheckTableName, @ValueField01, @ValueField02, @ValueField03
      END;

    CLOSE cur;

    DEALLOCATE cur; 


GO
/****** Object:  StoredProcedure [dbo].[webGlobalXrefSetGroupsWhenBlankUpd]    Script Date: 4/23/2026 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[webGlobalXrefSetGroupsWhenBlankUpd] @CheckTableName nvarchar(50),
                                                      @boaUserID      nvarchar(50)
AS
    DECLARE @SQLQuery nvarchar(MAX)
    DECLARE @ViewName NVARCHAR(255)


SET @SQLQuery = 
/*update the Group field when LegacyValue is maintained*/
'
WITH CTE_AutoGroup  
AS  
(SELECT LegacyValue01, dense_rank() over(order by LegacyValue01) as [GroupNew] 
FROM ' + @CheckTableName + '
GROUP BY LegacyValue01)  
UPDATE ' + @CheckTableName + ' 
SET [Group] = [GroupNew]
, ChangedBy = ''' + @boaUserID + '''
, ChangedOn = getdate()
, ChangedVia = ''AutoMap''
FROM CTE_AutoGroup 
WHERE ' + @CheckTableName + '.LegacyValue01 = CTE_AutoGroup.LegacyValue01 
AND ISNULL([Group], '''') = ''''
AND zRelevant = 1
'
    PRINT @SQLQuery
    EXEC (@SQLQuery) 

GO
