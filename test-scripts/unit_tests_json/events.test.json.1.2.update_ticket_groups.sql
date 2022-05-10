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
      "tickets_available" : 2000
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 12000
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 2000
    },
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 1500
    }
  ]
}';

events_json_api.update_event_ticket_groups(p_json_doc => v_json_doc);
--dbms_output.put_line(v_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_string(v_json_doc));


end;

--reply for successful update/creation
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
      "tickets_available" : 2000,
      "ticket_group_id" : 940,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
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
      "tickets_available" : 2000,
      "ticket_group_id" : 941,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 1500,
      "ticket_group_id" : 939,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}
*/
