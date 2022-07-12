prompt creating views for json web services

@@view.customers_v_json.sql;

@@view.all_resellers_v_json.sql;
@@view.resellers_v_json.sql;

@@view.all_venues_v_json.sql;
@@view.all_venues_summary_v_json.sql;

@@view.venues_v_json.sql;
@@view.venues_summary_v_json.sql;

@@view.venue_event_series_v_json.sql;
@@view.venue_events_v_json.sql;

@@view.event_series_v_json.sql;
@@view.events_v_json.sql;

@@view.event_ticket_groups_v_json.sql;
@@view.event_series_ticket_groups_v_json.sql;

@@view.event_series_ticket_assignment_v_json.sql;
@@view.event_ticket_assignment_v_json.sql;

@@view.event_ticket_prices_v_json.sql;
@@view.event_series_ticket_prices_v_json.sql;

@@view.tickets_available_all_v_json.sql;
@@view.tickets_available_venue_v_json.sql;
@@view.tickets_available_reseller_v_json.sql;

@@view.tickets_available_series_all_v_json.sql;
@@view.tickets_available_series_venue_v_json.sql;
@@view.tickets_available_series_reseller_v_json.sql;

@@view.customer_event_tickets_v_json.sql;
@@view.customer_event_series_tickets_v_json.sql;

@verify_views\create_views_json_verify.sql;
prompt events system json api views created

