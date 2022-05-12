--drop schema objects before redeploy
prompt dropping views
drop view venue_events_v;
drop view venues_summary_v; 
drop view venue_reseller_performance_v;
drop view venue_reseller_commission_v;
drop view event_ticket_groups_v;
drop view reseller_ticket_group_availability_v;
drop view tickets_available_all_v;
drop view tickets_available_reseller_v;
drop view tickets_available_venue_v;
drop view customer_event_tickets_v;

prompt views dropped