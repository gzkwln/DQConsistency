# DQConsistency

README
WRKDQHARMONIZE SKPv2   
/*======================================================

1- Run files 110-130 in SQL 

2- SKP > Catalog > Systems > <System used for Construct> > Connections > Create Connections -- usage Profiling, Construct

3- SKP > Catalog > Systems > add Datastore WRKDQHARMONIZE linked to database WRKDQHARMONIZE 

4- Syniti Construct > System Administration > Data Sources 
	-- Add new DataSource with file 200 via excel integration - and set the created connection in Connection ID and Connector ID 
	-- Once created data source, validate, and add SKP Datastore (WRKDQHARMONIZE) to vertical view and test connection

5- Syniti Construct > System Administration > WebApps -- Add new WebApp with Excel Integration - File 210 - Validate the WebApp. Remove the Static Page that has been created automatically.

6- Syniti Construct > System Administration > WebApps > DQ Consistency > Menu -- Select new WebApp and upload Excel file 220 via Excel Integration. 

7- Syniti Construct > System Administration > WebApps > DQ Consistency > Pages -- Select new WebApp > Pages and upload Excel file 230 via Excel Integration. 

8- Syniti Construct > System Administration > WebApps > Webapp Catalog -- upload file 240 via Excel Integration.

9- Admin > Translations > Catalogs -- upload file 250 Catalog via Excel Integration.

10- Admin > Translations > Catalogs > DQOps Catalog Phrases - upload file 255 Catalog Phrases via Excel Integration. 

11- Syniti Construct > System Administration > WebApps > DQ Consistency > Groups -- upload file 260 Groups via Excel Integration.

12- Syniti Construct > System Administration > WebApps > DQ Consistency > Vertical View > Import/Export > choose the corresponding section for files 270 to 310, e.g. Page Column- upload file 270 Page Column via Excel Integration. do the same for the rest of the files. 

13- Clear Cache once done


====================================================== */
