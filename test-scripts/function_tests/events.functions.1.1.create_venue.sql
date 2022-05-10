--create a venue
set serveroutput on;
declare
  v_venue_name varchar2(100) := 'All That Jazz';
  v_organizer_name varchar2(100) := 'Jeanie Bixby';
  v_organizer_email varchar2(100) := 'Jeanie.Bixby@AllThatJazz';
  v_capacity number := 11000;
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

