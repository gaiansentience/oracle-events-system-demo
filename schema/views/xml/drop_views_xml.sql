--drop schema objects before redeploy
prompt dropping xml views
drop view event_ticket_groups_xml_v;

drop view reseller_ticket_assignment_xml_v;

drop view tickets_available_all_xml_v;

drop view tickets_available_reseller_xml_v;

drop view tickets_available_venue_xml_v;

drop view event_ticket_prices_xml_v;

drop view customer_event_tickets_xml_v;

drop view all_resellers_xml_v;

drop view resellers_xml_v;

drop view all_venues_xml_v;

drop view venues_xml_v;

drop view venues_summary_xml_v;

drop view venue_events_xml_v;

drop view events_xml_v;
prompt xml views dropped