set serveroutput on;
declare
    l_json json;
    l_event_name events.event_name%type := 'New Years Mischief';
    l_event_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_venue_id number;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_json := events_json_api.get_event_tickets_available_venue(p_event_id => l_event_id, p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

end;
--reply format example
/*

{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 621,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets_available" : 400,
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 2442,
      "price_category" : "VIP",
      "price" : 80,
      "group_tickets_available" : 100,
      "group_tickets_sold" : 0,
      "group_tickets_remaining" : 100,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 80,
          "ticket_status" : "80 AVAILABLE"
        }
      ]
    },
    {
      "ticket_group_id" : 2443,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "group_tickets_available" : 200,
      "group_tickets_sold" : 0,
      "group_tickets_remaining" : 200,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 50,
          "ticket_status" : "50 AVAILABLE"
        }
      ]
    },
    {
      "ticket_group_id" : 2441,
      "price_category" : "SPONSOR",
      "price" : 150,
      "group_tickets_available" : 100,
      "group_tickets_sold" : 0,
      "group_tickets_remaining" : 100,
      "ticket_resellers" :
      [
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 90,
          "ticket_status" : "90 AVAILABLE"
        }
      ]
    }
  ]
}

*/