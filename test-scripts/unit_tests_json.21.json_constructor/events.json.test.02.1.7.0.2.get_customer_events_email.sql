set serveroutput on;
declare
    l_json json;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_customer_email varchar2(50) := 'John.Kirby@example.customer.com';
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);

    l_json := events_json_api.get_customer_events_by_email(p_customer_email => l_customer_email, p_venue_id => l_venue_id, p_formatted => true);   
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

end;

/*  
{
  "customer_id" : 1910,
  "customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
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