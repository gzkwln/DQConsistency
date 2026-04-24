USE [WRKDQHARMONIZE]
GO
/****** Object:  View [dbo].[webDatasetTableList]    Script Date: 4/23/2026 1:17:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE view [dbo].[webDatasetTableList]      
as      
SELECT A.DatasetID,DatasetName,DatasetTableID,A.TableID,TableName 
FROM ztDatasetTables A 
INNER JOIN ztDatasetAvailableTables B ON A.TableID=B.TableID
LEFT OUTER JOIN ztDatasetMaster ON A.DatasetID=ztDatasetMaster.DatasetID
GO
/****** Object:  View [dbo].[webDatasetTableColumnList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetTableColumnList]  
as  
  SELECT DatasetID, DatasetName, 
         DatasetTableID,  
         A.TableId,  
         ColumnID,  
         ColumnName  
  FROM   webDatasetTableList A  
         INNER JOIN ztDatasetTableColumns B  
                 ON A.TableID = B.TableID  
  WHERE  Active = 1 
GO
/****** Object:  View [dbo].[webDataSourcesHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[webDataSourcesHor]
as
    SELECT SourceSystem,
         zSource,
         zSystem,
         SystemTypeID,
         SourceSystemID,
		 DescriptionLanguageValueBySystem,
         boaStatus,
		 zActive,
         Null AS BuildViews
  FROM   ztGlobalXrefSourceSystem 
GO
/****** Object:  View [dbo].[webDataSourcesList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDataSourcesList]
as
SELECT zSource, SourceSystemID
FROM webDataSourcesHor
GO
/****** Object:  View [dbo].[webGlobalXrefTargetSystemHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[webGlobalXrefTargetSystemHor]
AS
SELECT TargetSystem
,zSource
,zSystem
,SystemTypeID
,TargetSystemID
,AddedBy
,AddedOn
,AddedVia
,ChangedBy
,ChangedOn
,ChangedVia
,boaStatus
FROM ztGlobalXrefTargetSystem
GO
/****** Object:  View [dbo].[webSystemTypeTableTargetList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[webSystemTypeTableTargetList]
AS
SELECT SystemTypeID, SystemTypeTableID, TableName, Description, TableName + ' - ' + Description AS FriendlyName
FROM ztSystemTypeTable
WHERE SystemTypeID = (SELECT SystemTypeID FROM webGlobalXrefTargetSystemHor)
GO
/****** Object:  View [dbo].[webSystemTypeTableFieldList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[webSystemTypeTableFieldList]
AS
SELECT ztSystemTypeTableField.SystemTypeTableID, TableName, Field, FieldOrder, KeyField, ztSystemTypeTableField.Description, Field + ' - ' + ztSystemTypeTableField.Description  AS FriendlyName, Field + ' - ' + ztSystemTypeTableField.Description + CASE WHEN KeyField = 1 THEN ' - Is Key Field' ELSE '' END AS ListName
FROM ztSystemTypeTableField
INNER JOIN webSystemTypeTableTargetList
ON webSystemTypeTableTargetList.SystemTypeTableID = ztSystemTypeTableField.SystemTypeTableID

GO
/****** Object:  View [dbo].[webCheckTableList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webCheckTableList]
AS
SELECT SystemTypeID, SystemTypeTableID, TableName, Description, TableName + ' - ' + Description AS FriendlyName
FROM ztSystemTypeTable
INNER JOIN ztGlobalXref
ON TableName = CheckTableName
AND Active = 1
WHERE SystemTypeID = (SELECT SystemTypeID FROM webGlobalXrefTargetSystemHor)
UNION ALL
SELECT NULL, NULL, 'No Checktable', 'No Checktable', 'No Checktable'
GO
/****** Object:  View [dbo].[webGMRSystemSelectionHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webGMRSystemSelectionHor]
AS
  SELECT ztParameter.boaStatus,
		 ztParameter.ParameterID,
		 ztParameter.zCheckWithinGroup,
		 xtGMR_Selection.Comment,
         ztParameter.Comments,
		 zReviewType,
         --Scenario,
         --LoadCycle,
         --DeploymentName,
		 UnionReports,
         zSystem,
		 1 AS ConsistencyCheckMadeByDecision,
		 1 AS ConsistencyCheckByProposedMatchGroup,
		 CONCAT('SELECT * FROM InconsistentReport_Union_',ztParameter.zCheckWithinGroup) AS AllInconsistentReports,
		 CONCAT('SELECT * FROM InconsistentReport_UnionConflict_',ztParameter.zCheckWithinGroup) AS AllConflictReports,
		 CONCAT('SELECT * FROM InconsistentReport_UnionInfo_',ztParameter.zCheckWithinGroup) AS AllInfoReports,
		 NULL AS RefreshAllReports,
		 LastAllRefreshOn,
		 SUM(CASE WHEN ztAttributeConfig.zActive = 1 AND ConsistencyCheckMadeByDecision = 1 THEN 1 ELSE 0 END) AS GoToConsistencyCheckMadeByDecision,
		 SUM(CASE WHEN ztAttributeConfig.zActive = 1 AND ConsistencyCheckByProposedMatchGroup = 1 THEN 1 ELSE 0 END) AS GoToConsistencyCheckByProposedMatchGroup,
		 NULL AS AttributeConfiguration
  FROM   WRKDQHARMONIZE.dbo.ztParameter
  LEFT OUTER JOIN WRKMATCHREVIEW.dbo.xtGMR_Selection
  ON ztParameter.zCheckWithinGroup = xtGMR_Selection.zCheckWithinGroup
  LEFT OUTER JOIN WRKDQHARMONIZE.dbo.ztAttributeConfig
  ON ztParameter.zCheckWithinGroup = ztAttributeConfig.zCheckWithinGroup
  LEFT OUTER JOIN WRKDQHARMONIZE.dbo.ztAttributeConsistencySummary
  ON [ztAttributeConfig].AttributeID = ztAttributeConsistencySummary.AttributeID
  AND ztAttributeConfig.zActive = 1
  GROUP BY ztParameter.boaStatus,
		 ztParameter.ParameterID,
		 ztParameter.zCheckWithinGroup,
		 xtGMR_Selection.Comment,
         ztParameter.Comments,
		 zReviewType,
         --Scenario,
         --LoadCycle,
         --DeploymentName,
         zSystem,
		 LastAllRefreshOn,
		 UnionReports

  
GO
/****** Object:  View [dbo].[webParameterDcv]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webParameterDcv]
AS
SELECT ztParameter.[ParameterID]
      ,ztParameter.[zCheckWithinGroup]
      ,CASE WHEN ztParameter.[UnionReports] = 1 THEN 1 ELSE 0 END AS AllInconsistentReports
      
  FROM [WRKDQHARMONIZE].[dbo].ztParameter
  INNER JOIN webGMRSystemSelectionHor
  ON ztParameter.ParameterID = webGMRSystemSelectionHor.ParameterID
GO
/****** Object:  View [dbo].[boaColumnList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaColumnList] AS 

SELECT	sys.objects.name AS TableName,
		sys.columns.name AS ColumnName,
		sys.columns.column_id AS ColOrder,
		sys.objects.type
FROM	sys.columns INNER JOIN sys.objects ON sys.columns.object_id = sys.objects.object_id
WHERE   (sys.objects.type IN ('U', 'V'))
GO
/****** Object:  View [dbo].[boaDataSourceAllSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[boaDataSourceAllSel] AS 

SELECT     DataSource.DataSourceID,
		   DataSource.DataSourceName,
		  -- ISNULL(DataSourceInstance.[Database], DataSource.[Database]) AS [Database], 
		 -- ISNULL(DataSourceInstance.UserID, DataSource.UserID) AS UserID,
		 -- ISNULL(DataSourceInstance.DSN, DataSource.DSN) AS DSN, ISNULL(DataSourceInstance.Path, DataSource.Path) AS Path,
		 -- ISNULL(DataSourceInstance.Port, DataSource.Port) AS Port, DataSource.DatabaseType, 
		   DataSource.[Database] AS [Database], 
           DataSource.UserID AS UserID,
           DataSource.DSN AS DSN,
		   DataSource.Path AS Path,
           DataSource.Port AS Port, DataSource.DatabaseType, 
		 --  DataSourceType.DataSourceType,
		    'SqlServer' AS DataSourceType,
		   --DataSourceType.[Database] AS IsDatabase
		   '1' AS IsDatabase
FROM       [ztDataSource] AS [DataSource]
           --LEFT OUTER JOIN [CranSoft].[dbo].DataSourceInstance DataSourceInstance
           --ON DataSource.DataSourceID = DataSourceInstance.DatasourceID
           --AND DataSourceInstance.Instance = [CranSoft].[dbo].GetCurrentInstance()
		   --INNER JOIN [CranSoft].[dbo].DataSourceType DataSourceType
		   --ON DataSource.DataSourceType = DataSourceType.DataSourceType
GO
/****** Object:  View [dbo].[boaDataSourceSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[boaDataSourceSel] AS 

SELECT     DataSource.DataSourceID,
		   DataSource.DataSourceName,
		   --ISNULL(DataSourceInstance.[Database], DataSource.[Database]) AS [Database], 
		   --ISNULL(DataSourceInstance.UserID, DataSource.UserID) AS UserID,
		   --ISNULL(DataSourceInstance.DSN, DataSource.DSN) AS DSN, 
		   --ISNULL(DataSourceInstance.Path, DataSource.Path) AS Path,
		   --ISNULL(DataSourceInstance.Port, DataSource.Port) AS Port
		    DataSource.[Database] AS [Database], 
		    DataSource.UserID AS UserID,
		    DataSource.DSN AS DSN, 
		    DataSource.Path AS Path,
		    DataSource.Port AS Port
FROM       [ztDataSource] AS DataSource 
           --INNER JOIN [CranSoft].[dbo].DataSourceType ON DataSource.DataSourceType = [CranSoft].[dbo].DataSourceType.DataSourceType
           --LEFT OUTER JOIN [CranSoft].[dbo].DataSourceInstance DataSourceInstance
           --ON DataSource.DataSourceID = DataSourceInstance.DatasourceID
           --AND DataSourceInstance.Instance = [CranSoft].[dbo].GetCurrentInstance()
--WHERE     ([CranSoft].[dbo].DataSourceType.[Database] = 1)
GO
/****** Object:  View [dbo].[boaJobQueueSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[boaJobQueueSel] AS 
SELECT 1 AS A
GO
/****** Object:  View [dbo].[boaJobQueueTaskSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[boaJobQueueTaskSel] AS 
SELECT 1 AS A
--SELECT	[CranSoft].dbo.JobTaskStatus.boaStatus, 
--		[CranSoft].dbo.JobQueueTask.*
--FROM	[CranSoft].dbo.JobQueueTask INNER JOIN
--		[CranSoft].dbo.JobQueue ON [CranSoft].dbo.JobQueueTask.JobID = [CranSoft].dbo.JobQueue.JobID LEFT OUTER JOIN
--		[CranSoft].dbo.JobTaskStatus ON [CranSoft].dbo.JobQueueTask.Status = [CranSoft].dbo.JobTaskStatus.JobStatus
GO
/****** Object:  View [dbo].[boaObjectList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaObjectList] AS 

SELECT	[name],
		[type]
FROM	[sys].[objects]
WHERE	[type] IN ('U', 'V', 'FN', 'P')
GO
/****** Object:  View [dbo].[boaProcedureList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaProcedureList] AS 

SELECT	name as [name]
FROM	sys.procedures
GO
/****** Object:  View [dbo].[boaSqlList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaSqlList] AS 

SELECT	sys.objects.name,
		sys.objects.type AS xtype,
		sys.sql_modules.definition AS SQL
FROM	sys.sql_modules INNER JOIN
		sys.objects ON sys.sql_modules.object_id = sys.objects.object_id
WHERE	sys.objects.type IN ('V', 'FN', 'P')
GO
/****** Object:  View [dbo].[boaTableAndViewList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaTableAndViewList] AS 

SELECT  [name],
        rtrim(type) AS [xtype]
FROM    sys.objects
WHERE   [type] IN ('U', 'V')
GO
/****** Object:  View [dbo].[boaTableList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaTableList] AS 

SELECT	name as [Name]
FROM	sys.tables
GO
/****** Object:  View [dbo].[boaUDFList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaUDFList] AS 

  SELECT ROUTINE_NAME AS name
  FROM   INFORMATION_SCHEMA.ROUTINES
  WHERE  ROUTINE_Type = 'FUNCTION'
GO
/****** Object:  View [dbo].[boaUserSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaUserSel] AS 

SELECT	[User].UserID,
		[User].Name,
		[User].WindowsUserName,
		[User].LanguageID,
		--[WebAppUser].WebAppID,
		 '' AS WebAppID,
		[User].EMailAddress, 
		[User].Telephone
FROM	ztUser AS [User] 
--		INNER JOIN 
--		[CranSoft].dbo.WebAppUser WebappUser ON [User].UserID = WebAppUser.UserID
--WHERE	WebAppUser.WebAppID IN (SELECT WebAppID FROM [CranSoft].dbo.WebApp WHERE DataSourceID = 'a07acae9-1ade-499d-8b0e-85e8aef872fd')
--UNION
--SELECT	[User].UserID,
--		[User].Name,
--		[User].WindowsUserName,
--		[User].LanguageID,
--		RoleWebAppGroup.WebAppID,
--		[User].EMailAddress, 
--		[User].Telephone
--FROM	[CranSoft].dbo.[User] [User] INNER JOIN 
--		[CranSoft].dbo.[RoleUser] RoleUser ON
--			RoleUser.UserID = [User].UserID INNER JOIN 
--			[CranSoft].dbo.[RoleWebAppGroup] RoleWebAppGroup ON
--				RoleWebAppGroup.RoleID = RoleUser.RoleID
--					WHERE RoleWebAppGroup.WebAppID IN 
--						(SELECT WebAppID FROM [CranSoft].dbo.WebApp WHERE DataSourceID = 'a07acae9-1ade-499d-8b0e-85e8aef872fd')
	
GO
/****** Object:  View [dbo].[boaViewList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[boaViewList] AS 

SELECT	name as [Name]
FROM	sys.views
GO
/****** Object:  View [dbo].[boaWebAppGroupSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[boaWebAppGroupSel] AS 
SELECT 1 AS E
--SELECT	GroupID, 
--		GroupName,
--		WebAppID
--FROM	[CranSoft].dbo.WebAppGroup
--WHERE	WebAppID IN (SELECT WebAppID FROM [CranSoft].dbo.WebApp WHERE DataSourceID = 'a07acae9-1ade-499d-8b0e-85e8aef872fd')
GO
/****** Object:  View [dbo].[boaWebAppGroupUserSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[boaWebAppGroupUserSel] AS 
SELECT 1 AS E
GO
/****** Object:  View [dbo].[boaWebAppSel]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[boaWebAppSel] AS 
SELECT 1 AS E
--SELECT * 
--FROM [CranSoft].dbo.[WebApp]
GO
/****** Object:  View [dbo].[webAttributeConfigHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[webAttributeConfigHor]
AS
SELECT AttributeID
	  ,Area
	  ,zCheckWithinGroup
	  ,[Description]
	  ,AttributeDatabase
	  ,[DataSource].DataSourceName
      ,AttributeTable
      ,Attribute
	  ,SourceSystemIDColumn
	  ,MatchGroupIDColumn
	  ,WHEREClauseInput
	  ,CASE WHEN ISNULL(zCheckWithinGroup, '') <> '' THEN CONCAT(WHEREClauseInput, ' AND zCheckWithinGroup = ', zCheckWithinGroup) ELSE WHEREClauseInput END AS WHEREClause
	  ,NULL AS GenerateAttributeTable
	  ,SelectAttributeTable
	  ,AttributeTableLastRefreshedOn
      ,CheckTable
	  ,NULL AS ShowCheckTable
	  ,SelectDistinctValues
	  ,NULL AS AttributeConsistencySummary
      ,ztAttributeConfig.boaStatus
	  ,Comments
	  ,ztAttributeConfig.ConsistencyCheckMadeByDecision
	  ,ztAttributeConfig.ConsistencyCheckByProposedMatchGroup
	  ,ReportType
	  ,NULL AS CopyEntry
	  ,MasterDifferentOrBlankCheck
	  ,zActive
  FROM [WRKDQHARMONIZE].[dbo].[ztAttributeConfig]
  INNER JOIN ztDataSource AS [DataSource]
ON ztAttributeConfig.AttributeDatabase = [DataSource].[Database]
GO
/****** Object:  View [dbo].[webAttributeConfigVer]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
CREATE VIEW [dbo].[webAttributeConfigVer]  
AS  
SELECT AttributeID  
   ,AttributeDatabase  
   ,[DataSource].DataSourceName  
      ,AttributeTable  
      ,Attribute  
   ,SourceSystemIDColumn  
   ,MatchGroupIDColumn  
     
   ,ztAttributeConfig.ConsistencyCheckMadeByDecision  
   ,ztAttributeConfig.ConsistencyCheckByProposedMatchGroup  
   ,NULL AS CopyEntry  
   ,MasterDifferentOrBlankCheck  
   ,CaseSensitive  
   ,zActive  
  FROM [WRKDQHARMONIZE].[dbo].[ztAttributeConfig]  
  INNER JOIN [ztDataSource] AS [DataSource]  
ON ztAttributeConfig.AttributeDatabase = [DataSource].[Database]
GO
/****** Object:  View [dbo].[webAttributeConsistencySummaryHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[webAttributeConsistencySummaryHor]
AS
SELECT AttributeID
, TotalRecords
, CompleteRecords
, IncompleteRecords
, ConsistentRecords
, ConsistentRecordsSelect
, InconsistentRecords
, InconsistentRecordsSelect
, ConsistentMatchGroups
, InconsistentMatchGroups

FROM            dbo.ztAttributeConsistencySummary
GO
/****** Object:  View [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelHor]
AS
SELECT ztAttributeConsistencySummary.[AttributeID]
,ztAttributeConfig.Description
      ,ztAttributeConsistencySummary.[TotalRecords]
      ,ztAttributeConsistencySummary.[CompleteRecords]
      ,ztAttributeConsistencySummary.[IncompleteRecords]
      ,ztAttributeConsistencySummary.[ConsistentRecords]
      --,ztAttributeConsistencySummary.[ConsistentRecordsSelect]
      ,ztAttributeConsistencySummary.[InconsistentRecords]
      --,ztAttributeConsistencySummary.[InconsistentRecordsSelect]
      ,ztAttributeConsistencySummary.[ConsistentMatchGroups]
      ,ztAttributeConsistencySummary.[InconsistentMatchGroups]
      ,ztAttributeConsistencySummary.[LastRefreshedOn]
  FROM [WRKDQHARMONIZE].[dbo].[ztAttributeConsistencySummary]
  INNER JOIN ztAttributeConfig ON ztAttributeConfig.AttributeID = ztAttributeConsistencySummary.AttributeID
  WHERE ztAttributeConfig.ConsistencyCheckMadeByDecision = 1
  AND Description not like '%zzzz%'
GO
/****** Object:  View [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelSelectHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webAttributeConsistencySummaryMadeByDecisionExcelSelectHor]
AS
SELECT ztAttributeConsistencySummary.[AttributeID]
,ztAttributeConfig.Description
      ,ztAttributeConsistencySummary.[ConsistentRecordsSelect]
      ,ztAttributeConsistencySummary.[InconsistentRecordsSelect]
      ,ztAttributeConsistencySummary.[LastRefreshedOn]
  FROM [WRKDQHARMONIZE].[dbo].[ztAttributeConsistencySummary]
  INNER JOIN ztAttributeConfig ON ztAttributeConfig.AttributeID = ztAttributeConsistencySummary.AttributeID
  WHERE ztAttributeConfig.ConsistencyCheckMadeByDecision = 1
  AND Description not like '%zzzz%'
GO
/****** Object:  View [dbo].[webAttributeConsistencySummaryVer]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webAttributeConsistencySummaryVer]
AS
SELECT AttributeID
, ConsistentRecordsSelect
, ConsistentRecordsSelectExcel
, InconsistentRecordsSelect
, InconsistentRecordsSelectExcel
FROM            dbo.ztAttributeConsistencySummary
GO
/****** Object:  View [dbo].[webAttributeConsistencyTotalSummaryHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE VIEW [dbo].[webAttributeConsistencyTotalSummaryHor]
AS
  SELECT ztAttributeConfig.AttributeID
  ,ztAttributeConfig.Area
  ,ztAttributeConfig.zCheckWithinGroup
  ,ztAttributeConfig.Description
  ,TotalRecords
  ,CompleteRecords
  ,IncompleteRecords
  ,ConsistentRecords
  ,ConsistentRecordsSelect
  ,InconsistentRecords
  --,InconsistentRecordsSelect
  ,CONCAT('SELECT * FROM ',InconsistentReportTableName) AS InconsistentRecordsSelect
  ,ConsistentMatchGroups
  ,InconsistentMatchGroups
  ,ztAttributeConfig.boaStatus
  ,ConsistencyCheckMadeByDecision
  ,ConsistencyCheckByProposedMatchGroup
  ,NULL AS RefreshCounts
  ,LastRefreshedOn
  ,ztAttributeConfig.Comments
  FROM   dbo.ztAttributeConfig
  INNER JOIN dbo.ztAttributeConsistencySummary 
  ON ztAttributeConfig.AttributeID = ztAttributeConsistencySummary.AttributeID
  WHERE ztAttributeConfig.zActive = 1
GO
/****** Object:  View [dbo].[webColumnOrderConfigHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[webColumnOrderConfigHor]
AS
SELECT
[zCheckWithinGroup]
,AttributeID
      ,[MasterOrderID]
      ,[COLUMN_NAME]
	  ,[COLUMN_NAMENew]
      ,[DATA_TYPE]
	  ,Active
	  FROM [dbo].[ztColumnOrderConfig]
GO
/****** Object:  View [dbo].[webDatasetAvailableTablesHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[webDatasetAvailableTablesHor]
as
SELECT TableID
,DataSourceID
,DatabaseName
,TableName
,DisplayName
,IsActive
, NULL AS GetFields
, NULL AS Fields 
FROM ztDatasetAvailableTables
GO
/****** Object:  View [dbo].[webDatasetAvailableTablesList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetAvailableTablesList]
as
SELECT TableID, DatabaseName +' - '+ TableName as TableName 
FROM ztDatasetAvailableTables
GO
/****** Object:  View [dbo].[webDatasetFieldLookupTableDetailsHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[webDatasetFieldLookupTableDetailsHor]
as
SELECT A.DatasetId,DatasetName,DataBaseName,TableName, C.DisplayName as TableDisplayName, ColumnName, Active, E.DisplayName as FieldDisplayName ,A.LookUpTable,A.TargetSystemTable,A.TargetSystemTableFieldName
FROM ztDatasetSelectFields A 
LEFT OUTER JOIN ztDatasetTables B ON A.DatasetTableId=B.DatasetTableID
LEFT OUTER JOIN ztDatasetAvailableTables C ON B.TableID=C.TableID
LEFT OUTER JOIN ztDatasetMaster D ON A.DatasetID=D.DatasetID
LEFT OUTER JOIN ztDatasetTableColumns E ON C.TableID=E.TableID and A.ColumnID=E.ColumnID
--order by DatasetName,TableName,A.SequenceNumber

GO
/****** Object:  View [dbo].[webDatasetHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[webDatasetHor]
as
SELECT ID,Dataset,Category,[Description] 
FROM ztDataset
GO
/****** Object:  View [dbo].[webDatasetJoinConditionsHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetJoinConditionsHor]
as
  SELECT DatasetJoinConditionID,
         A.DatasetJoinID,
		 A.DatasetID,
         B.FROMTableID,
         FROMColumnID,
         B.ToTableID,
         ToColumnID,
         Operator,
         ConditionOrder
  FROM   ztDatasetJoinConditions A
         LEFT OUTER JOIN ztDatasetJoins B
                      ON A.DatasetJoinID = B.DatasetJoinID 
GO
/****** Object:  View [dbo].[webDatasetJoinsHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  CREATE view [dbo].[webDatasetJoinsHor]
as
  SELECT DatasetJoinID,
         DatasetID,
         FROMTableID,
         ToTableID,
         JoinType,
         AdditionalConditions,
		 JoinOrder,
         Null as Conditions
  FROM   ztDatasetJoins
  
GO
/****** Object:  View [dbo].[webDatasetJoinTypeList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[webDatasetJoinTypeList]
as
SELECT 'INNER JOIN' AS JoinType
UNION ALL
SELECT 'LEFT OUTER JOIN' AS JoinType
UNION ALL
SELECT 'RIGHT OUTER JOIN' AS JoinType
GO
/****** Object:  View [dbo].[webDatasetList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webDatasetList]  
as  
--select DatasetID,DatasetName from Dataset_Master

SELECT DISTINCT
  [Object]
, NamingConvention
, Table_Name as DatasetName
FROM ztDatasetNamingConvention
INNER JOIN INFORMATION_SCHEMA.VIEWS
ON Table_Name + '$' LIKE WRKDQHARMONIZE.dbo.boaGetWord(NamingConvention, 1)+ '%' + WRKDQHARMONIZE.dbo.boaGetWord(NamingConvention, 2) + '$'
--OR Table_Name + '$' LIKE WRKDQHARMONIZE.dbo.boaGetWord(NamingConvention, 1)+ '%' + '$'
WHERE [Object] = 'View'
GO
/****** Object:  View [dbo].[webDatasetLookUpTableList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[webDatasetLookUpTableList]
as
SELECT TableName AS  Table_Name 
FROM ztSystemTypeTable

GO
/****** Object:  View [dbo].[webDatasetMasterHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetMasterHor]
as
  SELECT DatasetID,
         DatasetName,
         [Description],
         IsActive,
		 Null as BuildViews,
         Null as [Tables],
         NULL as [Joins],
         NULL as [SELECTFields]
  FROM   ztDatasetMaster 
GO
/****** Object:  View [dbo].[webDatasetMasterVer]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetMasterVer]
as
SELECT DatasetID
,DatasetName
,[SELECT_SQL]
, NULL AS ParseSQL 
FROM ztDatasetMaster
GO
/****** Object:  View [dbo].[webDatasetNamingConventionHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[webDatasetNamingConventionHor]
AS
SELECT [ID]
      ,[Object]
      ,[NamingConvention]
  FROM [WRKDQHARMONIZE].[dbo].[ztDatasetNamingConvention]
GO
/****** Object:  View [dbo].[webDatasetSelectFieldsHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetSelectFieldsHor]
as
  SELECT DatasetSelectFieldID,
         DatasetID,
         DatasetTableId,
         SequenceNumber,
         ColumnID,
         ExpressionText,
         Alias,
         IsVisible,
         LookUpTable,TargetSystemTable,
         TargetSystemTableFieldName
  FROM   [dbo].[ztDatasetSelectFields] 
GO
/****** Object:  View [dbo].[webDatasetSystemTypeTableList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[webDatasetSystemTypeTableList]  
as  
SELECT D.SystemType, D.[Description] as SystemTypeDescription,B.TableName,B.[Description] as TableDescription,
C.TableName as DescriptionTableName,CF.Field as DescriptionField,CL.Field as LanguageField--,DataType,[Length], Decimals,KeyField,  
--OriginalDataType,OriginalLength,OriginalDecimals 
FROM   
ztSystemTypeTable B 
LEFT OUTER JOIN ztSystemTypeTable C  on B.DescriptionTableID=C.SystemTypeTableID   
LEFT OUTER JOIN ztsystemtypetablefield CF on B.DescriptionTableFieldID=CF.SystemTypeTableFieldID and B.DescriptionTableID=CF.SystemTypeTableID 
LEFT OUTER JOIN ztsystemtypetablefield CL on B.DescriptionTableLanguageFieldID=CL.SystemTypeTableFieldID and B.DescriptionTableID=CL.SystemTypeTableID
LEFT OUTER JOIN ztsystemtype D on B.SystemTypeID=D.SystemTypeID  
INNER JOIN WRKDQHARMONIZE.dbo.ztGlobalXrefTargetSystem ON D.SystemTypeID = ztGlobalXrefTargetSystem.SystemTypeID
GO
/****** Object:  View [dbo].[webDatasetTableColumnsHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetTableColumnsHor]
as
  SELECT ColumnID,
         TableID,
         ColumnName,
         DataType,
         Active,
         isExpression,
         AllowedForJoin,
         DisplayName
  FROM   ztDatasetTableColumns 
GO
/****** Object:  View [dbo].[webDatasetTablesHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[webDatasetTablesHor]
as
  SELECT DatasetTableID,
         DatasetID,
         TableID,
         Alias, 
		 TargetSystemTableName
  FROM   ztDatasetTables 
GO
/****** Object:  View [dbo].[webGlobalXrefDcv]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[webGlobalXrefDcv]
AS
SELECT 
CheckTableName
,CASE WHEN PageID IS NULL THEN 0 ELSE 1 END AS ShowCheckTable
,CASE WHEN PageID IS NULL THEN 1 ELSE 0 END AS CreateCheckTable
FROM ztGlobalXref
GO
/****** Object:  View [dbo].[webGlobalXrefEvt]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[webGlobalXrefEvt]
AS
SELECT CheckTableName
,Active
,Comments
,PageID
,'a07acae9-1ade-499d-8b0e-85e8aef872fd' AS DataSourceID /*WRKDQHARMONIZE*/
,'Dynamic' AS PageType
FROM ztGlobalXref
GO
/****** Object:  View [dbo].[webGlobalXrefHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE VIEW [dbo].[webGlobalXrefHor]
AS
SELECT 
boaStatus
,CheckTableName
,ValueField01
,ValueField02
,ValueField03
,NULL AS ShowCheckTable
,Active
,Comments
,NULL AS CreateCheckTable
,NULL AS InsertSourceValues
,NULL AS AutoMapByValues
,NULL AS AutoMapByDescriptions
,MappedValues
,RelevantGroupedRecords
,GroupedRecords
,PageID
,AddedBy
,AddedOn
,AddedVia
,ChangedBy
,ChangedOn
,ChangedVia
FROM ztGlobalXref
GO
/****** Object:  View [dbo].[webGlobalXrefSourceSystemHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[webGlobalXrefSourceSystemHor]
AS
  SELECT SourceSystem,
         zSource,
         zSystem,
         SystemTypeID,
         SourceSystemID,
		 DescriptionLanguageValueBySystem,
         AddedBy,
         AddedOn,
         AddedVia,
         ChangedBy,
         ChangedOn,
         ChangedVia,
         boaStatus,
		 zActive
  FROM   ztGlobalXrefSourceSystem 
GO
/****** Object:  View [dbo].[webGlobalXrefVer]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE VIEW [dbo].[webGlobalXrefVer]
AS
SELECT CheckTableName
,NULL AS CheckTableDescription
,DescriptionTable01
,DescriptionTableKeyField01
,DescriptionField01
,DescriptionTable02
,DescriptionTableKeyField02
,DescriptionField02
,DescriptionTable03
,DescriptionTableKeyField03
,DescriptionField03
,DescriptionLanguageField
,DescriptionLanguageFieldValue
,PageID
,CaseSensitive
FROM ztGlobalXref
GO
/****** Object:  View [dbo].[webGMRSystemSelectionVer]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[webGMRSystemSelectionVer]
AS
  SELECT ztParameter.boaStatus,
		 ztParameter.ParameterID,
		 ztParameter.zCheckWithinGroup,
		 xtGMR_Selection.Comment,
         ztParameter.Comments,
		 zReviewType,
         --Scenario,
         --LoadCycle,
         --DeploymentName,
         zSystem,
		 NULL AS Reports,
		 1 AS ConsistencyCheckMadeByDecision,
		 1 AS ConsistencyCheckByProposedMatchGroup,
		 CONCAT('SELECT * FROM InconsistentReport_Union_',ztParameter.zCheckWithinGroup) AS AllInconsistentReports,
		 NULL AS RefreshAllReports,
		 LastAllRefreshOn,
		 NULL AS Summary,
		 SUM(CASE WHEN ztAttributeConfig.zActive = 1 AND ConsistencyCheckMadeByDecision = 1 THEN 1 ELSE 0 END) AS GoToConsistencyCheckMadeByDecision,
		 SUM(CASE WHEN ztAttributeConfig.zActive = 1 AND ConsistencyCheckByProposedMatchGroup = 1 THEN 1 ELSE 0 END) AS GoToConsistencyCheckByProposedMatchGroup,
		 NULL AS Configuration,
		 NULL AS AttributeConfiguration,
		 NULL AS ColumnOrderConfig
  FROM   WRKDQHARMONIZE.dbo.ztParameter
  LEFT OUTER JOIN WRKMATCHREVIEW.dbo.xtGMR_Selection
  ON ztParameter.zCheckWithinGroup = xtGMR_Selection.zCheckWithinGroup
  LEFT OUTER JOIN WRKDQHARMONIZE.dbo.ztAttributeConfig
  ON ztParameter.zCheckWithinGroup = ztAttributeConfig.zCheckWithinGroup
  LEFT OUTER JOIN WRKDQHARMONIZE.dbo.ztAttributeConsistencySummary
  ON [ztAttributeConfig].AttributeID = ztAttributeConsistencySummary.AttributeID
  AND ztAttributeConfig.zActive = 1
  GROUP BY ztParameter.boaStatus,
		 ztParameter.ParameterID,
		 ztParameter.zCheckWithinGroup,
		 xtGMR_Selection.Comment,
         ztParameter.Comments,
		 zReviewType,
         --Scenario,
         --LoadCycle,
         --DeploymentName,
         zSystem,
		 LastAllRefreshOn

  
GO
/****** Object:  View [dbo].[webGMRzCheckWithinGroupList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webGMRzCheckWithinGroupList]
AS
SELECT zCheckWithinGroup, CONCAT(zCheckWithinGroup,''/* ' - ', ISNULL(DeploymentName,''), ' ', ISNULL(Scenario, '')*/) AS FriendlyName
FROM WRKMATCHREVIEW.dbo.xtGMR_Selection
--WHERE ConsistencyCheck = 1
GO
/****** Object:  View [dbo].[webReportsHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webReportsHor] AS 
SELECT 1 AS E
--SELECT DISTINCT		webReportHor.Priority,
--					webReportHor.PageID AS Report,
--					WebAppGroupUser.UserID AS boaUserID
--FROM				[CranSoft].dbo.webReportHor webReportHor
--                    INNER JOIN [CranSoft].dbo.WebAppGroupPage WebAppGroupPage
--                    ON webReportHor.PageID = WebAppGroupPage.PageID
--                    INNER JOIN [CranSoft].dbo.WebAppGroupUser WebAppGroupUser
--                    ON WebAppGroupPage.GroupID = WebAppGroupUser.GroupID
--WHERE				webReportHor.WebAppID IN (SELECT WebAppID FROM [CranSoft].dbo.WebApp WHERE DataSourceID = 'a07acae9-1ade-499d-8b0e-85e8aef872fd') AND
--					webReportHor.IsTopLevelReport = 1

--UNION

--SELECT DISTINCT		webReportHor.Priority,
--					webReportHor.PageID AS Report,
--					RoleUser.UserID AS boaUserID
--FROM				[CranSoft].dbo.webReportHor webReportHor
--                    INNER JOIN [CranSoft].dbo.WebAppGroupPage WebAppGroupPage
--                    ON webReportHor.PageID = WebAppGroupPage.PageID
--                    INNER JOIN [CranSoft].dbo.RoleWebAppGroup RoleWebAppGroup
--                    ON WebAppGroupPage.GroupID = RoleWebAppGroup.GroupID
--                    INNER JOIN [CranSoft].dbo.RoleUser RoleUser
--                    ON RoleWebAppGroup.RoleID = RoleUser.RoleID
--WHERE				webReportHor.WebAppID IN (SELECT WebAppID FROM [CranSoft].dbo.WebApp WHERE DataSourceID = 'a07acae9-1ade-499d-8b0e-85e8aef872fd') AND
--					webReportHor.IsTopLevelReport = 1
GO
/****** Object:  View [dbo].[webReportTypeList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE VIEW [dbo].[webReportTypeList]
AS
SELECT [Priority], ReportType
FROM ztReportType
GO
/****** Object:  View [dbo].[webSystemTypeList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webSystemTypeList]
AS
SELECT * FROM ztSystemType
GO
/****** Object:  View [dbo].[webWebAppCatalogLanguagePhraseList]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[webWebAppCatalogLanguagePhraseList]
AS
SELECT a.CatalogID, a.[Priority], a.[Phrase], a.[PhraseOut]
FROM 
(
select '1' as CatalogID,
		WebAppCatalog.[Priority],
		[Phrase], 
		[PhraseOut]
		,CAST(ROW_NUMBER() OVER(PARTITION BY [Phrase] ORDER BY WebAppCatalog.[Priority]) AS INT) AS Ranking
from ztWebAppCatalog AS WebAppCatalog
--inner join CranSoft.dbo.WebApp
--on WebAppCatalog.WebAppID = webapp.webappid
--INNER JOIN CranSoft.dbo.CatalogLanguagePhrase
--ON WebAppCatalog.CatalogID = CatalogLanguagePhrase.CatalogID
--where WebAppCatalog.WebAppID = '61120dc0-1f6c-4e68-83d5-89d0633e0649'
--AND LanguageID = 'B16EA10F-7D20-4851-B941-D84252632951'
) a
WHERE Ranking = 1
GO
/****** Object:  View [dbo].[webztDataSourceHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create VIEW [dbo].[webztDataSourceHor]
	AS

	SELECT *
	FROM ztDataSource
GO
/****** Object:  View [dbo].[webztUserHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE VIEW [dbo].[webztUserHor]
	AS

	SELECT *
	FROM ztUser
GO
/****** Object:  View [dbo].[webztWebAppCatalogHor]    Script Date: 4/23/2026 1:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create VIEW [dbo].[webztWebAppCatalogHor]
	AS

	SELECT *
	FROM ztWebAppCatalog
GO
