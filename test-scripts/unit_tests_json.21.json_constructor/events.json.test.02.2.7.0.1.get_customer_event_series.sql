--get venue information as a json document
set serveroutput on;
declare
    l_json json;
    l_customer_id number;
    l_customer_email varchar2(100) := 'Albert.Einstein@example.customer.com';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    l_json := events_json_api.get_customer_event_series(p_customer_id => l_customer_id, p_venue_id => l_venue_id, p_formatted => true);   
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/* 

{
  "customer_id" : 4734,
  "customer_name" : "Albert Einstein",
  "customer_email" : "Albert.Einstein@example.customer.com",
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_listing" :
  [
    {
      "event_series_id" : 81,
      "event_series_name" : "Monster Truck Smashup",
      "first_event_date" : "2023-06-07T19:00:00",
      "last_event_date" : "2023-08-30T19:00:00",
      "series_events" : 13,
      "series_tickets" : 91
    }
  ]
}


PL/SQL procedure successfully completed.


*/