set serveroutput on;
declare
    l_json_doc varchar2(32000);
    l_event_name events.event_name%type := 'New Years Mischief';
    l_event_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_venue_id number;
    l_reseller_name resellers.reseller_name%type := 'Old School';
    l_reseller_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => l_reseller_name);

    l_json_doc := events_json_api.get_event_tickets_available_reseller(p_event_id => l_event_id, p_reseller_id => l_reseller_id, p_formatted => true);

    dbms_output.put_line(l_json_doc);

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
      "ticket_group_id" : 2441,
      "price_category" : "SPONSOR",
      "price" : 150,
      "group_tickets_available" : 100,
      "group_tickets_sold" : 0,
      "group_tickets_remaining" : 100,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 3,
          "reseller_name" : "Old School",
          "tickets_available" : 10,
          "ticket_status" : "10 AVAILABLE"
        }
      ]
    },
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
          "reseller_id" : 3,
          "reseller_name" : "Old School",
          "tickets_available" : 10,
          "ticket_status" : "10 AVAILABLE"
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
          "reseller_id" : 3,
          "reseller_name" : "Old School",
          "tickets_available" : 50,
          "ticket_status" : "50 AVAILABLE"
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.



*/