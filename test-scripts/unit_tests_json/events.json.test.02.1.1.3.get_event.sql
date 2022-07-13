--get venue information as a json document
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_venue_id number;
    l_event_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'Another Roadside Attraction');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'New Years Mischief');

    l_json_doc := events_json_api.get_event(p_event_id => l_event_id, p_formatted => true);
   
   dbms_output.put_line(l_json_doc);

 end;

/*
{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
  "organizer_name" : "Susan Brewer",
  "event_id" : 621,
  "event_series_id" : null,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400,
  "tickets_remaining" : 400
}

*/