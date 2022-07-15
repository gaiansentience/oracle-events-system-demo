--drop schema objects before redeploy
prompt dropping views
drop view customer_event_series_tickets_v;
drop view customer_event_tickets_v;
drop view customer_event_ticket_base_v;

drop view customer_event_series_purchase_v;
drop view customer_event_purchase_v;
drop view customer_event_purchase_base_v;

drop view tickets_available_series_reseller_v;
drop view tickets_available_series_venue_v;
drop view tickets_available_series_all_v;

drop view tickets_available_all_v;
drop view tickets_available_reseller_v;
drop view tickets_available_venue_v;

drop view event_series_ticket_prices_v;
drop view event_ticket_prices_v;

drop view event_series_ticket_assignment_v;
drop view event_ticket_assignment_v;

drop view event_series_ticket_groups_v;
drop view event_ticket_groups_v;
drop view events_v;
drop view event_series_v;
drop view venue_event_series_v;
drop view venue_events_v;
drop view venue_event_series_base_v;
drop view venue_event_base_v;
drop view venues_summary_v; 
drop view event_reseller_performance_v;
drop view venue_reseller_performance_v;
drop view venue_reseller_commission_v;
drop view venues_v;
drop view resellers_v;
drop view customers_v;
prompt views dropped