--update name and tickets available for all events in a recurring series
--if some events in series have already occurred they will not be updated
--possible errors
--      venue capacity must be enough for event tickets available
--if decreasing number of available tickets
--      raise error if existing sales for any future event in the series are > new tickets available
--      raise error if reseller_assignments + venue direct sales for any future event in series are > new tickets available
--      raise error if any future event in series has sum of defined ticket groups > new tickets available
set serveroutput on;
declare
    l_venue_id number;
    l_name varchar2(100) := 'Hometown Hockey League';
    l_tickets number := 5000;
    l_event_series_id number;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_name);

    begin
        event_setup_api.update_event_series(
            p_event_series_id => l_event_series_id,
            p_event_name => l_name,
            p_tickets_available => l_tickets);

        dbms_output.put_line('Event series updated');
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

end;

/*

ORA-20100: 500000 exceeds venue capacity of 20000
*/