set serveroutput on;
declare
v_json_doc varchar2(32000);
v_event_id number := 16;
begin

   v_json_doc := events_json_api.get_event_tickets_available_venue(
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
      "group_tickets_available" : 2500,
      "group_tickets_sold" : 1929,
      "group_tickets_remaining" : 571,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 543,
          "ticket_status" : "543 AVAILABLE"
        }
      ]
    },
    {
      "ticket_group_id" : 959,
      "price_category" : "VIP",
      "price" : 100,
      "group_tickets_available" : 2500,
      "group_tickets_sold" : 1952,
      "group_tickets_remaining" : 548,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 519,
          "ticket_status" : "519 AVAILABLE"
        }
      ]
    },
    {
      "ticket_group_id" : 960,
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "group_tickets_available" : 2000,
      "group_tickets_sold" : 1928,
      "group_tickets_remaining" : 72,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 57,
          "ticket_status" : "57 AVAILABLE"
        }
      ]
    },
    {
      "ticket_group_id" : 961,
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "group_tickets_available" : 3000,
      "group_tickets_sold" : 1963,
      "group_tickets_remaining" : 1037,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 1026,
          "ticket_status" : "1026 AVAILABLE"
        }
      ]
    },
    {
      "ticket_group_id" : 962,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "group_tickets_available" : 10000,
      "group_tickets_sold" : 5123,
      "group_tickets_remaining" : 4877,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 4755,
          "ticket_status" : "4755 AVAILABLE"
        }
      ]
    }
  ]
}

*/