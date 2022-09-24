

--resize datafiles on unix EE19 system (developer days vmbox)
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
   
--resize datafiles on windows XE21 system   
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

--resize datafiles on windows VirtualBox EE21 system   
/*
alter database datafile 'O:\ORACLE\EE\ORADATA\ORCLCDB\ORCL\EVENT_DATA01.DBF'   
    resize 500M;
    
alter database datafile 'O:\ORACLE\EE\ORADATA\ORCLCDB\ORCL\EVENT_DATA02.DBF'   
    resize 500M;
    
alter database datafile 'O:\ORACLE\EE\ORADATA\ORCLCDB\ORCL\EVENT_INDEX01.DBF'   
    resize 500M;
    
alter database datafile 'O:\ORACLE\EE\ORADATA\ORCLCDB\ORCL\EVENT_INDEX02.DBF'   
    resize 500M;    
*/