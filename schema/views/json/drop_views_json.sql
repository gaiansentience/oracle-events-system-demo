prompt dropping json views
@verify_views\drop_views_json_verify.sql;

drop view customer_event_series_tickets_v_json;
drop view customer_event_tickets_v_json;
drop view customer_event_series_purchases_v_json;
drop view customer_event_purchases_v_json;
drop view customer_event_series_v_json;
drop view customer_events_v_json;

drop view tickets_available_series_all_v_json;
drop view tickets_available_series_reseller_v_json;
drop view tickets_available_series_venue_v_json;
drop view tickets_available_all_v_json;
drop view tickets_available_reseller_v_json;
drop view tickets_available_venue_v_json;

drop view event_series_ticket_prices_v_json;
drop view event_ticket_prices_v_json;

drop view event_series_ticket_assignment_v_json;
drop view event_ticket_assignment_v_json;

drop view event_series_ticket_groups_v_json;
drop view event_ticket_groups_v_json;

drop view all_venues_v_json;
drop view all_venues_summary_v_json;
drop view venues_v_json;
drop view venues_summary_v_json;

drop view venue_event_series_v_json;
drop view venue_events_v_json;

drop view event_series_v_json;
drop view events_v_json;

drop view all_resellers_v_json;
drop view resellers_v_json;
drop view customers_v_json;
prompt json views dropped