--get venue information as a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
  v_venue_id number := 1;
begin

   v_json_doc := events_json_api.get_venue(p_venue_id => v_venue_id, p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "max_event_capacity" : 20000,
  "venue_scheduled_events" : 7
}
*/