--drop schema objects before redeploy
@@drop_schema_packages.sql;
prompt dropping tables
drop table ticket_sales purge;
drop table ticket_assignments purge;
drop table ticket_groups purge;
drop table events purge;
drop table venues purge;
drop table resellers purge;
drop table customers purge;
drop table error_log purge;