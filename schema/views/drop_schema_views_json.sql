--drop schema objects before redeploy
prompt dropping views
drop view event_ticket_groups_from_json_v;
drop view event_ticket_groups_json_v;

drop view reseller_ticket_group_assignment_json_v;
drop view reseller_ticket_group_assignment_from_json_v;

drop view event_ticket_prices_from_json_v;
drop view event_ticket_prices_json_v;

drop view customer_event_tickets_from_json_v;
drop view customer_event_tickets_json_v;

drop view all_resellers_from_json_v;
drop view all_resellers_json_v;

drop view resellers_from_json_v;
drop view resellers_json_v;

drop view all_venues_from_json_v;
drop view all_venues_json_v;

drop view venues_from_json_v;
drop view venues_json_v;

drop view venues_summary_from_json_v;
drop view venues_summary_json_v;

drop view venue_events_from_json_v;
drop view venue_events_json_v;

drop view events_from_json_v;
drop view events_json_v;
prompt views dropped