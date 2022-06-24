--drop schema objects before redeploy
prompt dropping xml views

@verify_views\drop_views_xml_verify.sql;

drop view event_ticket_groups_v_xml;

--these views are identical, reseller_ticket_assignment is currently in use
--used to troubleshoot xml verify view anomaly
drop view event_ticket_assignment_v_xml;
drop view reseller_ticket_assignment_v_xml;

drop view tickets_available_all_v_xml;

drop view tickets_available_reseller_v_xml;

drop view tickets_available_venue_v_xml;

drop view event_ticket_prices_v_xml;

drop view customer_event_tickets_v_xml;

drop view all_resellers_v_xml;

drop view resellers_v_xml;

drop view all_venues_v_xml;

drop view venues_v_xml;

drop view venues_summary_v_xml;

drop view venue_events_v_xml;

drop view events_v_xml;
prompt xml views dropped