--create package api for the events system
prompt creating api packages for events b2b system
prompt views need to be deployed before running this script
@@EVENTS_API.spc;
@@EVENTS_API.bdy;
prompt creating reporting api package
@@EVENTS_REPORT_API.spc;
@@EVENTS_REPORT_API.bdy;
prompt creating testing api package
@@EVENTS_TEST_DATA_API.spc;
@@EVENTS_TEST_DATA_API.bdy;
prompt events system core api objects created
prompt creating objects for json web services
@@EVENTS_JSON_API.spc;
@@EVENTS_JSON_API.bdy;
prompt events system api packages created

