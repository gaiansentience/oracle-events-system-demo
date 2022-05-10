--create an event
set serveroutput on;
declare
  v_venue_id number;
  v_name varchar2(100) := 'Blues and Jazz Show';
  v_date date := sysdate + 90;
  v_tickets number := 10000;
  v_event_id number;
begin

  select venue_id into v_venue_id from venues where venue_name = 'All That Jazz';

  events_api.create_event(
     p_venue_id => v_venue_id,
     p_event_name => v_name,
     p_event_date => v_date,
     p_tickets_available => v_tickets,
     p_event_id => v_event_id);

  dbms_output.put_line('event created with id = ' || v_event_id);

end;