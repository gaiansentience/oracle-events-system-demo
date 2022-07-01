--create random sales for the event series from resellers and directly from the venue
--use show_all_event_series_tickets_available to see purchases (test.05.00.01)
set serveroutput on;

declare
cursor c is
select e.event_id from events e
where e.event_name = 'Hometown Hockey League';

begin

for r in c loop

    events_test_data_api.create_event_ticket_sales(r.event_id);

end loop;

end;