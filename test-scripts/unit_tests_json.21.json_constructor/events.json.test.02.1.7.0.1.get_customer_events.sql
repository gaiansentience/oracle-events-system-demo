set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    l_customer_id number;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    l_json_doc := events_json_api.get_customer_events(p_customer_id => l_customer_id, p_venue_id => l_venue_id, p_formatted => true);
    dbms_output.put_line(l_json_doc);

 end;

/*
{
  "customer_id" : 529,
  "customer_name" : "Maggie Wayland",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "event_listing" :
  [
    {
      "event_id" : 621,
      "event_series_id" : null,
      "event_name" : "New Years Mischief",
      "event_date" : "2023-12-31T20:00:00",
      "event_tickets" : 9
    }
  ]
}


PL/SQL procedure successfully completed.



*/