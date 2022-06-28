--get venue information as a json document
set serveroutput on;
declare
  v_json_doc clob;
  v_venue_id number := 1;
begin

   v_json_doc := events_json_api.get_venue_event_series(p_venue_id => v_venue_id, p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "max_event_capacity" : 20000,
  "venue_scheduled_events" : 64,
  "venue_event_listing" :
  [
    {
      "event_id" : 410,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-08-07T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 411,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-08-14T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 412,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-08-21T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 413,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-08-28T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 414,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-09-04T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 415,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-09-11T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 416,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-09-18T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 417,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-09-25T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 418,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-10-02T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 419,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-10-09T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 420,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-10-16T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 421,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-10-23T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 422,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-10-30T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 423,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-11-06T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 424,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-11-13T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 425,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-11-20T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 426,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-11-27T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 427,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-12-04T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 428,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-12-11T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 429,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-12-18T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 409,
      "event_series_id" : 11,
      "event_name" : "Classical Concert Series",
      "event_date" : "2022-07-31T16:56:17",
      "tickets_available" : 1000,
      "tickets_remaining" : 1000
    },
    {
      "event_id" : 430,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-07T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 431,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-14T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 8637
    },
    {
      "event_id" : 432,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-21T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 433,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-28T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 434,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-05T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 435,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-12T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 436,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-19T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 8790
    },
    {
      "event_id" : 437,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-26T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 438,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-02T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 439,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-09T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 440,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-16T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 441,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-23T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 8619
    },
    {
      "event_id" : 442,
      "event_series_id" : 13,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-30T19:00:00",
      "tickets_available" : 10000,
      "tickets_remaining" : 10000
    },
    {
      "event_id" : 463,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-13T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 464,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-20T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 465,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-27T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 466,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-03T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 467,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-10T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 468,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-17T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 469,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-09-24T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 470,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-01T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 471,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-08T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 472,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-15T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 473,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-22T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 461,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-07-30T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 462,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-08-06T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 474,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-10-29T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 475,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-05T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 476,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-12T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 477,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-19T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 478,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-11-26T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 479,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-03T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 480,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-10T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 481,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-17T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    },
    {
      "event_id" : 482,
      "event_series_id" : 21,
      "event_name" : "Hometown Hockey League",
      "event_date" : "2022-12-24T14:41:02",
      "tickets_available" : 5000,
      "tickets_remaining" : 5000
    }
  ]
}


PL/SQL procedure successfully completed.


*/