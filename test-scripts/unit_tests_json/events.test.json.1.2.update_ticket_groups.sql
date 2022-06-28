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
  "event_id" : 16,
  "event_name" : "The Specials",
  "event_tickets_available" : 20000,
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 958,
      "price_category" : "BACKSTAGE-ALL ACCESS",
      "price" : 150,
      "tickets_available" : 2500
    },
    {
      "ticket_group_id" : 959,
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 2500
    },
    {
      "ticket_group_id" : 960,
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "tickets_available" : 2000
    },
    {
      "ticket_group_id" : 961,
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 3000
    },
    {
      "ticket_group_id" : 962,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 10000
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
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_id" : 16,
  "event_name" : "The Specials",
  "event_tickets_available" : 20000,
  "ticket_groups" :
  [
    {
      "price_category" : "BACKSTAGE-ALL ACCESS",
      "price" : 150,
      "tickets_available" : 2500,
      "ticket_group_id" : 958,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 2500,
      "ticket_group_id" : 959,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "tickets_available" : 2000,
      "ticket_group_id" : 960,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 2000,
      "ticket_group_id" : 961,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 10000,
      "ticket_group_id" : 962,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}


PL/SQL procedure successfully completed.

*/
