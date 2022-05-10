set serveroutput on;
declare
v_json_doc varchar2(32000);
v_event_id number := 10;
begin

   v_json_doc := events_json_api.get_event_ticket_groups(
                                           p_event_id => v_event_id,
                                           p_formatted => true);

   dbms_output.put_line(v_json_doc);

end;
--reply format example
/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "event_id" : 10,
  "event_name" : "The Specials",
  "event_date" : "2022-06-10T16:01:51",
  "event_tickets_available" : 20000,
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 938,
      "price_category" : "BACKSTAGE-ALL ACCESS",
      "price" : 150,
      "tickets_available" : 2000
    },
    {
      "ticket_group_id" : 940,
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "tickets_available" : 2000
    },
    {
      "ticket_group_id" : 942,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 12000
    },
    {
      "ticket_group_id" : 941,
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 2000
    },
    {
      "ticket_group_id" : 939,
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 2000
    }
  ]
}
*/