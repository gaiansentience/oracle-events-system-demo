--create event using a json document
set serveroutput on;
declare
  v_json_doc clob;
begin

   v_json_doc := 
'
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_name" : "Monster Truck Smashup",
  "event_start_date" : "2023-06-01T19:00:00",
  "event_end_date" : "2023-09-01T19:00:00",
  "event_day" : "Wednesday",
  "tickets_available" : 10000
}
';

   events_json_api.create_weekly_event(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_clob(v_json_doc));

end;

/*  reply document for success

{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_name" : "Monster Truck Smashup",
  "event_start_date" : "2023-06-01T19:00:00",
  "event_end_date" : "2023-09-01T19:00:00",
  "event_day" : "Wednesday",
  "tickets_available" : 10000,
  "request_status_code" : "SUCCESS",
  "request_status_message" : "13 events for (Monster Truck Smashup) created successfully. 0 events could not be created because of conflicts with existing events.",
  "event_series_id" : 41,
  "event_series_details" :
  [
    {
      "event_id" : 582,
      "event_date" : "2023-06-07T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 583,
      "event_date" : "2023-06-14T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 584,
      "event_date" : "2023-06-21T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 585,
      "event_date" : "2023-06-28T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 586,
      "event_date" : "2023-07-05T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 587,
      "event_date" : "2023-07-12T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 588,
      "event_date" : "2023-07-19T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 589,
      "event_date" : "2023-07-26T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 590,
      "event_date" : "2023-08-02T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 591,
      "event_date" : "2023-08-09T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 592,
      "event_date" : "2023-08-16T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 593,
      "event_date" : "2023-08-23T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    },
    {
      "event_id" : 594,
      "event_date" : "2023-08-30T19:00:00",
      "status_code" : "SUCCESS",
      "status_message" : "Event Created"
    }
  ]
}


PL/SQL procedure successfully completed.



*/
