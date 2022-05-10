--create a new venue
--the venue name must be set to a unique value
--error is raised if a second venue with the same name is added
--ORA-00001: unique constraint (TOPTAL.VENUES_U_NAME) violated
set serveroutput on;
declare
  v_venue_name varchar2(100) := 'Roadside Cafe';
  v_organizer_name varchar2(100) := 'Bill Styles';
  v_organizer_email varchar2(100) := 'Bill.Styles@RoadsideCafe';
  v_capacity number := 200;
  v_venue_id number;
begin

  events_api.create_venue(
    p_venue_name => v_venue_name,
    p_organizer_name => v_organizer_name,
    p_organizer_email => v_organizer_email,
    p_max_event_capacity => v_capacity,
    p_venue_id => v_venue_id);
    
  dbms_output.put_line('venue created with id = ' || v_venue_id);

end;

