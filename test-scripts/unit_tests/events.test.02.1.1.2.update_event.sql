--update an event
--possible errors
--      venue capacity must be enough for event tickets available
--      venue must have event date free
--      event date must be in future
--if decreasing tickets available
--      current sales cannot be > new tickets available
--      current reseller_assignments + venue direct sales cannot be > new tickets available
--      currently defined ticket groups cannot be > new tickets available
set serveroutput on;
declare
    l_venue_id number;
    l_name varchar2(100) := 'The New Toys';
    l_date date := sysdate + 180;
    l_tickets number := 15000;
    l_event_id number;
begin
    l_date := next_day(l_date,'Friday');
    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_name);

    event_setup_api.update_event(
        p_event_id => l_event_id,
        p_event_name => l_name,
        p_event_date => l_date,
        p_tickets_available => l_tickets);

    dbms_output.put_line('event updated');

end;

/*


error for date in past
Error report -
ORA-20100: Cannot schedule event for current date or past dates

error for exceeding venue capacity
ORA-20100: 150000 exceeds venue capacity of 20000

*/