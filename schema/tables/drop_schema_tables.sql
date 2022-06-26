prompt dropping event_system tables
drop table tickets purge;
drop table ticket_sales purge;
drop table ticket_assignments purge;
drop table ticket_groups purge;
drop table events purge;
drop sequence event_series_id_seq;
drop table venues purge;
drop table resellers purge;
drop table customers purge;
drop table error_log purge;
prompt event_system tables dropped