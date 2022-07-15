--use test for get_tickets_available_all or get_tickets_available_reseller to get ticket_group_id values for request
set serveroutput on;
declare
    l_event_name events.event_name%type := 'New Years Mischief';
    l_event_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_venue_id number;
    l_customer_id number;
    l_customer_email customers.customer_email%type := 'John.Kirby@example.customer.com';
    l_jdoc varchar2(4000);
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = l_customer_id);
    delete from ticket_sales ts where ts.customer_id = l_customer_id;
    commit;

l_jdoc :=
'
{
  "event_id" : $$EVENT_ID$$,
  "event_name" : "$$EVENT_NAME$$",
  "customer_email" : "$$CUSTOMER_EMAIL$$",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 2442,
      "price_category" : "VIP",
      "price" : 80,
      "tickets_requested" : 3      
    },
    {
      "ticket_group_id" : 2443,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_requested" : 6      
    }
  ]
}
';

    l_jdoc := replace(l_jdoc, '$$EVENT_ID$$', l_event_id);
    l_jdoc := replace(l_jdoc, '$$EVENT_NAME$$', l_event_name);
    l_jdoc := replace(l_jdoc, '$$CUSTOMER_EMAIL$$', l_customer_email);

    events_json_api.purchase_tickets_venue(l_jdoc);
    l_jdoc := events_json_api.format_json_clob(l_jdoc);
    dbms_output.put_line(l_jdoc);

end;

/*

{
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 2442,
      "price" : 80,
      "tickets_requested" : 3,
      "price_category" : "VIP",
      "ticket_sales_id" : 80203,
      "actual_price" : 80,
      "tickets_purchased" : 3,
      "purchase_amount" : 240,
      "status_code" : "SUCCESS",
      "status_message" : "group tickets purchased"
    },
    {
      "ticket_group_id" : 2443,
      "price" : 50,
      "tickets_requested" : 6,
      "price_category" : "GENERAL ADMISSION",
      "ticket_sales_id" : 80204,
      "actual_price" : 50,
      "tickets_purchased" : 6,
      "purchase_amount" : 300,
      "status_code" : "SUCCESS",
      "status_message" : "group tickets purchased"
    }
  ],
  "customer_id" : 1910,
  "request_status" : "SUCCESS",
  "request_errors" : 0,
  "total_tickets_requested" : 9,
  "total_tickets_purchased" : 9,
  "total_purchase_amount" : 540,
  "purchase_disclaimer" : "All Ticket Sales Are Final."
}
*/