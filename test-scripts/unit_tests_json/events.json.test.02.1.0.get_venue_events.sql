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
  "venue_scheduled_events" : 8,
  "venue_event_listing" :
  [
    {
      "event_id" : 9,
      "event_name" : "Miles Morgan and the Undergound Jazz Trio",
      "event_date" : "2022-06-24T16:07:19",
      "tickets_available" : 20000,
      "tickets_remaining" : 14751
    },
    {
      "event_id" : 13,
      "event_name" : "Purple Parrots",
      "event_date" : "2022-07-01T16:07:19",
      "tickets_available" : 20000,
      "tickets_remaining" : 15383
    },
    {
      "event_id" : 16,
      "event_name" : "The Specials",
      "event_date" : "2022-07-08T16:07:19",
      "tickets_available" : 20000,
      "tickets_remaining" : 10809
    },
    {
      "event_id" : 20,
      "event_name" : "Synthtones and Company",
      "event_date" : "2022-07-15T16:07:19",
      "tickets_available" : 20000,
      "tickets_remaining" : 14925
    },
    {
      "event_id" : 22,
      "event_name" : "The Electric Blues Garage Band",
      "event_date" : "2022-07-22T16:07:19",
      "tickets_available" : 20000,
      "tickets_remaining" : 13753
    },
    {
      "event_id" : 283,
      "event_name" : "Rudy and the Trees",
      "event_date" : "2023-05-27T19:00:00",
      "tickets_available" : 11000,
      "tickets_remaining" : 11000
    },
    {
      "event_id" : 284,
      "event_name" : "Rudy and the Trees",
      "event_date" : "2023-05-03T19:00:00",
      "tickets_available" : 11000,
      "tickets_remaining" : 11000
    },
    {
      "event_id" : 285,
      "event_name" : "New Years Mischief",
      "event_date" : "2023-12-31T20:00:00",
      "tickets_available" : 2024,
      "tickets_remaining" : 2024
    }
  ]
}
*/