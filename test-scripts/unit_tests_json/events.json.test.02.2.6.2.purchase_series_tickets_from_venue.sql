set serveroutput on;
declare

v_jdoc varchar2(4000) :=
'{
  "event_id" : 24,
  "customer_id" : 337,
  "customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 39,
      "price" : 22,
      "ticket_quantity_requested" : 5
    },
    {
      "ticket_group_id" : 37,
      "price" : 100,
      "ticket_quantity_requested" : 6
    }, 
    {
      "ticket_group_id" : 38,
      "price" : 42,
      "ticket_quantity_requested" : 6
    }
  ]
}';

begin
delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = 337);
delete from ticket_sales ts where ts.customer_id = 337;
commit;

events_json_api.purchase_tickets_from_venue(v_jdoc);
v_jdoc := events_json_api.format_json_clob(v_jdoc);
dbms_output.put_line(v_jdoc);

end;

/*
{
  "event_id" : 24,
  "customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 39,
      "price" : 22,
      "ticket_quantity_requested" : 5,
      "price_category" : "EARLYBIRD DISCOUNT",
      "ticket_sales_id" : 28753,
      "sales_date" : "2022-06-30T15:50:46",
      "ticket_quantity_purchased" : 5,
      "actual_price" : 22,
      "extended_price" : 110,
      "status_code" : "SUCCESS",
      "status_message" : "5 group tickets purchased."
    },
    {
      "ticket_group_id" : 37,
      "price" : 100,
      "ticket_quantity_requested" : 6,
      "price_category" : "SPONSOR",
      "ticket_sales_id" : 28754,
      "sales_date" : "2022-06-30T15:50:46",
      "ticket_quantity_purchased" : 6,
      "actual_price" : 100,
      "extended_price" : 600,
      "status_code" : "SUCCESS",
      "status_message" : "6 group tickets purchased."
    },
    {
      "ticket_group_id" : 38,
      "price" : 42,
      "ticket_quantity_requested" : 6,
      "price_category" : "VIP",
      "ticket_sales_id" : 28755,
      "sales_date" : "2022-06-30T15:50:46",
      "ticket_quantity_purchased" : 6,
      "actual_price" : 42,
      "extended_price" : 252,
      "status_code" : "SUCCESS",
      "status_message" : "6 group tickets purchased."
    }
  ],
  "customer_id" : 337,
  "request_status" : "SUCCESS",
  "request_errors" : 0,
  "total_tickets_requested" : 17,
  "total_tickets_purchased" : 17,
  "total_purchase_amount" : 962,
  "purchase_disclaimer" : "All Ticket Sales Are Final."
}
*/