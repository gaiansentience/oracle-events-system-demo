--create event using a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_json json;
    
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    
l_json_doc := 
'
{
  "venue_id" : $$VENUE$$,
  "event_name" : "Monster Truck Smashup",
  "event_start_date" : "2023-06-01T19:00:00",
  "event_end_date" : "2023-09-01T19:00:00",
  "event_day" : "Wednesday",
  "tickets_available" : 10000
}
';

    l_json_doc := replace(l_json_doc, '$$VENUE$$', l_venue_id);

    l_json := json(l_json_doc);    
    events_json_api.create_weekly_event(p_json_doc => l_json);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

end;

/*  reply document for success
{
  "venue_id" : 1,
  "event_name" : "Monster Truck Smashup",
  "event_start_date" : "2023-06-01T19:00:00",
  "event_end_date" : "2023-09-01T19:00:00",
  "event_day" : "Wednesday",
  "tickets_available" : 10000,
  "request_status_code" : "SUCCESS",
  "request_status_message" : "13 events for (Monster Truck Smashup) created successfully. 0 events could not be created because of conflicts with existing events.",
  "event_series_id" : 81,
  "event_series_details" :
  [
    {
      "event_id" : 623,
      "event_date" : "2023-06-07T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 624,
      "event_date" : "2023-06-14T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 625,
      "event_date" : "2023-06-21T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 626,
      "event_date" : "2023-06-28T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 627,
      "event_date" : "2023-07-05T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 628,
      "event_date" : "2023-07-12T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 629,
      "event_date" : "2023-07-19T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 630,
      "event_date" : "2023-07-26T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 631,
      "event_date" : "2023-08-02T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 632,
      "event_date" : "2023-08-09T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 633,
      "event_date" : "2023-08-16T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 634,
      "event_date" : "2023-08-23T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 635,
      "event_date" : "2023-08-30T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    }
  ]
}


*/
