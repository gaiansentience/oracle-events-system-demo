--get venue information as a json document
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_venue_id number;
    l_event_id number;
    l_customer_email varchar2(50) := 'John.Kirby@example.customer.com';
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'Another Roadside Attraction');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'New Years Mischief');
    l_json_doc := events_json_api.get_customer_event_tickets_by_email(p_customer_email => l_customer_email, p_event_id => l_event_id, p_formatted => true);
   
    dbms_output.put_line(l_json_doc);

 end;

/*  customer purchased tickets
{
  "customer_id" : 1910,
  "customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 581,
  "event_series_id" : null,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets" : 9,
  "event_ticket_purchases" :
  [
    {
      "ticket_group_id" : 2322,
      "price_category" : "VIP",
      "ticket_sales_id" : 71143,
      "ticket_quantity" : 3,
      "sales_date" : "2022-07-06T12:09:35",
      "reseller_id" : null,
      "reseller_name" : "VENUE DIRECT SALES"
    },
    {
      "ticket_group_id" : 2323,
      "price_category" : "GENERAL ADMISSION",
      "ticket_sales_id" : 71144,
      "ticket_quantity" : 6,
      "sales_date" : "2022-07-06T12:09:35",
      "reseller_id" : null,
      "reseller_name" : "VENUE DIRECT SALES"
    }
  ]
}


PL/SQL procedure successfully completed.



  customer does not exist or customer did not purchase tickets
{
  "json_method" : "get_customer_event_tickets",
  "error_code" : 100,
  "error_message" : "ORA-01403: no data found"
}


*/