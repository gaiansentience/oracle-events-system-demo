set serveroutput on;
declare
v_json_doc varchar2(32000);
v_event_id number := 16;
v_reseller_id number := 3;
begin

   v_json_doc := events_json_api.get_event_tickets_available_reseller(
                                           p_event_id => v_event_id,
                                           p_reseller_id => v_reseller_id,
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
      "group_tickets_available" : 2500,
      "group_tickets_sold" : 1929,
      "group_tickets_remaining" : 571,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 3,
          "reseller_name" : "Old School",
          "tickets_available" : 2,
          "ticket_status" : "2 AVAILABLE"
        }
      ]
    }
  ]
}

*/