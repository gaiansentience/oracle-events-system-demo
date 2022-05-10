set serveroutput on;
declare
   v_json_doc varchar2(32000);
   v_event_id number := 10;
begin
v_json_doc := 
'{
  "event_id" : 10,
  "ticket_groups" :
  [
    {
      "price_category" : "BACKSTAGE-ALL ACCESS",
      "price" : 150,
      "tickets_available" : 2000
    },
    {
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "tickets_available" : 5000
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 12000
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 20000
    },
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 500
    }
  ]
}';

events_json_api.update_event_ticket_groups(p_json_doc => v_json_doc);
--dbms_output.put_line(v_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_string(v_json_doc));


end;

--reply for update with errors
/*
{
  "event_id" : 10,
  "ticket_groups" :
  [
    {
      "price_category" : "BACKSTAGE-ALL ACCESS",
      "price" : 150,
      "tickets_available" : 2000,
      "ticket_group_id" : 938,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "tickets_available" : 5000,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot create EARLYBIRD DISCOUNT  with 5000 tickets.  Only 2500 are available."
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 12000,
      "ticket_group_id" : 942,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 20000,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot create RESERVED SEATING  with 20000 tickets.  Only 2500 are available."
    },
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 500,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot set VIP to 500 tickets.  Current reseller assignments and direct venue sales are 1100"
    }
  ],
  "request_status" : "ERRORS",
  "request_errors" : 3
}
*/
