USE [WRKDQHARMONIZE]
GO
/****** Object:  Table [dbo].[AttributeTable_1]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeTable_1](
	[ZSOURCE] [nvarchar](50) NOT NULL,
	[ZDEPLOY] [nvarchar](10) NOT NULL,
	[ZLEGACYKUNNR] [nvarchar](50) NOT NULL,
	[MANDT] [nvarchar](3) NULL,
	[KUNNR] [nvarchar](10) NULL,
	[LAND1] [nvarchar](3) NULL,
	[NAME1] [nvarchar](35) NULL,
	[NAME2] [nvarchar](35) NULL,
	[ORT01] [nvarchar](35) NULL,
	[PSTLZ] [nvarchar](10) NULL,
	[REGIO] [nvarchar](3) NULL,
	[SORTL] [nvarchar](10) NULL,
	[STRAS] [nvarchar](35) NULL,
	[TELF1] [nvarchar](16) NULL,
	[TELFX] [nvarchar](31) NULL,
	[XCPDK] [nvarchar](1) NULL,
	[ADRNR] [nvarchar](10) NULL,
	[MCOD1] [nvarchar](25) NULL,
	[MCOD2] [nvarchar](25) NULL,
	[MCOD3] [nvarchar](25) NULL,
	[ANRED] [nvarchar](15) NULL,
	[AUFSD] [nvarchar](2) NULL,
	[BAHNE] [nvarchar](25) NULL,
	[BAHNS] [nvarchar](25) NULL,
	[BBBNR] [nvarchar](7) NULL,
	[BBSNR] [nvarchar](5) NULL,
	[BEGRU] [nvarchar](4) NULL,
	[BRSCH] [nvarchar](4) NULL,
	[BUBKZ] [nvarchar](1) NULL,
	[DATLT] [nvarchar](14) NULL,
	[ERDAT] [nvarchar](10) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[EXABL] [nvarchar](1) NULL,
	[FAKSD] [nvarchar](2) NULL,
	[FISKN] [nvarchar](10) NULL,
	[KNAZK] [nvarchar](2) NULL,
	[KNRZA] [nvarchar](10) NULL,
	[KONZS] [nvarchar](10) NULL,
	[KTOKD] [nvarchar](4) NULL,
	[KUKLA] [nvarchar](2) NULL,
	[LIFNR] [nvarchar](10) NULL,
	[LIFSD] [nvarchar](2) NULL,
	[LOCCO] [nvarchar](10) NULL,
	[LOEVM] [nvarchar](1) NULL,
	[NAME3] [nvarchar](35) NULL,
	[NAME4] [nvarchar](35) NULL,
	[NIELS] [nvarchar](2) NULL,
	[ORT02] [nvarchar](35) NULL,
	[PFACH] [nvarchar](10) NULL,
	[PSTL2] [nvarchar](10) NULL,
	[COUNC] [nvarchar](3) NULL,
	[CITYC] [nvarchar](4) NULL,
	[RPMKR] [nvarchar](5) NULL,
	[SPERR] [nvarchar](1) NULL,
	[SPRAS] [nvarchar](1) NULL,
	[STCD1] [nvarchar](16) NULL,
	[STCD2] [nvarchar](11) NULL,
	[STKZA] [nvarchar](1) NULL,
	[STKZU] [nvarchar](1) NULL,
	[TELBX] [nvarchar](15) NULL,
	[TELF2] [nvarchar](16) NULL,
	[TELTX] [nvarchar](30) NULL,
	[TELX1] [nvarchar](30) NULL,
	[LZONE] [nvarchar](10) NULL,
	[XZEMP] [nvarchar](1) NULL,
	[VBUND] [nvarchar](6) NULL,
	[STCEG] [nvarchar](20) NULL,
	[DEAR1] [nvarchar](1) NULL,
	[DEAR2] [nvarchar](1) NULL,
	[DEAR3] [nvarchar](1) NULL,
	[DEAR4] [nvarchar](1) NULL,
	[DEAR5] [nvarchar](1) NULL,
	[GFORM] [nvarchar](2) NULL,
	[BRAN1] [nvarchar](10) NULL,
	[BRAN2] [nvarchar](10) NULL,
	[BRAN3] [nvarchar](10) NULL,
	[BRAN4] [nvarchar](10) NULL,
	[BRAN5] [nvarchar](10) NULL,
	[EKONT] [nvarchar](10) NULL,
	[UMSAT] [money] NULL,
	[UMJAH] [nvarchar](4) NULL,
	[UWAER] [nvarchar](5) NULL,
	[JMZAH] [nvarchar](6) NULL,
	[JMJAH] [nvarchar](4) NULL,
	[KATR1] [nvarchar](2) NULL,
	[KATR2] [nvarchar](2) NULL,
	[KATR3] [nvarchar](2) NULL,
	[KATR4] [nvarchar](2) NULL,
	[KATR5] [nvarchar](2) NULL,
	[KATR6] [nvarchar](3) NULL,
	[KATR7] [nvarchar](3) NULL,
	[KATR8] [nvarchar](3) NULL,
	[KATR9] [nvarchar](3) NULL,
	[KATR10] [nvarchar](3) NULL,
	[STKZN] [nvarchar](1) NULL,
	[UMSA1] [money] NULL,
	[TXJCD] [nvarchar](15) NULL,
	[PERIV] [nvarchar](2) NULL,
	[ABRVW] [nvarchar](3) NULL,
	[INSPBYDEBI] [nvarchar](1) NULL,
	[INSPATDEBI] [nvarchar](1) NULL,
	[ZERROR_LOG] [nvarchar](2000) NULL,
	[ZLOADED] [bit] NULL,
	[ZLOADDATE] [date] NULL,
	[ZDATA_READY] [bit] NULL,
	[ZBUSINESS_READY] [bit] NULL,
	[ZSTAGE_READY] [bit] NULL,
	[ZTARGET_READY] [bit] NULL,
	[ZCHUNK] [int] NULL,
	[ZINTARGETSYS] [bit] NULL,
	[ZREMEDIATED] [bit] NULL,
	[KTOCD] [nvarchar](4) NULL,
	[PFORT] [nvarchar](35) NULL,
	[WERKS] [nvarchar](4) NULL,
	[DTAMS] [nvarchar](1) NULL,
	[DTAWS] [nvarchar](2) NULL,
	[DUEFL] [nvarchar](1) NULL,
	[HZUOR] [nvarchar](2) NULL,
	[SPERZ] [nvarchar](1) NULL,
	[ETIKG] [nvarchar](10) NULL,
	[CIVVE] [nvarchar](1) NULL,
	[MILVE] [nvarchar](1) NULL,
	[KDKG1] [nvarchar](2) NULL,
	[KDKG2] [nvarchar](2) NULL,
	[KDKG3] [nvarchar](2) NULL,
	[KDKG4] [nvarchar](2) NULL,
	[KDKG5] [nvarchar](2) NULL,
	[XKNZA] [nvarchar](1) NULL,
	[FITYP] [nvarchar](2) NULL,
	[STCDT] [nvarchar](2) NULL,
	[STCD3] [nvarchar](18) NULL,
	[STCD4] [nvarchar](18) NULL,
	[STCD5] [nvarchar](60) NULL,
	[XICMS] [nvarchar](1) NULL,
	[XXIPI] [nvarchar](1) NULL,
	[XSUBT] [nvarchar](3) NULL,
	[CFOPC] [nvarchar](2) NULL,
	[TXLW1] [nvarchar](3) NULL,
	[TXLW2] [nvarchar](3) NULL,
	[CCC01] [nvarchar](1) NULL,
	[CCC02] [nvarchar](1) NULL,
	[CCC03] [nvarchar](1) NULL,
	[CCC04] [nvarchar](1) NULL,
	[CASSD] [nvarchar](2) NULL,
	[KNURL] [nvarchar](132) NULL,
	[J_1KFREPRE] [nvarchar](10) NULL,
	[J_1KFTBUS] [nvarchar](30) NULL,
	[J_1KFTIND] [nvarchar](30) NULL,
	[CONFS] [nvarchar](1) NULL,
	[UPDAT] [nvarchar](10) NULL,
	[UPTIM] [nvarchar](10) NULL,
	[NODEL] [nvarchar](1) NULL,
	[DEAR6] [nvarchar](1) NULL,
	[CVP_XBLCK] [nvarchar](1) NULL,
	[SUFRAMA] [nvarchar](9) NULL,
	[RG] [nvarchar](11) NULL,
	[EXP] [nvarchar](3) NULL,
	[UF] [nvarchar](2) NULL,
	[RGDATE] [nvarchar](10) NULL,
	[RIC] [nvarchar](11) NULL,
	[RNE] [nvarchar](10) NULL,
	[RNEDATE] [nvarchar](10) NULL,
	[CNAE] [nvarchar](7) NULL,
	[LEGALNAT] [nvarchar](4) NULL,
	[CRTN] [nvarchar](1) NULL,
	[ICMSTAXPAY] [nvarchar](2) NULL,
	[INDTYP] [nvarchar](2) NULL,
	[TDT] [nvarchar](2) NULL,
	[COMSIZE] [nvarchar](2) NULL,
	[DECREGPC] [nvarchar](2) NULL,
	[/VSO/R_PALHGT] [decimal](13, 3) NULL,
	[/VSO/R_PAL_UL] [nvarchar](3) NULL,
	[/VSO/R_PK_MAT] [nvarchar](1) NULL,
	[/VSO/R_MATPAL] [nvarchar](18) NULL,
	[/VSO/R_I_NO_LYR] [nvarchar](2) NULL,
	[/VSO/R_ONE_MAT] [nvarchar](1) NULL,
	[/VSO/R_ONE_SORT] [nvarchar](1) NULL,
	[/VSO/R_ULD_SIDE] [nvarchar](1) NULL,
	[/VSO/R_LOAD_PREF] [nvarchar](1) NULL,
	[/VSO/R_DPOINT] [nvarchar](10) NULL,
	[/XLSO/CUSTOMER] [nvarchar](1) NULL,
	[/XLSO/SYSID] [nvarchar](8) NULL,
	[/XLSO/CLIENT] [nvarchar](3) NULL,
	[/XLSO/PARTNER] [nvarchar](10) NULL,
	[/XLSO/PREF_PAY] [nvarchar](2) NULL,
	[ALC] [nvarchar](8) NULL,
	[PMT_OFFICE] [nvarchar](5) NULL,
	[FEE_SCHEDULE] [nvarchar](4) NULL,
	[DUNS] [nvarchar](9) NULL,
	[DUNS4] [nvarchar](4) NULL,
	[PSOFG] [nvarchar](10) NULL,
	[PSOIS] [nvarchar](20) NULL,
	[PSON1] [nvarchar](35) NULL,
	[PSON2] [nvarchar](35) NULL,
	[PSON3] [nvarchar](35) NULL,
	[PSOVN] [nvarchar](35) NULL,
	[PSOTL] [nvarchar](20) NULL,
	[PSOHS] [nvarchar](6) NULL,
	[PSOST] [nvarchar](28) NULL,
	[PSOO1] [nvarchar](50) NULL,
	[PSOO2] [nvarchar](50) NULL,
	[PSOO3] [nvarchar](50) NULL,
	[PSOO4] [nvarchar](50) NULL,
	[PSOO5] [nvarchar](50) NULL,
	[OIDRC] [nvarchar](5) NULL,
	[OID_POREQD] [nvarchar](1) NULL,
	[OIPBL] [nvarchar](10) NULL,
	[ZCRITICAL] [bit] NULL,
	[ZREL_LOEVM] [bit] NULL,
	[ZREL_KTOKD] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DSPCommonTrace_EventData]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSPCommonTrace_EventData](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [nvarchar](256) NULL,
	[EventType] [nvarchar](64) NULL,
	[ObjectName] [nvarchar](256) NULL,
	[ObjectType] [nvarchar](32) NULL,
	[TSQLCommand] [nvarchar](max) NULL,
	[LoginName] [nvarchar](256) NULL,
	[ChangedOn] [datetime] NULL,
	[type] [nvarchar](8) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InconsistentReport_1]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InconsistentReport_1](
	[AttributeColumn] [nvarchar](258) NOT NULL,
	[AttributeValue] [nvarchar](100) NULL,
	[ZSOURCE] [nvarchar](50) NOT NULL,
	[ZDEPLOY] [nvarchar](10) NOT NULL,
	[ZLEGACYKUNNR] [nvarchar](50) NOT NULL,
	[MANDT] [nvarchar](3) NULL,
	[KUNNR] [nvarchar](10) NULL,
	[LAND1] [nvarchar](3) NULL,
	[NAME1] [nvarchar](35) NULL,
	[NAME2] [nvarchar](35) NULL,
	[ORT01] [nvarchar](35) NULL,
	[PSTLZ] [nvarchar](10) NULL,
	[REGIO] [nvarchar](3) NULL,
	[SORTL] [nvarchar](10) NULL,
	[STRAS] [nvarchar](35) NULL,
	[TELF1] [nvarchar](16) NULL,
	[TELFX] [nvarchar](31) NULL,
	[XCPDK] [nvarchar](1) NULL,
	[ADRNR] [nvarchar](10) NULL,
	[MCOD1] [nvarchar](25) NULL,
	[MCOD2] [nvarchar](25) NULL,
	[MCOD3] [nvarchar](25) NULL,
	[ANRED] [nvarchar](15) NULL,
	[AUFSD] [nvarchar](2) NULL,
	[BAHNE] [nvarchar](25) NULL,
	[BAHNS] [nvarchar](25) NULL,
	[BBBNR] [nvarchar](7) NULL,
	[BBSNR] [nvarchar](5) NULL,
	[BEGRU] [nvarchar](4) NULL,
	[BRSCH] [nvarchar](4) NULL,
	[BUBKZ] [nvarchar](1) NULL,
	[DATLT] [nvarchar](14) NULL,
	[ERDAT] [nvarchar](10) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[EXABL] [nvarchar](1) NULL,
	[FAKSD] [nvarchar](2) NULL,
	[FISKN] [nvarchar](10) NULL,
	[KNAZK] [nvarchar](2) NULL,
	[KNRZA] [nvarchar](10) NULL,
	[KONZS] [nvarchar](10) NULL,
	[KTOKD] [nvarchar](4) NULL,
	[KUKLA] [nvarchar](2) NULL,
	[LIFNR] [nvarchar](10) NULL,
	[LIFSD] [nvarchar](2) NULL,
	[LOCCO] [nvarchar](10) NULL,
	[LOEVM] [nvarchar](1) NULL,
	[NAME3] [nvarchar](35) NULL,
	[NAME4] [nvarchar](35) NULL,
	[NIELS] [nvarchar](2) NULL,
	[ORT02] [nvarchar](35) NULL,
	[PFACH] [nvarchar](10) NULL,
	[PSTL2] [nvarchar](10) NULL,
	[COUNC] [nvarchar](3) NULL,
	[CITYC] [nvarchar](4) NULL,
	[RPMKR] [nvarchar](5) NULL,
	[SPERR] [nvarchar](1) NULL,
	[SPRAS] [nvarchar](1) NULL,
	[STCD1] [nvarchar](16) NULL,
	[STCD2] [nvarchar](11) NULL,
	[STKZA] [nvarchar](1) NULL,
	[STKZU] [nvarchar](1) NULL,
	[TELBX] [nvarchar](15) NULL,
	[TELF2] [nvarchar](16) NULL,
	[TELTX] [nvarchar](30) NULL,
	[TELX1] [nvarchar](30) NULL,
	[LZONE] [nvarchar](10) NULL,
	[XZEMP] [nvarchar](1) NULL,
	[VBUND] [nvarchar](6) NULL,
	[STCEG] [nvarchar](20) NULL,
	[DEAR1] [nvarchar](1) NULL,
	[DEAR2] [nvarchar](1) NULL,
	[DEAR3] [nvarchar](1) NULL,
	[DEAR4] [nvarchar](1) NULL,
	[DEAR5] [nvarchar](1) NULL,
	[GFORM] [nvarchar](2) NULL,
	[BRAN1] [nvarchar](10) NULL,
	[BRAN2] [nvarchar](10) NULL,
	[BRAN3] [nvarchar](10) NULL,
	[BRAN4] [nvarchar](10) NULL,
	[BRAN5] [nvarchar](10) NULL,
	[EKONT] [nvarchar](10) NULL,
	[UMSAT] [money] NULL,
	[UMJAH] [nvarchar](4) NULL,
	[UWAER] [nvarchar](5) NULL,
	[JMZAH] [nvarchar](6) NULL,
	[JMJAH] [nvarchar](4) NULL,
	[KATR1] [nvarchar](2) NULL,
	[KATR2] [nvarchar](2) NULL,
	[KATR3] [nvarchar](2) NULL,
	[KATR4] [nvarchar](2) NULL,
	[KATR5] [nvarchar](2) NULL,
	[KATR6] [nvarchar](3) NULL,
	[KATR7] [nvarchar](3) NULL,
	[KATR8] [nvarchar](3) NULL,
	[KATR9] [nvarchar](3) NULL,
	[KATR10] [nvarchar](3) NULL,
	[STKZN] [nvarchar](1) NULL,
	[UMSA1] [money] NULL,
	[TXJCD] [nvarchar](15) NULL,
	[PERIV] [nvarchar](2) NULL,
	[ABRVW] [nvarchar](3) NULL,
	[INSPBYDEBI] [nvarchar](1) NULL,
	[INSPATDEBI] [nvarchar](1) NULL,
	[ZERROR_LOG] [nvarchar](2000) NULL,
	[ZLOADED] [bit] NULL,
	[ZLOADDATE] [date] NULL,
	[ZDATA_READY] [bit] NULL,
	[ZBUSINESS_READY] [bit] NULL,
	[ZSTAGE_READY] [bit] NULL,
	[ZTARGET_READY] [bit] NULL,
	[ZCHUNK] [int] NULL,
	[ZINTARGETSYS] [bit] NULL,
	[ZREMEDIATED] [bit] NULL,
	[KTOCD] [nvarchar](4) NULL,
	[PFORT] [nvarchar](35) NULL,
	[WERKS] [nvarchar](4) NULL,
	[DTAMS] [nvarchar](1) NULL,
	[DTAWS] [nvarchar](2) NULL,
	[DUEFL] [nvarchar](1) NULL,
	[HZUOR] [nvarchar](2) NULL,
	[SPERZ] [nvarchar](1) NULL,
	[ETIKG] [nvarchar](10) NULL,
	[CIVVE] [nvarchar](1) NULL,
	[MILVE] [nvarchar](1) NULL,
	[KDKG1] [nvarchar](2) NULL,
	[KDKG2] [nvarchar](2) NULL,
	[KDKG3] [nvarchar](2) NULL,
	[KDKG4] [nvarchar](2) NULL,
	[KDKG5] [nvarchar](2) NULL,
	[XKNZA] [nvarchar](1) NULL,
	[FITYP] [nvarchar](2) NULL,
	[STCDT] [nvarchar](2) NULL,
	[STCD3] [nvarchar](18) NULL,
	[STCD4] [nvarchar](18) NULL,
	[STCD5] [nvarchar](60) NULL,
	[XICMS] [nvarchar](1) NULL,
	[XXIPI] [nvarchar](1) NULL,
	[XSUBT] [nvarchar](3) NULL,
	[CFOPC] [nvarchar](2) NULL,
	[TXLW1] [nvarchar](3) NULL,
	[TXLW2] [nvarchar](3) NULL,
	[CCC01] [nvarchar](1) NULL,
	[CCC02] [nvarchar](1) NULL,
	[CCC03] [nvarchar](1) NULL,
	[CCC04] [nvarchar](1) NULL,
	[CASSD] [nvarchar](2) NULL,
	[KNURL] [nvarchar](132) NULL,
	[J_1KFREPRE] [nvarchar](10) NULL,
	[J_1KFTBUS] [nvarchar](30) NULL,
	[J_1KFTIND] [nvarchar](30) NULL,
	[CONFS] [nvarchar](1) NULL,
	[UPDAT] [nvarchar](10) NULL,
	[UPTIM] [nvarchar](10) NULL,
	[NODEL] [nvarchar](1) NULL,
	[DEAR6] [nvarchar](1) NULL,
	[CVP_XBLCK] [nvarchar](1) NULL,
	[SUFRAMA] [nvarchar](9) NULL,
	[RG] [nvarchar](11) NULL,
	[EXP] [nvarchar](3) NULL,
	[UF] [nvarchar](2) NULL,
	[RGDATE] [nvarchar](10) NULL,
	[RIC] [nvarchar](11) NULL,
	[RNE] [nvarchar](10) NULL,
	[RNEDATE] [nvarchar](10) NULL,
	[CNAE] [nvarchar](7) NULL,
	[LEGALNAT] [nvarchar](4) NULL,
	[CRTN] [nvarchar](1) NULL,
	[ICMSTAXPAY] [nvarchar](2) NULL,
	[INDTYP] [nvarchar](2) NULL,
	[TDT] [nvarchar](2) NULL,
	[COMSIZE] [nvarchar](2) NULL,
	[DECREGPC] [nvarchar](2) NULL,
	[/VSO/R_PALHGT] [decimal](13, 3) NULL,
	[/VSO/R_PAL_UL] [nvarchar](3) NULL,
	[/VSO/R_PK_MAT] [nvarchar](1) NULL,
	[/VSO/R_MATPAL] [nvarchar](18) NULL,
	[/VSO/R_I_NO_LYR] [nvarchar](2) NULL,
	[/VSO/R_ONE_MAT] [nvarchar](1) NULL,
	[/VSO/R_ONE_SORT] [nvarchar](1) NULL,
	[/VSO/R_ULD_SIDE] [nvarchar](1) NULL,
	[/VSO/R_LOAD_PREF] [nvarchar](1) NULL,
	[/VSO/R_DPOINT] [nvarchar](10) NULL,
	[/XLSO/CUSTOMER] [nvarchar](1) NULL,
	[/XLSO/SYSID] [nvarchar](8) NULL,
	[/XLSO/CLIENT] [nvarchar](3) NULL,
	[/XLSO/PARTNER] [nvarchar](10) NULL,
	[/XLSO/PREF_PAY] [nvarchar](2) NULL,
	[ALC] [nvarchar](8) NULL,
	[PMT_OFFICE] [nvarchar](5) NULL,
	[FEE_SCHEDULE] [nvarchar](4) NULL,
	[DUNS] [nvarchar](9) NULL,
	[DUNS4] [nvarchar](4) NULL,
	[PSOFG] [nvarchar](10) NULL,
	[PSOIS] [nvarchar](20) NULL,
	[PSON1] [nvarchar](35) NULL,
	[PSON2] [nvarchar](35) NULL,
	[PSON3] [nvarchar](35) NULL,
	[PSOVN] [nvarchar](35) NULL,
	[PSOTL] [nvarchar](20) NULL,
	[PSOHS] [nvarchar](6) NULL,
	[PSOST] [nvarchar](28) NULL,
	[PSOO1] [nvarchar](50) NULL,
	[PSOO2] [nvarchar](50) NULL,
	[PSOO3] [nvarchar](50) NULL,
	[PSOO4] [nvarchar](50) NULL,
	[PSOO5] [nvarchar](50) NULL,
	[OIDRC] [nvarchar](5) NULL,
	[OID_POREQD] [nvarchar](1) NULL,
	[OIPBL] [nvarchar](10) NULL,
	[ZCRITICAL] [bit] NULL,
	[ZREL_LOEVM] [bit] NULL,
	[ZREL_KTOKD] [bit] NULL,
	[ReportType] [varchar](5) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztAttributeConfig]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztAttributeConfig](
	[AttributeID] [int] IDENTITY(1,1) NOT NULL,
	[Area] [nvarchar](100) NULL,
	[zCheckWithinGroup] [int] NULL,
	[Description] [nvarchar](1000) NULL,
	[AttributeDatabase] [nvarchar](100) NOT NULL,
	[AttributeTable] [nvarchar](100) NOT NULL,
	[Attribute] [nvarchar](100) NOT NULL,
	[SourceSystemIDColumn] [nvarchar](100) NULL,
	[MatchGroupIDColumn] [nvarchar](50) NULL,
	[WHEREClauseInput] [nvarchar](1000) NULL,
	[WHEREClause] [nvarchar](1000) NULL,
	[WHEREClauseExcel] [nvarchar](1000) NULL,
	[CheckTable] [nvarchar](100) NULL,
	[SelectAttributeTable] [nvarchar](max) NULL,
	[AttributeTableLastRefreshedOn] [smalldatetime] NULL,
	[SelectDistinctValues] [nvarchar](max) NULL,
	[SelectUnion] [nvarchar](max) NULL,
	[Comments] [nvarchar](1000) NULL,
	[ConsistencyCheckMadeByDecision] [bit] NULL,
	[ConsistencyCheckByProposedMatchGroup] [bit] NULL,
	[zActive] [bit] NULL,
	[MasterDifferentOrBlankCheck] [bit] NULL,
	[CaseSensitive] [bit] NULL,
	[ReportType] [nvarchar](50) NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[boaStatus] [int] NULL,
 CONSTRAINT [PK_ztAttributeConfig] PRIMARY KEY CLUSTERED 
(
	[AttributeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztAttributeConsistencySummary]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztAttributeConsistencySummary](
	[AttributeID] [int] NOT NULL,
	[TotalRecords] [int] NULL,
	[CompleteRecords] [int] NULL,
	[IncompleteRecords] [int] NULL,
	[ConsistentRecords] [int] NULL,
	[ConsistentRecordsSelect] [nvarchar](max) NULL,
	[ConsistentRecordsSelectExcel] [nvarchar](max) NULL,
	[InconsistentRecords] [int] NULL,
	[InconsistentRecordsSelect] [nvarchar](max) NULL,
	[InconsistentRecordsSelectExcel] [nvarchar](max) NULL,
	[ConsistentMatchGroups] [int] NULL,
	[InconsistentMatchGroups] [int] NULL,
	[InconsistentReportTableName] [nvarchar](200) NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[LastRefreshedOn] [smalldatetime] NULL,
 CONSTRAINT [PK_ztAttributeConsistencySummary] PRIMARY KEY CLUSTERED 
(
	[AttributeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztColumnOrderConfig]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztColumnOrderConfig](
	[zCheckWithinGroup] [nvarchar](50) NOT NULL,
	[AttributeID] [int] NULL,
	[MasterOrderID] [int] NOT NULL,
	[COLUMN_NAME] [sysname] NOT NULL,
	[COLUMN_NAMENew] [nvarchar](100) NULL,
	[DATA_TYPE] [nvarchar](128) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK__ztColumn__6E5D104CA8140F56] PRIMARY KEY CLUSTERED 
(
	[zCheckWithinGroup] ASC,
	[MasterOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__ztColumn__36C3C4D1E582B6F1] UNIQUE NONCLUSTERED 
(
	[zCheckWithinGroup] ASC,
	[COLUMN_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztConfigValueGroups]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztConfigValueGroups](
	[SourceSystem] [nvarchar](100) NOT NULL,
	[Area] [nvarchar](100) NOT NULL,
	[AttributeTable] [nvarchar](100) NULL,
	[Attribute] [nvarchar](100) NOT NULL,
	[CheckTable] [nvarchar](100) NULL,
	[Value] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[CountOfRecords] [int] NULL,
	[AttributeGroup] [int] NULL,
	[MappingAction] [nvarchar](100) NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[boaStatus] [int] NULL,
 CONSTRAINT [PK_ztConfigValueGroups] PRIMARY KEY CLUSTERED 
(
	[SourceSystem] ASC,
	[Attribute] ASC,
	[Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDataset]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDataset](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DataSet] [nvarchar](100) NULL,
	[Category] [nvarchar](100) NULL,
	[Description] [nvarchar](100) NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[boaStatus] [int] NULL,
 CONSTRAINT [PK_ztDataset] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetAvailableTables]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetAvailableTables](
	[TableID] [int] IDENTITY(1,1) NOT NULL,
	[DataSourceID] [nvarchar](100) NULL,
	[DatabaseName] [nvarchar](100) NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ztDatasetAvailableTables] PRIMARY KEY CLUSTERED 
(
	[TableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ztDatasetAvailableTables] UNIQUE NONCLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetJoinConditions]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetJoinConditions](
	[DatasetJoinConditionID] [int] IDENTITY(1,1) NOT NULL,
	[DatasetJoinID] [int] NOT NULL,
	[DataSetID] [int] NULL,
	[FromColumnID] [int] NOT NULL,
	[ToColumnID] [int] NOT NULL,
	[Operator] [varchar](10) NOT NULL,
	[ConditionOrder] [int] NOT NULL,
 CONSTRAINT [PK_ztDatasetJoinConditions] PRIMARY KEY CLUSTERED 
(
	[DatasetJoinConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetJoins]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetJoins](
	[DatasetJoinID] [int] IDENTITY(1,1) NOT NULL,
	[DatasetID] [int] NOT NULL,
	[FromTableID] [int] NOT NULL,
	[ToTableID] [int] NOT NULL,
	[JoinType] [varchar](20) NOT NULL,
	[AdditionalConditions] [varchar](500) NULL,
	[JoinOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DatasetJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetMaster]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetMaster](
	[DatasetID] [int] IDENTITY(1,1) NOT NULL,
	[DatasetName] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[Select_SQL] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[DatasetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DatasetName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetNamingConvention]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetNamingConvention](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Object] [nvarchar](50) NULL,
	[NamingConvention] [nvarchar](50) NULL,
 CONSTRAINT [PK_ztDatasetNamingConvention] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetSelectFields]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetSelectFields](
	[DatasetSelectFieldID] [int] IDENTITY(1,1) NOT NULL,
	[DatasetID] [int] NOT NULL,
	[DataSetTableId] [int] NULL,
	[SequenceNumber] [int] NOT NULL,
	[ColumnID] [int] NULL,
	[ExpressionText] [varchar](max) NULL,
	[Alias] [varchar](100) NULL,
	[IsVisible] [bit] NOT NULL,
	[LookUpTable] [nvarchar](100) NULL,
	[TargetSystemTable] [nvarchar](100) NULL,
	[TargetSystemTableFieldName] [nvarchar](100) NULL,
 CONSTRAINT [PK_ztDatasetSelectFields] PRIMARY KEY CLUSTERED 
(
	[DatasetSelectFieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetTableColumns]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetTableColumns](
	[ColumnID] [int] IDENTITY(1,1) NOT NULL,
	[TableID] [int] NOT NULL,
	[ColumnName] [varchar](50) NOT NULL,
	[DataType] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[AllowedForJoin] [bit] NULL,
	[DisplayName] [varchar](100) NULL,
	[isExpression] [bit] NULL,
 CONSTRAINT [PK_ztDatasetTableColumns] PRIMARY KEY CLUSTERED 
(
	[ColumnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDatasetTables]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDatasetTables](
	[DatasetTableID] [int] IDENTITY(1,1) NOT NULL,
	[DatasetID] [int] NOT NULL,
	[TableID] [int] NOT NULL,
	[Alias] [varchar](50) NULL,
	[TargetSystemTableName] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[DatasetTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztDataSource]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztDataSource](
	[DataSourceID] [uniqueidentifier] NOT NULL,
	[DataSourceName] [varchar](50) NOT NULL,
	[Database] [nvarchar](128) NULL,
	[UserID] [nvarchar](128) NULL,
	[Password] [nvarchar](255) NULL,
	[ConnectionTimeout] [int] NULL,
	[CommandTimeout] [int] NULL,
	[TrustedConnection] [bit] NULL,
	[DSN] [varchar](50) NULL,
	[Driver] [varchar](50) NULL,
	[DBQ] [varchar](50) NULL,
	[ConnectionString] [nvarchar](1024) NULL,
	[Active] [bit] NULL,
	[AuditDataSourceID] [uniqueidentifier] NULL,
	[boaStatus] [int] NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[LockedBy] [nvarchar](50) NULL,
	[LockedOn] [datetime] NULL,
	[DataSourceType] [int] NOT NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[Path] [nvarchar](255) NULL,
	[Port] [nvarchar](50) NULL,
	[CanRead] [bit] NULL,
	[CanWrite] [bit] NULL,
	[CanDelete] [bit] NULL,
	[Protected] [bit] NULL,
	[ServerAddress] [nvarchar](100) NULL,
	[DatabaseInstanceName] [nvarchar](128) NULL,
	[ProcedureParameterNamePrefix] [nvarchar](10) NULL,
	[DatabaseType] [int] NULL,
	[SystemViews] [bit] NOT NULL,
	[NetConnectionString] [nvarchar](1024) NULL,
	[boaGUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED 
(
	[DataSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_DataSource] UNIQUE NONCLUSTERED 
(
	[DataSourceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztGlobalXref]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztGlobalXref](
	[CheckTableName] [nvarchar](50) NOT NULL,
	[boaStatus] [int] NULL,
	[Active] [bit] NULL,
	[PageID] [nvarchar](50) NULL,
	[Comments] [nvarchar](200) NULL,
	[ValueField01] [nvarchar](50) NULL,
	[ValueField02] [nvarchar](50) NULL,
	[ValueField03] [nvarchar](50) NULL,
	[DescriptionTable01] [nvarchar](50) NULL,
	[DescriptionField01] [nvarchar](50) NULL,
	[DescriptionTableKeyField01] [nvarchar](50) NULL,
	[DescriptionTable02] [nvarchar](50) NULL,
	[DescriptionField02] [nvarchar](50) NULL,
	[DescriptionTableKeyField02] [nvarchar](50) NULL,
	[DescriptionTable03] [nvarchar](50) NULL,
	[DescriptionField03] [nvarchar](50) NULL,
	[DescriptionTableKeyField03] [nvarchar](50) NULL,
	[DescriptionLanguageField] [nvarchar](50) NULL,
	[DescriptionLanguageFieldValue] [nvarchar](50) NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[CreateCheckTableOn] [smalldatetime] NULL,
	[InsertSourceValuesOn] [smalldatetime] NULL,
	[AutoMapValuesOn] [smalldatetime] NULL,
	[MappedValues] [nvarchar](100) NULL,
	[GroupedRecords] [nvarchar](100) NULL,
	[RelevantGroupedRecords] [nvarchar](100) NULL,
	[CaseSensitive] [bit] NULL,
 CONSTRAINT [PK_ztGlobalXref] PRIMARY KEY CLUSTERED 
(
	[CheckTableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztGlobalXref_AllValuesByTarget]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztGlobalXref_AllValuesByTarget](
	[CheckTableName] [nvarchar](50) NOT NULL,
	[Target] [nvarchar](50) NOT NULL,
	[WaveProcessAreaObjectTargetID] [uniqueidentifier] NOT NULL,
	[zSource] [nvarchar](50) NOT NULL,
	[LegacyValue01] [nvarchar](50) NOT NULL,
	[TargetValue01] [nvarchar](50) NULL,
	[LegacyValue02] [nvarchar](50) NOT NULL,
	[TargetValue02] [nvarchar](50) NULL,
	[LegacyValue03] [nvarchar](50) NOT NULL,
	[TargetValue03] [nvarchar](50) NULL,
	[zRelevant] [bit] NULL,
	[SnapshotOn] [smalldatetime] NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[boaStatus] [int] NULL,
 CONSTRAINT [PK_ztGlobalXref_AllValuesByTarget] PRIMARY KEY CLUSTERED 
(
	[CheckTableName] ASC,
	[Target] ASC,
	[WaveProcessAreaObjectTargetID] ASC,
	[zSource] ASC,
	[LegacyValue01] ASC,
	[LegacyValue02] ASC,
	[LegacyValue03] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztGlobalXrefSourceSystem]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztGlobalXrefSourceSystem](
	[SourceSystem] [nvarchar](50) NOT NULL,
	[zSource] [nvarchar](50) NULL,
	[zSystem] [nvarchar](50) NULL,
	[SystemTypeID] [nvarchar](50) NULL,
	[SourceSystemID] [nvarchar](50) NOT NULL,
	[DescriptionLanguageValueBySystem] [nvarchar](50) NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[boaStatus] [int] NULL,
	[zActive] [bit] NULL,
 CONSTRAINT [PK_ztGlobalXrefSourceSystem] PRIMARY KEY CLUSTERED 
(
	[SourceSystem] ASC,
	[SourceSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztGlobalXrefTargetSystem]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztGlobalXrefTargetSystem](
	[TargetSystem] [nvarchar](50) NOT NULL,
	[zSource] [nvarchar](50) NULL,
	[zSystem] [nvarchar](50) NULL,
	[SystemTypeID] [nvarchar](50) NULL,
	[TargetSystemID] [nvarchar](50) NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[boaStatus] [int] NULL,
 CONSTRAINT [PK_ztGlobalXrefTargetSystem] PRIMARY KEY CLUSTERED 
(
	[TargetSystem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztParameter]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztParameter](
	[ParameterID] [int] IDENTITY(1,1) NOT NULL,
	[zCheckWithinGroup] [int] NULL,
	[SelectAllInconsistentReports] [nvarchar](max) NULL,
	[Comments] [nvarchar](1000) NULL,
	[LastAllRefreshOn] [smalldatetime] NULL,
	[zActive] [bit] NULL,
	[UnionReports] [bit] NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[boaStatus] [int] NULL,
 CONSTRAINT [PK_ztParameter] PRIMARY KEY CLUSTERED 
(
	[ParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztReportType]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztReportType](
	[Priority] [int] NULL,
	[ReportType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ztReportType] PRIMARY KEY CLUSTERED 
(
	[ReportType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztSnapshot]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztSnapshot](
	[zCheckWithinGroup] [int] NOT NULL,
	[SnapshotDate] [smalldatetime] NULL,
	[Comment] [nvarchar](1000) NULL,
 CONSTRAINT [PK_ztSnapshot] PRIMARY KEY CLUSTERED 
(
	[zCheckWithinGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztSystemType]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztSystemType](
	[SystemTypeID] [uniqueidentifier] NOT NULL,
	[SystemType] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[Vendor] [nvarchar](50) NULL,
	[VendorWebsite] [nvarchar](512) NULL,
	[Comments] [nvarchar](max) NULL,
	[CranSoftSupplied] [bit] NOT NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[boaStatus] [int] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[Version] [nvarchar](50) NULL,
	[ENTOTACloudReady] [bit] NULL,
	[ExternalReference] [nvarchar](max) NULL,
 CONSTRAINT [PK_ztSystemType] PRIMARY KEY CLUSTERED 
(
	[SystemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztSystemTypeTable]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztSystemTypeTable](
	[SystemTypeTableID] [uniqueidentifier] NOT NULL,
	[SystemTypeID] [uniqueidentifier] NULL,
	[TableName] [nvarchar](128) NULL,
	[Description] [nvarchar](128) NULL,
	[CranSoftSupplied] [bit] NOT NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[boaStatus] [int] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[SingleThreadDataExtract] [bit] NOT NULL,
	[CopyToTableName] [nvarchar](128) NULL,
	[CopyToSystemTypeTableID] [uniqueidentifier] NULL,
	[LookupTableType] [nvarchar](128) NULL,
	[LookupTableFieldID1] [uniqueidentifier] NULL,
	[LookupTableFieldID2] [uniqueidentifier] NULL,
	[LookupTableFieldID3] [uniqueidentifier] NULL,
	[LookupTableFieldID4] [uniqueidentifier] NULL,
	[LookupTableFieldID5] [uniqueidentifier] NULL,
	[LookupTableClientFieldID] [uniqueidentifier] NULL,
	[LookupTableLanguageFieldID] [uniqueidentifier] NULL,
	[LookupTableFieldValueID] [uniqueidentifier] NULL,
	[LookupTableWhereClause] [nvarchar](max) NULL,
	[DescriptionTableID] [uniqueidentifier] NULL,
	[DescriptionTableFieldID] [uniqueidentifier] NULL,
	[DescriptionTableKeyFieldID] [uniqueidentifier] NULL,
	[DescriptionTableClientFieldID] [uniqueidentifier] NULL,
	[DescriptionTableLanguageFieldID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ztSystemTypeTable] PRIMARY KEY CLUSTERED 
(
	[SystemTypeTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztSystemTypeTableField]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztSystemTypeTableField](
	[SystemTypeTableFieldID] [uniqueidentifier] NOT NULL,
	[SystemTypeTableID] [uniqueidentifier] NOT NULL,
	[Field] [nvarchar](128) NULL,
	[FieldOrder] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[HelpText] [nvarchar](max) NULL,
	[DataType] [nvarchar](50) NULL,
	[Length] [int] NULL,
	[Decimals] [int] NULL,
	[CranSoftSupplied] [bit] NOT NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[boaStatus] [int] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[KeyField] [bit] NULL,
	[ActiveForMappingDefault] [bit] NOT NULL,
	[RuleField] [bit] NULL,
	[FieldFormat] [nvarchar](50) NULL,
	[ApplicationScreen] [nvarchar](256) NULL,
	[Comment] [nvarchar](max) NULL,
	[Instructions] [nvarchar](max) NULL,
	[LookupTableSystemTypeTableID] [uniqueidentifier] NULL,
	[OriginalDataType] [nvarchar](50) NULL,
	[OriginalLength] [int] NULL,
	[OriginalDecimals] [int] NULL,
 CONSTRAINT [PK_ztSystemTypeTableField] PRIMARY KEY CLUSTERED 
(
	[SystemTypeTableFieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztUser]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztUser](
	[UserID] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[WindowsUserName] [nvarchar](255) NULL,
	[LanguageID] [uniqueidentifier] NULL,
	[StyleID] [uniqueidentifier] NULL,
	[DefaultPageID] [uniqueidentifier] NULL,
	[Password] [nvarchar](250) NULL,
	[PasswordConfirm] [nvarchar](250) NULL,
	[PasswordLastChanged] [smalldatetime] NOT NULL,
	[Telephone] [varchar](50) NULL,
	[EMailAddress] [nvarchar](256) NULL,
	[LocaleID] [int] NULL,
	[Anonymous] [bit] NULL,
	[FailedLoginAttempts] [int] NOT NULL,
	[LastLoginAttempt] [datetime] NULL,
	[boaStatus] [int] NULL,
	[AddedBy] [nvarchar](50) NULL,
	[AddedOn] [smalldatetime] NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ChangedOn] [smalldatetime] NULL,
	[LockedBy] [nvarchar](50) NULL,
	[LockedOn] [datetime] NULL,
	[ExpirationDate] [smalldatetime] NULL,
	[AddedVia] [nvarchar](50) NULL,
	[ChangedVia] [nvarchar](50) NULL,
	[TelephoneExtension] [varchar](10) NULL,
	[LastSuccessfulLogin] [datetime] NOT NULL,
	[HighlightCurrentColumn] [int] NOT NULL,
	[boaLockType] [int] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztValueExclusions]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztValueExclusions](
	[zCheckWithinGroup] [nvarchar](50) NOT NULL,
	[ValueToBeExcluded] [nvarchar](50) NOT NULL,
	[zActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[zCheckWithinGroup] ASC,
	[ValueToBeExcluded] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[zCheckWithinGroup] ASC,
	[ValueToBeExcluded] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztWebAppCatalog]    Script Date: 4/23/2026 12:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ztWebAppCatalog](
	[WebAppID] [uniqueidentifier] NOT NULL,
	[CatalogID] [uniqueidentifier] NOT NULL,
	[Priority] [int] NOT NULL,
	[Phrase] [nvarchar](250) NOT NULL,
	[PhraseOut] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_WebAppCatalog] PRIMARY KEY CLUSTERED 
(
	[WebAppID] ASC,
	[CatalogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ztAttributeConfig] ADD  CONSTRAINT [DF_ztAttributeConfig_InconsistencyMadeByDecision]  DEFAULT ((0)) FOR [ConsistencyCheckMadeByDecision]
GO
ALTER TABLE [dbo].[ztAttributeConfig] ADD  CONSTRAINT [DF_ztAttributeConfig_InconsistencyByProposedMatchGroup]  DEFAULT ((0)) FOR [ConsistencyCheckByProposedMatchGroup]
GO
ALTER TABLE [dbo].[ztAttributeConfig] ADD  CONSTRAINT [DF_ztAttributeConfig_zActive]  DEFAULT ((1)) FOR [zActive]
GO
ALTER TABLE [dbo].[ztAttributeConfig] ADD  CONSTRAINT [DF_ztAttributeConfig_MasterCheck]  DEFAULT ((0)) FOR [MasterDifferentOrBlankCheck]
GO
ALTER TABLE [dbo].[ztAttributeConfig] ADD  CONSTRAINT [DF_ztAttributeConfig_CaseSensitive]  DEFAULT ((0)) FOR [CaseSensitive]
GO
ALTER TABLE [dbo].[ztColumnOrderConfig] ADD  CONSTRAINT [DF_ztColumnOrderConfig_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[ztDatasetAvailableTables] ADD  CONSTRAINT [DF_ztDatasetAvailableTables_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ztDatasetJoinConditions] ADD  CONSTRAINT [DF_ztDatasetJoinConditions_Operator]  DEFAULT ('=') FOR [Operator]
GO
ALTER TABLE [dbo].[ztDatasetJoinConditions] ADD  CONSTRAINT [DF_ztDatasetJoinConditions_ConditionOrder]  DEFAULT ((1)) FOR [ConditionOrder]
GO
ALTER TABLE [dbo].[ztDatasetJoins] ADD  DEFAULT ((1)) FOR [JoinOrder]
GO
ALTER TABLE [dbo].[ztDatasetMaster] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ztDatasetSelectFields] ADD  CONSTRAINT [DF_ztDatasetSelectFields_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
GO
ALTER TABLE [dbo].[ztDatasetTableColumns] ADD  CONSTRAINT [DF_ztDatasetTableColumns_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[ztDatasetTableColumns] ADD  CONSTRAINT [DF_ztDatasetTableColumns_AllowedforJoin]  DEFAULT ((0)) FOR [AllowedForJoin]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF__DataSourc__DataS__276EDEB3]  DEFAULT (newid()) FOR [DataSourceID]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF__DataSourc__Trust__29572725]  DEFAULT ((0)) FOR [TrustedConnection]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF__DataSourc__Activ__2A4B4B5E]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF__DataSourc__cranS__2B3F6F97]  DEFAULT ((0)) FOR [boaStatus]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF_DataSource_DataSourceType]  DEFAULT ((1)) FOR [DataSourceType]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF_DataSource_CanRead]  DEFAULT ((1)) FOR [CanRead]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF_DataSource_CanWrite]  DEFAULT ((1)) FOR [CanWrite]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF_DataSource_CanDelete]  DEFAULT ((1)) FOR [CanDelete]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF_DataSource_Protected]  DEFAULT ((0)) FOR [Protected]
GO
ALTER TABLE [dbo].[ztDataSource] ADD  CONSTRAINT [DF_dbo_DataSource_SystemViews]  DEFAULT ((0)) FOR [SystemViews]
GO
ALTER TABLE [dbo].[ztGlobalXref] ADD  CONSTRAINT [DF_ztGlobalXref_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[ztGlobalXref] ADD  CONSTRAINT [DF_ztGlobalXref_CaseSensitive]  DEFAULT ((0)) FOR [CaseSensitive]
GO
ALTER TABLE [dbo].[ztParameter] ADD  CONSTRAINT [DF_ztParameter_zActive]  DEFAULT ((1)) FOR [zActive]
GO
ALTER TABLE [dbo].[ztParameter] ADD  CONSTRAINT [DF_ztParameter_UnionReports]  DEFAULT ((1)) FOR [UnionReports]
GO
ALTER TABLE [dbo].[ztValueExclusions] ADD  CONSTRAINT [DF_ztValueExclusions_zActive]  DEFAULT ((1)) FOR [zActive]
GO
ALTER TABLE [dbo].[ztAttributeConsistencySummary]  WITH CHECK ADD  CONSTRAINT [FK_ztAttributeConsistencySummary_ztAttributeConfig] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[ztAttributeConfig] ([AttributeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ztAttributeConsistencySummary] CHECK CONSTRAINT [FK_ztAttributeConsistencySummary_ztAttributeConfig]
GO
