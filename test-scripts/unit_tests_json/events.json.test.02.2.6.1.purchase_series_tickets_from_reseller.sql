set serveroutput on;
declare
    l_json_doc clob;

    l_customer_email varchar2(100) := 'Judy.Albright@example.customer.com';
    l_customer_id number;
    l_reseller_id number;
    l_reseller_name resellers.reseller_name%type := 'MaxTix';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';    
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_reseller_id := events_api.get_reseller_id(p_reseller_name => l_reseller_name);
    l_customer_id := events_api.get_customer_id(p_customer_email => l_customer_email);
    
    delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = l_customer_id);
    delete from ticket_sales ts where ts.customer_id = l_customer_id;
    commit;

l_json_doc :=
'
{
  "event_series_id" : $$EVENT_SERIES_ID$$,
  "event_name" : "$$SERIES_NAME$$",
  "reseller_id" : $$RESELLER_ID$$,
  "reseller_name" : "$$RESELLER$$",
  "customer_email" : "$$CUSTOMER_EMAIL$$",
  "ticket_groups" :
  [
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_requested" : 8
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_requested" : 4
    }
  ]
}
';

l_json_doc := replace(l_json_doc, '$$EVENT_SERIES_ID$$', l_event_series_id);
l_json_doc := replace(l_json_doc, '$$SERIES_NAME$$', l_event_name);
l_json_doc := replace(l_json_doc, '$$RESELLER_ID$$', l_reseller_id);
l_json_doc := replace(l_json_doc, '$$RESELLER$$', l_reseller_name);
l_json_doc := replace(l_json_doc, '$$CUSTOMER_EMAIL$$', l_customer_email);

    events_json_api.purchase_tickets_reseller_series(l_json_doc);
    l_json_doc := events_json_api.format_json_clob(l_json_doc);
    dbms_output.put_line(l_json_doc);

end;


/*

{
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "reseller_id" : 2,
  "reseller_name" : "MaxTix",
  "customer_email" : "Judy.Albright@example.customer.com",
  "ticket_groups" :
  [
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_requested" : 8,
      "average_price" : 200,
      "tickets_purchased" : 104,
      "purchase_amount" : 20800,
      "status_code" : "SUCCESS",
      "status_message" : "Tickets purchased for 13 events in the series."
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_requested" : 4,
      "average_price" : 350,
      "tickets_purchased" : 52,
      "purchase_amount" : 18200,
      "status_code" : "SUCCESS",
      "status_message" : "Tickets purchased for 13 events in the series."
    }
  ],
  "customer_id" : 513,
  "request_status" : "SUCCESS",
  "request_errors" : 0,
  "total_tickets_requested" : 12,
  "total_tickets_purchased" : 156,
  "total_purchase_amount" : 39000,
  "purchase_disclaimer" : "All Ticket Sales Are Final."
}


*/
