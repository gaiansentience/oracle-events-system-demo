--create random sales for the event from resellers and directly from the venue
--use show_all_event_tickets_available to see purchases (test.05.00.01)
set serveroutput on;

declare
v_event_id number;
begin

select event_id into v_event_id from events where event_name = 'The New Toys';


events_test_data_api.create_event_ticket_sales(v_event_id);

end;