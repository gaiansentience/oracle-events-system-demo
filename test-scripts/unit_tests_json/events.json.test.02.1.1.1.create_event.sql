--create event using a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc := 
'{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400
}';

   events_json_api.create_event(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400,
  "event_id" : 581,
  "status_code" : "SUCCESS",
  "status_message" : "Created event"
}

  reply document for scheduling conflict
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400,
  "event_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Cannot schedule event.  Venue already has event for 12/31/2023"
}


*/