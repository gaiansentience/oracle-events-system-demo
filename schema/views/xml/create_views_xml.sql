--create views for the events system
prompt creating views for xml web services
@@view.event_ticket_groups_v_xml.sql;
@@view.event_series_ticket_groups_v_xml.sql;

@@view.event_ticket_assignment_v_xml.sql;

@@view.event_ticket_prices_v_xml.sql;
@@view.event_series_ticket_prices_v_xml.sql;

@@view.tickets_available_all_v_xml.sql;
@@view.tickets_available_venue_v_xml.sql;
@@view.tickets_available_reseller_v_xml.sql;

@@view.customer_event_tickets_v_xml.sql;

@@view.all_resellers_v_xml.sql;
@@view.resellers_v_xml.sql;

@@view.all_venues_v_xml.sql;
@@view.venues_v_xml.sql;
@@view.venues_summary_v_xml.sql;

@@view.venue_event_series_v_xml.sql;
@@view.venue_events_v_xml.sql;
@@view.events_v_xml.sql;

@verify_views\create_views_xml_verify.sql;

prompt events system xml api views created

