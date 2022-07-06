set serveroutput on;
declare
    l_customer_id number;
    l_jdoc varchar2(4000) :=
'
{
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "reseller_id" : 3,
  "reseller_name" : "Old School",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 2322,
      "price_category" : "VIP",
      "price" : 80,
      "tickets_requested" : 3      
    },
    {
      "ticket_group_id" : 2323,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_requested" : 6      
    }
  ]
}
';

begin

    l_customer_id := events_api.get_customer_id(p_customer_email => 'Maggie.Wayland@example.customer.com');
    
    delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = l_customer_id);
    delete from ticket_sales ts where ts.customer_id = l_customer_id;
    commit;

    events_json_api.purchase_tickets_reseller(l_jdoc);
    l_jdoc := events_json_api.format_json_clob(l_jdoc);
    dbms_output.put_line(l_jdoc);

end;


/*
{
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "reseller_id" : 3,
  "reseller_name" : "Old School",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 2322,
      "price" : 80,
      "tickets_requested" : 3,
      "price_category" : "VIP",
      "ticket_sales_id" : 71141,
      "actual_price" : 80,
      "tickets_purchased" : 3,
      "purchase_amount" : 240,
      "status_code" : "SUCCESS",
      "status_message" : "group tickets purchased"
    },
    {
      "ticket_group_id" : 2323,
      "price" : 50,
      "tickets_requested" : 6,
      "price_category" : "GENERAL ADMISSION",
      "ticket_sales_id" : 71142,
      "actual_price" : 50,
      "tickets_purchased" : 6,
      "purchase_amount" : 300,
      "status_code" : "SUCCESS",
      "status_message" : "group tickets purchased"
    }
  ],
  "customer_id" : 529,
  "request_status" : "SUCCESS",
  "request_errors" : 0,
  "total_tickets_requested" : 9,
  "total_tickets_purchased" : 9,
  "total_purchase_amount" : 540,
  "purchase_disclaimer" : "All Ticket Sales Are Final."
}


PL/SQL procedure successfully completed.


*/
