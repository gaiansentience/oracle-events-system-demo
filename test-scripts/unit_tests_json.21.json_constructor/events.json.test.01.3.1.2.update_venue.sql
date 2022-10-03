--update venue using a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_json json;
    
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_organizer_name venues.organizer_name%type := 'Susan Brewer';
    l_organizer_email venues.organizer_email%type := 'Susan.Brewer@AnotherRoadsideAttraction.com';
    l_max_capacity venues.max_event_capacity%type := 500;
    l_venue_id number;    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_json_doc := 
'
{
  "venue_id" : $$VENUE_ID$$,
  "venue_name" : "$$VENUE_NAME$$",
  "organizer_name" : "$$ORGANIZER_NAME$$",
  "organizer_email" : "$$ORGANIZER_EMAIL$$",
  "max_event_capacity" : $$CAPACITY$$
}
';

    l_json_doc := replace(l_json_doc,'$$VENUE_ID$$', l_venue_id);
    l_json_doc := replace(l_json_doc,'$$VENUE_NAME$$', l_venue_name);
    l_json_doc := replace(l_json_doc,'$$ORGANIZER_NAME$$', l_organizer_name);
    l_json_doc := replace(l_json_doc,'$$ORGANIZER_EMAIL$$', l_organizer_email);
    l_json_doc := replace(l_json_doc,'$$CAPACITY$$', l_max_capacity);

    l_json := json(l_json_doc);
    events_json_api.update_venue(p_json_doc => l_json);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/*  reply document for success
{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susan Brewer",
  "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 500,
  "status_code" : "SUCCESS",
  "status_message" : "Updated venue"
}


*/