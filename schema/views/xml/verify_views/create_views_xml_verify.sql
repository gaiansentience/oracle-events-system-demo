prompt creating verification views for xml web services

@@view.event_ticket_groups_v_xml_verify.sql;

--these views are identical, reseller_ticket_assignment is currently in use
--used to troubleshoot xml verify view anomaly
@@view.event_ticket_assignment_v_xml_verify.sql;
@@view.reseller_ticket_assignment_v_xml_verify.sql;

@@view.event_ticket_prices_v_xml_verify.sql;

@@view.tickets_available_all_v_xml_verify.sql;

@@view.tickets_available_venue_v_xml_verify.sql;

@@view.tickets_available_reseller_v_xml_verify.sql;

@@view.customer_event_tickets_v_xml_verify.sql;

@@view.all_resellers_v_xml_verify.sql;

@@view.resellers_v_xml_verify.sql;

@@view.all_venues_v_xml_verify.sql;

@@view.venues_v_xml_verify.sql;

@@view.venues_summary_v_xml_verify.sql;

@@view.venue_events_v_xml_verify.sql;

@@view.events_v_xml_verify.sql;

prompt events system xml verification views created