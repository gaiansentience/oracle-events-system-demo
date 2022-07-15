--update information for a venue
--the venue name must be set to a unique value
--error is raised if the venue is updated with the name of another venue
--ORA-00001: unique constraint (TOPTAL.VENUES_U_NAME) violated
set serveroutput on;
declare
    l_venue venues%rowtype;
begin

    l_venue.venue_name := 'Roadside Cafe';
    l_venue.organizer_name := 'Billy Styles';
    l_venue.organizer_email := 'Billy.Styles@RoadsideCafe.com';
    l_venue.max_event_capacity := 400;
    
    l_venue.venue_id := venue_api.get_venue_id(p_venue_name => l_venue.venue_name);

    venue_api.update_venue(
        p_venue_id => l_venue.venue_id,
        p_venue_name => l_venue.venue_name,
        p_organizer_name => l_venue.organizer_name,
        p_organizer_email => l_venue.organizer_email,
        p_max_event_capacity => l_venue.max_event_capacity);
    
    dbms_output.put_line('venue updated');

end;

/*
venue updated
*/