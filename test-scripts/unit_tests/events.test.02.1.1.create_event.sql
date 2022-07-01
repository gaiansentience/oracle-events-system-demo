--create an event at a venue
--possible errors
--      venue capacity must be enough for event tickets available
--      venue must have event date free
--use show_venue_upcoming_events to see that the event has been scheduled (test.02.00)
set serveroutput on;
declare
  v_venue_id number;
  v_name varchar2(100) := 'The New Toys';
  v_date date := sysdate + 80;
  v_tickets number := 15000;
  v_event_id number;
begin

  select venue_id into v_venue_id from venues where venue_name = 'City Stadium';

  events_api.create_event(
     p_venue_id => v_venue_id,
     p_event_name => v_name,
     p_event_date => v_date,
     p_tickets_available => v_tickets,
     p_event_id => v_event_id);

  dbms_output.put_line('event created with id = ' || v_event_id);

end;