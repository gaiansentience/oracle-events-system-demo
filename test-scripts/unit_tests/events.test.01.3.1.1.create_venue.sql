--create a new venue
--the venue name must be set to a unique value
--error is raised if a second venue with the same name is added
--ORA-00001: unique constraint (TOPTAL.VENUES_U_NAME) violated
set serveroutput on;
declare
    l_venue venues%rowtype;
begin

    l_venue.venue_name := 'Roadside Cafe';
    l_venue.organizer_name := 'Bill Styles';
    l_venue.organizer_email := 'Bill.Styles#RoadsideCafe.com';
    l_venue.max_event_capacity := 500;

    events_api.create_venue(
        p_venue_name => l_venue.venue_name,
        p_organizer_name => l_venue.organizer_name,
        p_organizer_email => l_venue.organizer_email,
        p_max_event_capacity => l_venue.max_event_capacity,
        p_venue_id => l_venue.venue_id);
    
  dbms_output.put_line('venue created with id = ' || l_venue.venue_id);

end;

/*
venue created with id = 67
*/