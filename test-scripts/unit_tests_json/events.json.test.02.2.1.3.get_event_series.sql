--get venue information as a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_json_doc := events_json_api.get_event_series(p_event_series_id => l_event_series_id, p_formatted => true);   
    dbms_output.put_line(l_json_doc);

 end;

/*

{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 81,
  "event_series_name" : "Monster Truck Smashup",
  "events_in_series" : 13,
  "tickets_available_all_events" : 130000,
  "tickets_remaining_all_events" : 130000,
  "events_sold_out" : 0,
  "events_still_available" : 13,
  "series_events" :
  [
    {
      "event_id" : 623,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-07T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 624,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-14T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 625,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-21T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 626,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-28T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 627,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-05T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 628,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-12T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 629,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-19T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 630,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-26T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 631,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-02T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 632,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-09T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 633,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-16T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 634,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-23T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 635,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-30T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    }
  ]
}


PL/SQL procedure successfully completed.




*/