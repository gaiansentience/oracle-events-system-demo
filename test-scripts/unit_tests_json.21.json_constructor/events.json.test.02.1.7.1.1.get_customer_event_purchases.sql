--get venue information as a json document
set serveroutput on;
declare
    l_json json;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_id number;
    l_event_name events.event_name%type := 'New Years Mischief';
    l_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    l_customer_id number;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    l_json := events_json_api.get_customer_event_purchases(p_customer_id => l_customer_id, p_event_id => l_event_id, p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/* 
{
  "customer_id" : 529,
  "customer_name" : "Maggie Wayland",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 621,
  "event_series_id" : null,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets" : 9,
  "purchases" :
  [
    {
      "ticket_group_id" : 2442,
      "price_category" : "VIP",
      "ticket_sales_id" : 80201,
      "ticket_quantity" : 3,
      "sales_date" : "2022-07-13T12:09:38",
      "reseller_id" : 3,
      "reseller_name" : "Old School"
    },
    {
      "ticket_group_id" : 2443,
      "price_category" : "GENERAL ADMISSION",
      "ticket_sales_id" : 80202,
      "ticket_quantity" : 6,
      "sales_date" : "2022-07-13T12:09:38",
      "reseller_id" : 3,
      "reseller_name" : "Old School"
    }
  ]
}


PL/SQL procedure successfully completed.



*/