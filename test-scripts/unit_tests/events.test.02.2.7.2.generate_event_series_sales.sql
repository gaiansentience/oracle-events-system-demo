--create random sales for the event series from resellers and directly from the venue
--use show_all_event_series_tickets_available to see purchases (test.05.00.01)
set serveroutput on;

declare
    l_event_series_id number;
begin

    select max(e.event_id) into l_event_series_id 
    from events e
    where e.event_name = 'Hometown Hockey League';


    events_test_data_api.create_event_series_ticket_sales(l_event_series_id);


end; 