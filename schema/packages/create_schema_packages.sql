--create package api for the events system
prompt creating api packages for events b2b system
prompt views need to be deployed before running this script
@@events_api.spc;
@@Events_Api.bdy;
prompt creating reporting api package
@@events_report_api.spc;
@@events_report_api.bdy;
prompt creating testing api package
@@events_test_data_api.spc;
@@events_test_data_api.bdy;
prompt events system core api objects created
prompt creating objects for json web services
@@events_json_api.spc;
@@events_json_api.bdy;
prompt creating objects for xml web services
@@util_xmldom_helper.spc;
@@util_xmldom_helper.bdy;
@@events_xml_api.spc;
@@events_xml_api.bdy;
prompt events system api packages created