set serveroutput on;
declare
v_json_doc varchar2(32000);
p_event_series_id number := 13;
v_reseller_id number := 2;
begin

   v_json_doc := events_json_api.get_event_series_tickets_available_reseller(
                                           p_event_series_id => p_event_series_id,
                                           p_reseller_id => v_reseller_id,
                                           p_formatted => true);

   dbms_output.put_line(v_json_doc);

end;
--reply format example
/*

{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 13,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "events_in_series" : 13,
  "ticket_groups" :
  [
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 650,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    }
  ]
}

*/