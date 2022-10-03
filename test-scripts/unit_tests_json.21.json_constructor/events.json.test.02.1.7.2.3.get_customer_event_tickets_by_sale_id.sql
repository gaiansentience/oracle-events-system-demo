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
    l_ticket_sales_id number;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select ticket_sales_id into l_ticket_sales_id
    from customer_purchases_mv 
    where 
        event_id = l_event_id 
        and customer_id = l_customer_id 
    fetch first 1 row only;
    
    l_json := events_json_api.get_customer_event_tickets_by_sale_id(p_customer_id => l_customer_id, p_ticket_sales_id => l_ticket_sales_id, p_formatted => true);
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
  "purchase" :
  {
    "ticket_group_id" : 2442,
    "price_category" : "VIP",
    "ticket_sales_id" : 80201,
    "ticket_quantity" : 3,
    "sales_date" : "2022-07-13T12:09:38",
    "reseller_id" : 3,
    "reseller_name" : "Old School",
    "tickets" :
    [
      {
        "ticket_id" : 640761,
        "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
        "status" : "ISSUED"
      },
      {
        "ticket_id" : 640762,
        "serial_code" : "G2442C529S80201D20220713120938Q0003I0002",
        "status" : "ISSUED"
      },
      {
        "ticket_id" : 640763,
        "serial_code" : "G2442C529S80201D20220713120938Q0003I0003",
        "status" : "ISSUED"
      }
    ]
  }
}

*/