--drop schema objects before redeploy
prompt dropping api packages
drop package events_json_api;
drop package events_test_data_api;
drop package events_report_api;
drop package events_api;
@@drop_schema_views_json.sql;
@@drop_schema_views.sql;
prompt api packages dropped