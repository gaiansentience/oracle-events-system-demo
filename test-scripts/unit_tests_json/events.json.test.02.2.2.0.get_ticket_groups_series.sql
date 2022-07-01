set serveroutput on;
declare
v_json_doc varchar2(32000);
p_event_series_id number := 13;
begin

   v_json_doc := events_json_api.get_ticket_groups_series(
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
  "event_tickets_available" : 10000,
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 3000,
      "currently_assigned" : 0,
      "sold_by_venue" : 576
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000,
      "currently_assigned" : 0,
      "sold_by_venue" : 626
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500,
      "currently_assigned" : 0,
      "sold_by_venue" : 374
    },
    {
      "price_category" : "UNDEFINED",
      "price" : 0,
      "tickets_available" : 1500,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    }
  ]
}
*/