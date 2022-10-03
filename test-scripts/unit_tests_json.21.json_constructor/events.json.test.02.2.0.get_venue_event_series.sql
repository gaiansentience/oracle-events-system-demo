--get venue information as a json document
set serveroutput on;
declare
    l_json json;
    l_venue_id number;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_json := events_json_api.get_venue_event_series(p_venue_id => l_venue_id, p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/*

{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_name" : "Erin Johanson",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "max_event_capacity" : 20000,
  "events_scheduled" : 34,
  "venue_event_listing" :
  [
    {
      "event_id" : 603,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-13T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 0
    },
    {
      "event_id" : 604,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-20T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 0
    },
    {
      "event_id" : 605,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-27T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 2
    },
    {
      "event_id" : 606,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-03T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 3
    },
    {
      "event_id" : 607,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-10T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 0
    },
    {
      "event_id" : 608,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-17T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 1
    },
    {
      "event_id" : 609,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-24T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 5
    },
    {
      "event_id" : 610,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-22T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 3
    },
    {
      "event_id" : 611,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-29T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 2
    },
    {
      "event_id" : 612,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-12T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 2
    },
    {
      "event_id" : 613,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-26T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 1
    },
    {
      "event_id" : 614,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-03T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 2
    },
    {
      "event_id" : 615,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-10T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 1
    },
    {
      "event_id" : 616,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-17T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 0
    },
    {
      "event_id" : 617,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-24T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 1
    },
    {
      "event_id" : 618,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-31T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 3
    },
    {
      "event_id" : 619,
      "event_series_id" : 61,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2023-01-07T15:37:39",
      "tickets_available" : 5000,
      "tickets_remaining" : 2
    }
  ]
}



*/