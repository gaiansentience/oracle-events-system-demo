--drop schema objects before redeploy
prompt dropping api packages
drop package events_test_data_api;

drop package events_xml_api;
drop package util_xmldom_helper;
drop package events_json_api;

drop package venue_api;
drop package reseller_api;
drop package customer_api;

drop package event_sales_api;
drop package event_tickets_api;
drop package event_setup_api;
drop package event_api;
drop package util_error_api;
drop package util_types;
prompt api packages dropped