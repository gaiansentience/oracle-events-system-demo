prompt creating api packages for events b2b system
prompt views need to be deployed before running this script
@@util_types.spc;
prompt creating error logging package
@@util_error_api.spc;
@@util_error_api.bdy;
prompt creating core business logic api packages

@@customer_api.spc;
@@reseller_api.spc;
@@venue_api.spc;
@@event_api.spc;
@@event_setup_api.spc;
@@event_tickets_api.spc;
@@event_sales_api.spc;

@@customer_api.bdy;
@@reseller_api.bdy;
@@venue_api.bdy;
@@event_api.bdy;
@@event_setup_api.bdy;
@@event_tickets_api.bdy;
@@event_sales_api.bdy;


prompt events system core api objects created
prompt creating objects for json web services
@@events_json_api.spc;
@@events_json_api.bdy;

prompt creating objects for xml web services
@@util_xmldom_helper.spc;
@@util_xmldom_helper.bdy;
@@events_xml_api.spc;
@@events_xml_api.bdy;

prompt creating testing api package
@@events_test_data_api.spc;
@@events_test_data_api.bdy;

prompt events system api packages created