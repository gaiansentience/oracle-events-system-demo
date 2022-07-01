--get venue information as a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
  v_event_id number := 1;
begin

   v_json_doc := events_json_api.get_event(p_event_id => v_event_id, p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "event_id" : 1,
  "event_name" : "Rudy and the Trees",
  "event_date" : "2022-05-27T16:07:19",
  "tickets_available" : 20000,
  "tickets_remaining" : 7808
}
*/