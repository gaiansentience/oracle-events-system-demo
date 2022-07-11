--update venue using a json document
set serveroutput on;
declare
    l_json_doc varchar2(4000);
begin

    l_json_doc := 
'
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susan Brewer",
  "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 500
}';

    events_json_api.update_venue(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

 end;

/*  reply document for success
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susan Brewer",
  "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 500,
  "status_code" : "SUCCESS",
  "status_message" : "Updated venue"
}


*/