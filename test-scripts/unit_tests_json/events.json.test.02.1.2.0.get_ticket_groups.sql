set serveroutput on;
declare
v_json_doc varchar2(32000);
v_event_id number := 16;
begin

   v_json_doc := events_json_api.get_ticket_groups(
                                           p_event_id => v_event_id,
                                           p_formatted => true);

   dbms_output.put_line(v_json_doc);

end;
--reply format example
/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_id" : 16,
  "event_name" : "The Specials",
  "event_date" : "2022-07-08T16:07:19",
  "event_tickets_available" : 20000,
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 958,
      "price_category" : "BACKSTAGE-ALL ACCESS",
      "price" : 150,
      "tickets_available" : 2000,
      "currently_assigned" : 600,
      "sold_by_venue" : 1357
    },
    {
      "ticket_group_id" : 959,
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 2000,
      "currently_assigned" : 500,
      "sold_by_venue" : 1481
    },
    {
      "ticket_group_id" : 960,
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "tickets_available" : 2000,
      "currently_assigned" : 500,
      "sold_by_venue" : 1443
    },
    {
      "ticket_group_id" : 961,
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 2000,
      "currently_assigned" : 400,
      "sold_by_venue" : 1574
    },
    {
      "ticket_group_id" : 962,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 12000,
      "currently_assigned" : 3000,
      "sold_by_venue" : 2245
    }
  ]
}


PL/SQL procedure successfully completed.

*/