set serveroutput on;
declare
    l_json_doc varchar2(32000);
    l_event_id number;
    l_venue_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'Another Roadside Attraction');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'New Years Mischief');

    l_json_doc := events_json_api.get_ticket_groups(p_event_id => l_event_id, p_formatted => true);

    dbms_output.put_line(l_json_doc);

end;

/*
--BEFORE CREATING TICKET GROUPS
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets_available" : 400,
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 0,
      "price_category" : "UNDEFINED",
      "price" : 0,
      "tickets_available" : 400,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    }
  ]
}

--AFTER CREATING TICKET GROUPS
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets_available" : 400,
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 2321,
      "price_category" : "SPONSOR",
      "price" : 150,
      "tickets_available" : 50,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    },
    {
      "ticket_group_id" : 2322,
      "price_category" : "VIP",
      "price" : 80,
      "tickets_available" : 50,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    },
    {
      "ticket_group_id" : 2323,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 300,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    }
  ]
}

*/