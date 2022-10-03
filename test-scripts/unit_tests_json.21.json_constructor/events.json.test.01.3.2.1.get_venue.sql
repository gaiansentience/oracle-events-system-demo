--get venue information as a json document
set serveroutput on;
declare
    l_json json;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);

    l_json := events_json_api.get_venue(p_venue_id => l_venue_id, p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/*
{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susan Brewer",
  "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 500,
  "events_scheduled" : 1
}

*/