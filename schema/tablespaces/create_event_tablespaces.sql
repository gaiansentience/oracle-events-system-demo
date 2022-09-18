--create tablespaces for event_system data and indexes

--on unix system
create tablespace event_data DATAFILE '/u01/app/oracle/oradata/ORCLCDB/orcl/event_data01.dbf' SIZE 100M
extent management LOCAL AUTOALLOCATE;

ALTER TABLESPACE event_data
   ADD DATAFILE '/u01/app/oracle/oradata/ORCLCDB/orcl/event_data02.dbf' SIZE 100M;

create tablespace event_index DATAFILE '/u01/app/oracle/oradata/ORCLCDB/orcl/event_index01.dbf' SIZE 150M
extent management LOCAL AUTOALLOCATE;

ALTER TABLESPACE event_index
   ADD DATAFILE '/u01/app/oracle/oradata/ORCLCDB/orcl/event_index02.dbf' SIZE 150M;
   
--on xe windows system   
create tablespace event_data DATAFILE 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_data01.DBF' SIZE 100M
extent management LOCAL AUTOALLOCATE;

ALTER TABLESPACE event_data
   ADD DATAFILE 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_data02.DBF' SIZE 100M;

create tablespace event_index DATAFILE 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_index01.DBF' SIZE 150M
extent management LOCAL AUTOALLOCATE;

ALTER TABLESPACE event_index
   ADD DATAFILE 'C:\ORACLE\XE\ORADATA\XE\XEPDB1\event_index02.DBF' SIZE 150M;


alter user event_system
default tablespace event_data
 quota unlimited on event_data
 quota unlimited on event_index
container = current;
