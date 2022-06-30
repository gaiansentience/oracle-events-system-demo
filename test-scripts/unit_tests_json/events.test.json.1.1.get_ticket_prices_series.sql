set serveroutput on;
declare
v_json_doc varchar2(32000);
p_event_series_id number := 15;
begin

   v_json_doc := events_json_api.get_event_series_ticket_prices(
                                           p_event_series_id => p_event_series_id,
                                           p_formatted => true);

   dbms_output.put_line(v_json_doc);

end;
--reply format example
/*
{
  "venue_id" : 2,
  "venue_name" : "Club 11",
  "event_series_id" : 15,
  "event_name" : "Cool Jazz Evening",
  "events_in_series" : 13,
  "first_event_date" : "2023-04-06T00:00:00",
  "last_event_date" : "2023-06-29T00:00:00",
  "ticket_groups" :
  [
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available_all_events" : 1300,
      "tickets_sold_all_events" : 0,
      "tickets_remaining_all_events" : 1300
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available_all_events" : 5200,
      "tickets_sold_all_events" : 0,
      "tickets_remaining_all_events" : 5200
    }
  ]
}

*/