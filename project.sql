--inserting all flat files into a table named TEMP
use master 
go

EXEC sp_configure 'show advanced options', 1    
	RECONFIGURE 
	GO
	
EXEC SP_CONFIGURE 'xp_cmdshell', 1 
	RECONFIGURE 
	GO

CREATE DATABASE SQL_PROJECT
USE TEMPDB
	GO

IF OBJECT_ID ('#TEMP') IS NOT NULL 
	DROP TABLE #TEMP
	GO

CREATE TABLE #TEMP(ID INT IDENTITY, ITEM VARCHAR(3000))

INSERT INTO #TEMP

EXEC xp_cmdshell 'dir /B "C:\Users\HP\Desktop\sql_proj\Flat_files"';
select * from #TEMP

CREATE DATABASE SQL_PROJECT
USE SQL_PROJECT
GO

CREATE SCHEMA project1
DECLARE @schema_name VARCHAR(100)
SET @schema_name='project1'
-------------------------------------------------------------------------------------------------
--inserting data present in each flat file into a table named temp, one at a time.

DECLARE @a INT=1

	WHILE @a<(SELECT COUNT(*) FROM #TEMP)

	BEGIN
         if object_id('project') is not null
		 drop table project

		CREATE TABLE PROJECT (ID INT IDENTITY, ITEM VARCHAR (5000))

		DECLARE @FILENAME VARCHAR(100)=''
	
		SET @FILENAME = ( SELECT ITEM FROM #TEMP WHERE ID=@a ) 
	
		DECLARE @SQL NVARCHAR(MAX);
	
		SET @SQL= N'INSERT PROJECT( ITEM )  SELECT VALUE FROM OPENROWSET
				                 ( BULK ''C:\Users\HP\Desktop\sql_proj1\Flat_Files\'+ @FILENAME+''', 
				                   FORMATFILE = ''C:\Users\HP\Desktop\Pad_bulk_import.fmt'') a';

    		EXEC SYS.SP_EXECUTESQL @SQL;

select * from project
-------------------------------------------------------------------------------------------------------
--omitting bothersome special characters that might have appeared in the flatfile(data cleaning)
declare @i int=1

while @i<=(select count(*) from project)
  begin
  Declare @p int, @string varchar(200) 
  select @string = item from project where id=@i
  Select @p = PATINDEX ('%[^0-9a-zA-Z@,]%',@string)
 print @p
 While @p > 0
 Begin
		Select @string = replace(@string,substring(@string,@p,1),'')
		Select @p = PATINDEX ('%[^0-9a-zA-Z@,-]%',@string)
		print @string
 End
  update project set item=@string where id=@i
  set @i=@i+1
  End

 select * from project
--------------------------------------------------------------------------------------------
--table creation, with name of the flat file as table name.
declare @item nvarchar(max), 
        @colNames nvarchar(max),
        @sql1 nvarchar(max),
        @tname nvarchar(100),
        @dot int

set @dot=charindex('.',@FILENAME)
set @tname=substring(@FILENAME,0,@dot)
print @tname

SELECT @item=item FROM project WHERE id=1;

WITH ColumnList AS (
    SELECT value AS column_name
    FROM STRING_SPLIT(@item, ',')
)

SELECT @colNames = STRING_AGG(column_name + ' varchar(100)', ', ') from ColumnList
print @colNames

SET @sql1 = 'CREATE TABLE ' + @schema_name+'.'+ @tname + ' (' + @colNames + ')'

PRINT @sql1

EXEC sp_executesql @sql1
-------------------------------------------------------------------------
--data insertion into resepective tables
declare @item_value nvarchar(max), 
        @values nvarchar(max),
        @sql2 nvarchar(max),
		@x int=2

while @x<=(select count(*) from project)
begin
 select @item_value=item from project where id=@x;
 With valuesList as(
   select value AS val
    from STRING_SPLIT(@item_value, ',')
	)

SELECT @values = STRING_AGG(''''+val+'''', ', ') from valuesList
print @values
SET @sql2 = 'Insert '+@schema_name + '.' + @tname+' values (' + @values + ')'

PRINT @sql2

EXEC sp_executesql @sql2

 set @x=@x+1
end
 set @a=@a+1
end

-------------------------------------------------------------------------------------------
select * from project1.addresstype
select * from project1.department_name
select * from project1.emp
select * from project1.loan


