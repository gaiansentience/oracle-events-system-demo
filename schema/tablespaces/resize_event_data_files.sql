

--resize datafiles on unix system (developer days vmbox)
/*
alter database datafile '/u01/app/oracle/oradata/ORCLCDB/orcl/event_data01.dbf'
   resize 200M;
   
alter database datafile '/u01/app/oracle/oradata/ORCLCDB/orcl/event_data02.dbf'
   resize 200M;   
   
alter database datafile '/u01/app/oracle/oradata/ORCLCDB/orcl/event_index01.dbf'
   resize 300M;      
   
alter database datafile '/u01/app/oracle/oradata/ORCLCDB/orcl/event_index02.dbf'
   resize 300M;      
*/
   
--resize datafiles on windows system   
/*
alter database datafile 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_data01.DBF'   
    resize 200M;
    
alter database datafile 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_data02.DBF'   
    resize 200M;
    
alter database datafile 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_index01.DBF'   
    resize 300M;
    
alter database datafile 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_index02.DBF'   
    resize 300M;    
*/