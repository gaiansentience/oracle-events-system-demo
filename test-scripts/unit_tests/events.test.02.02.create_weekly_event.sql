--create a recurring weekly event at a venue
--possible errors
--      venue capacity must be enough for event tickets available
--      venue must have event dates free (dates with conflicting events are not created) 
--          status will show how many events were created and how many conflicts were found
--use show_venue_upcoming_events to see that the event has been scheduled (test.02.00)
set serveroutput on;
declare
  v_venue_id number;
  v_name varchar2(100) := 'Amateur Comedy Hour';
  v_start_date date := sysdate + 30;
  v_end_date date := sysdate + 180;
  v_event_day varchar2(20) := 'Thursday';
  v_tickets number := 1000;
  v_status varchar2(4000);
begin

  select venue_id into v_venue_id from venues where venue_name = 'City Stadium';

  events_api.create_weekly_event(
     p_venue_id => v_venue_id,
     p_event_name => v_name,
     p_event_start_date => v_start_date,
     p_event_end_date => v_end_date,
     p_event_day => v_event_day,
     p_tickets_available => v_tickets,
     p_status => v_status);

  dbms_output.put_line(v_status);

end;