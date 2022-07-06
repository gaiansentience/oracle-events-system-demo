set serveroutput on;
declare
    l_customer_email varchar2(100) := 'Judy.Albright@example.customer.com';
    l_customer_id number;

l_jdoc clob :=
'
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "reseller_id" : 2,
  "reseller_name" : "MaxTix",
  "customer_email" : "Judy.Albright@example.customer.com",
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

begin

    l_customer_id := events_api.get_customer_id(p_customer_email => l_customer_email);
    
    delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = l_customer_id);
    delete from ticket_sales ts where ts.customer_id = l_customer_id;
    commit;

    events_json_api.purchase_tickets_reseller_series(l_jdoc);
    l_jdoc := events_json_api.format_json_clob(l_jdoc);
    dbms_output.put_line(l_jdoc);

end;


/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
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


PL/SQL procedure successfully completed.


*/
