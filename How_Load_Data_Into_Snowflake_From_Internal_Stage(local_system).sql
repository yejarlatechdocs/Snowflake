--How to bulk load the data from internal Storages (local file System)  into snowflake data base :

--We can perform bulk loading from local file system into snowflake in two steps.

--Step# 1 :  Upload (i.e. stage) one or more data files to a Snowflake stage (named internal stage or table/user stage) using the PUT command.
--Step# 2 :  Use the COPY INTO <table> command to load the contents of the staged file(s) into a Snowflake database table.

--Demo :

//	1. Install snowSQL from  snowflake web UI
//	2. Create sample data file and place into local system (i.e. C drive)
//	3. Create table structure in snowflake by referring feed file
//	4. Create file format with reference of feed file
//	5. Create named internal Stage
//	6. Put file into internal stage by executing below command via snowsql command line
//	7. Load the data into snowflake table by using COPY INTO
	
	

// Install snowsql in windows system
//		 a. Download snowsql by navigating below path
//           (download from snowflake web UI click on help-->download-->cli client-->window 64 bit)
//
//		 b. Once downloaded snowsql.exe double click and follow the next steps and finish the installation
//		 c. Once the installation completed, open command prompt type below command to connect snowflake.
//		 d. snowsql -a <account name-will get in snowflake web url > -u <username> 
//		           then it will ask password enter your password so that it will connect to snowflake.
//		 e. If you don't want enter every time credentials as one time set up you can configuration by following belwo steps.
//		 f. Open run command (windows+R) and type   %USERPROFILE%\.snowsql\
//		 g. Then open config file and update the below values as one time, so that no need to provide credentials every time while logging in.
//	
//	
//					[connections.my_example_connection]
//					 accountname = xy12345.eu-central-1
//					 username = scott
//					 password = xxxxxxxxxxxxxxxxxxxx
//					 dbname = mydb
//					 schemaname = public
//					 warehousename = mywh
//					
//		  h. Then save the config file and open command prompt and type snowsql so that the snowsql terminal will open.
//	
//	           Refer the link for more  details -https://docs.snowflake.com/en/user-guide/snowsql-start.html
//					
//
// Make it reday the sample data which is planing to load into snowflake in (C/D/E drive.)
	

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE DEMO_WH;
USE DATABASE DEMO_DB;

//Create table structure in snowflake by referring feed file            
            
CREATE TABLE customer (
					ID 	     STRING NOT NULL,
					Name 	 STRING ,
					Address	 STRING ,
					City 	 STRING,
					PostCode NUMBER,
					State 	 STRING,
					Company  STRING,
					Contact	 STRING 
						);
						

//Create file format with reference of feed file

create or replace file format my_csv_format
		type = csv
		field_delimiter = '|'
		skip_header = 1
		null_if = ('NULL', 'null')
		empty_field_as_null = true
		compression = gzip;
	

// Create named internal Stage
 
       create or replace stage my_stage
		file_format = my_csv_format;

// if you want provide file format on the fly we can create named stage below as well.

       create or replace stage my_stage
       file_format = (type = 'CSV' field_delimiter = '|' skip_header = 1);
	
//  Put file into internal stage by executing below command via snowsql command line
	
//    syntax:
//    
//		PUT file://<path_to_file>/<filename> internalStage
//		[ PARALLEL = <integer> ]
//		[ AUTO_COMPRESS = TRUE | FALSE ]
//		[ SOURCE_COMPRESSION = AUTO_DETECT | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE ]
//		[ OVERWRITE = TRUE | FALSE ]
	
	
       PUT file://C:\Users\Yejarla\customer.csv @DEMO_DB.PUBLIC.my_stage;
	

      COPY INTO customer 
       FROM @my_stage;
       
	
//  Data successfully loaded into snowflake table ;  

Select * from customer;
