set serveroutput on;
declare
   v_json_doc varchar2(32000);
begin
v_json_doc := 
'
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets_available" : 400,
  "ticket_groups" :
  [
    {
      "price_category" : "SPONSOR",
      "price" : 150,
      "tickets_available" : 50
    },
    {
      "price_category" : "VIP",
      "price" : 80,
      "tickets_available" : 50
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 300
    }
  ]
}
';

events_json_api.update_ticket_groups(p_json_doc => v_json_doc);
--dbms_output.put_line(v_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_string(v_json_doc));


end;

--reply for successful update/creation
/*
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets_available" : 400,
  "ticket_groups" :
  [
    {
      "price_category" : "SPONSOR",
      "price" : 150,
      "tickets_available" : 50,
      "ticket_group_id" : 2321,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "VIP",
      "price" : 80,
      "tickets_available" : 50,
      "ticket_group_id" : 2322,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 300,
      "ticket_group_id" : 2323,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}

*/
