--create random sales for the event series from resellers and directly from the venue
--use show_all_event_series_tickets_available to see purchases (test.05.00.01)
set serveroutput on;

declare
    l_venue_id number;
    l_event_series_id number;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Hometown Hockey League');

    events_test_data_api.create_event_series_ticket_sales(l_event_series_id);


end; 