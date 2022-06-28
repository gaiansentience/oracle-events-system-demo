set serveroutput on;
declare
   v_json_doc varchar2(32000);
   v_event_id number := 10;
begin
v_json_doc := 
'
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 13,
  "event_name" : "Monster Truck Smashup",
  "events_in_series" : 13,
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "event_tickets_available" : 10000,
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 4500,
      "currently_assigned" : 0,
      "sold_by_venue" : 576
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000,
      "currently_assigned" : 0,
      "sold_by_venue" : 626
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500,
      "currently_assigned" : 0,
      "sold_by_venue" : 374
    }
  ]
}
';

events_json_api.update_ticket_groups_series(p_json_doc => v_json_doc);
--dbms_output.put_line(v_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_string(v_json_doc));


end;

--reply for successful update/creation
/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 13,
  "event_name" : "Monster Truck Smashup",
  "events_in_series" : 13,
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "event_tickets_available" : 10000,
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 4500,
      "currently_assigned" : 0,
      "sold_by_venue" : 576,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (RESERVED SEATING) created for 13 events in series"
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000,
      "currently_assigned" : 0,
      "sold_by_venue" : 626,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (GENERAL ADMISSION) created for 13 events in series"
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500,
      "currently_assigned" : 0,
      "sold_by_venue" : 374,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (VIP PIT ACCESS) created for 13 events in series"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}
*/
