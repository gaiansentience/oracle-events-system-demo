set serveroutput on;
declare
    l_customer_email varchar2(100) := 'Albert.Einstein@example.customer.com';
    l_customer_id number;
v_jdoc clob :=
'
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "customer_email" : "Albert.Einstein@example.customer.com",
  "ticket_groups" :
  [
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_requested" : 5
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_requested" : 2
    }
  ]
}
';

begin
    l_customer_id := events_api.get_customer_id(p_customer_email => l_customer_email);
    
    delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = l_customer_id);
    delete from ticket_sales ts where ts.customer_id = l_customer_id;
    commit;

    events_json_api.purchase_tickets_venue_series(v_jdoc);
    v_jdoc := events_json_api.format_json_clob(v_jdoc);
    dbms_output.put_line(v_jdoc);

end;

/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "customer_email" : "Albert.Einstein@example.customer.com",
  "ticket_groups" :
  [
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_requested" : 5,
      "average_price" : 200,
      "tickets_purchased" : 65,
      "purchase_amount" : 13000,
      "status_code" : "SUCCESS",
      "status_message" : "Tickets purchased for 13 events in the series."
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_requested" : 2,
      "average_price" : 500,
      "tickets_purchased" : 26,
      "purchase_amount" : 13000,
      "status_code" : "SUCCESS",
      "status_message" : "Tickets purchased for 13 events in the series."
    }
  ],
  "customer_id" : 4734,
  "request_status" : "SUCCESS",
  "request_errors" : 0,
  "total_tickets_requested" : 7,
  "total_tickets_purchased" : 91,
  "total_purchase_amount" : 26000,
  "purchase_disclaimer" : "All Ticket Sales Are Final."
}


PL/SQL procedure successfully completed.



*/