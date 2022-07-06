--total of all ticket groups cannot exceed event capacity
--if tickets in a group are assigned, group cannot be set below level of current assignments
--if tickets in a group have been sold by venue, group cannot be set below venue_sales + reseller assignments
set serveroutput on;
declare
   v_json_doc varchar2(32000);
   v_event_id number := 10;
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
      "tickets_available" : 100
    },
    {
      "price_category" : "RESERVED",
      "price" : 65,
      "tickets_available" : 100
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

--reply for update with errors
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
      "tickets_available" : 100,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot create VIP  with 100 tickets.  Only 50 are available."
    },
    {
      "price_category" : "RESERVED",
      "price" : 65,
      "tickets_available" : 100,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot create RESERVED  with 100 tickets.  Only 0 are available."
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
  "request_status" : "ERRORS",
  "request_errors" : 2
}


PL/SQL procedure successfully completed.


*/
