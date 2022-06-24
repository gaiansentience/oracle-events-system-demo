--drop schema objects before redeploy
prompt dropping views
drop view customer_event_tickets_v;
drop view customer_event_ticket_base_v;
drop view tickets_available_all_v;
drop view tickets_available_reseller_v;
drop view tickets_available_venue_v;
drop view event_ticket_prices_v;

--these views are identical, reseller_ticket_assignment is currently in use
--used to troubleshoot xml verify view anomaly
drop view event_ticket_assignment_v;
drop view reseller_ticket_assignment_v;


drop view event_ticket_groups_v;
drop view events_v;
drop view venue_events_v;
drop view venue_event_base_v;
drop view venues_summary_v; 
drop view event_reseller_performance_v;
drop view venue_reseller_performance_v;
drop view venue_reseller_commission_v;
drop view venues_v;
drop view resellers_v;
prompt views dropped