--create random sales for the event series from resellers and directly from the venue
--use show_all_event_series_tickets_available to see purchases (test.05.00.01)
set serveroutput on;

declare
cursor c is
select e.event_id 
from 
    venues v 
    join events e
        on v.venue_id = e.venue_id
where 
    v.venue_name = 'City Stadium'
    and e.event_name = 'Hometown Hockey League';

begin

for r in c loop

    events_test_data_api.create_event_ticket_sales(r.event_id);

end loop;

end;