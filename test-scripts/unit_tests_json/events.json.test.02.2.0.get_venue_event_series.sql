--get venue information as a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_json_doc := events_json_api.get_venue_event_series(p_venue_id => l_venue_id, p_formatted => true);
   
    dbms_output.put_line(l_json_doc);

 end;

/*


{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "max_event_capacity" : 20000,
  "venue_scheduled_events" : 33,
  "venue_event_listing" :
  [
    {
      "event_id" : 534,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-06T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 19
    },
    {
      "event_id" : 535,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-13T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 26
    },
    {
      "event_id" : 536,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-20T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 20
    },
    {
      "event_id" : 537,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-27T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 19
    },
    {
      "event_id" : 538,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-03T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 23
    },
    {
      "event_id" : 539,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-10T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 33
    },
    {
      "event_id" : 540,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-17T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 26
    },
    {
      "event_id" : 541,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-24T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 24
    },
    {
      "event_id" : 542,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-22T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 17
    },
    {
      "event_id" : 543,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-29T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 22
    },
    {
      "event_id" : 544,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-12T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 23
    },
    {
      "event_id" : 545,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-26T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 29
    },
    {
      "event_id" : 546,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-03T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 41
    },
    {
      "event_id" : 547,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-10T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 26
    },
    {
      "event_id" : 548,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-17T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 32
    },
    {
      "event_id" : 549,
      "event_series_id" : 13,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-24T16:30:07",
      "tickets_available" : 5000,
      "tickets_remaining" : 25
    }
  ]
}


PL/SQL procedure successfully completed.




*/