--create an event at a venue
--possible errors
--      venue capacity must be enough for event tickets available
--      venue must have event date free
--use show_venue_upcoming_events to see that the event has been scheduled (test.02.00)
set serveroutput on;
declare
    l_venue_id number;
    l_name varchar2(100) := 'The New Toys';
    l_date date := sysdate + 180;
    l_tickets number := 10000;
    l_event_id number;
begin
    l_date := next_day(l_date,'Friday');
    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');

    event_setup_api.create_event(
        p_venue_id => l_venue_id,
        p_event_name => l_name,
        p_event_date => l_date,
        p_tickets_available => l_tickets,
        p_event_id => l_event_id);

    dbms_output.put_line('event created with id = ' || l_event_id);

end;

/*
event created with id = 602
*/