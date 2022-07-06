set serveroutput on;
declare
    l_json_doc varchar2(32000);
begin
l_json_doc := 
'
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 4500
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500
    }
  ]
}
';

events_json_api.update_ticket_groups_series(p_json_doc => l_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_string(l_json_doc));


end;

--reply for successful update/creation
/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 4500,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (RESERVED SEATING) created for 13 events in series"
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (GENERAL ADMISSION) created for 13 events in series"
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (VIP PIT ACCESS) created for 13 events in series"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}

*/
