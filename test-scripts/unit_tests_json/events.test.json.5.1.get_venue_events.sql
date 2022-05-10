--get venue information as a json document
set serveroutput on;
declare
  v_json_doc clob;
  v_venue_id number := 1;
begin

   v_json_doc := events_json_api.get_venue_events(p_venue_id => v_venue_id, p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "max_event_capacity" : 20000,
  "venue_scheduled_events" : 7,
  "venue_event_listing" :
  [
    {
      "event_id" : 1,
      "event_name" : "Rudy and the Trees",
      "event_date" : "2022-05-13T16:01:51",
      "event_capacity" : 20000,
      "tickets_remaining" : 20000
    },
    {
      "event_id" : 2,
      "event_name" : "A Night of Polka",
      "event_date" : "2022-05-20T16:01:51",
      "event_capacity" : 20000,
      "tickets_remaining" : 8354
    },
    {
      "event_id" : 4,
      "event_name" : "Molly Jones and Associates",
      "event_date" : "2022-05-27T16:01:51",
      "event_capacity" : 20000,
      "tickets_remaining" : 8081
    },
    {
      "event_id" : 7,
      "event_name" : "Rolling Thunder",
      "event_date" : "2022-06-03T16:01:51",
      "event_capacity" : 20000,
      "tickets_remaining" : 20000
    },
    {
      "event_id" : 10,
      "event_name" : "The Specials",
      "event_date" : "2022-06-10T16:01:51",
      "event_capacity" : 20000,
      "tickets_remaining" : 20000
    },
    {
      "event_id" : 14,
      "event_name" : "Synthtones and Company",
      "event_date" : "2022-06-17T16:01:51",
      "event_capacity" : 20000,
      "tickets_remaining" : 20000
    },
    {
      "event_id" : 16,
      "event_name" : "The Electric Blues Garage Band",
      "event_date" : "2022-06-24T16:01:51",
      "event_capacity" : 20000,
      "tickets_remaining" : 8200
    }
  ]
}
*/