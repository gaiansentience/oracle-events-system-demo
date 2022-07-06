--get venue information as a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'Another Roadside Attraction');

    l_json_doc := events_json_api.get_venue_events(p_venue_id => l_venue_id, p_formatted => true);
   
    dbms_output.put_line(l_json_doc);

 end;

/*
--BEFORE CREATING ANY EVENTS
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "organizer_name" : "Susie Brewer",
  "max_event_capacity" : 400,
  "venue_scheduled_events" : 0,
  "venue_event_listing" : null
}

--AFTER CREATING EVENTS


*/