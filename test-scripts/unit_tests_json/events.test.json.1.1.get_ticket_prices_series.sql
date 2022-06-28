set serveroutput on;
declare
v_json_doc varchar2(32000);
p_event_series_id number := 13;
begin

   v_json_doc := events_json_api.get_event_series_ticket_prices(
                                           p_event_series_id => p_event_series_id,
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
  "events_in_series" : 13,
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "ticket_groups" :
  [
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available_all_events" : 6500,
      "tickets_sold_all_events" : 746,
      "tickets_remaining_all_events" : 5754
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available_all_events" : 58500,
      "tickets_sold_all_events" : 1567,
      "tickets_remaining_all_events" : 56933
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available_all_events" : 65000,
      "tickets_sold_all_events" : 1641,
      "tickets_remaining_all_events" : 63359
    }
  ]
}

*/