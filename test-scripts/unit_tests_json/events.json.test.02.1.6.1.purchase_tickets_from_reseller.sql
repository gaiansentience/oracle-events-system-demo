set serveroutput on;
declare

v_jdoc varchar2(4000) :=
'{
  "event_id" : 24,
  "reseller_id" : 11,
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

events_json_api.purchase_tickets_from_reseller(v_jdoc);
v_jdoc := events_json_api.format_json_clob(v_jdoc);
dbms_output.put_line(v_jdoc);

end;


/*
{
  "event_id" : 24,
  "reseller_id" : 11,
  "customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 39,
      "price" : 22,
      "ticket_quantity_requested" : 5,
      "price_category" : "EARLYBIRD DISCOUNT",
      "ticket_sales_id" : 28752,
      "sales_date" : "2022-06-30T15:49:39",
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
      "ticket_sales_id" : 0,
      "sales_date" : null,
      "ticket_quantity_purchased" : 0,
      "actual_price" : 22,
      "extended_price" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot purchase 6 SPONSOR tickets from reseller.  5 tickets are available from reseller.  8 tickets are available directly from venue.  No tickets are available through other resellers."
    },
    {
      "ticket_group_id" : 38,
      "price" : 42,
      "ticket_quantity_requested" : 6,
      "price_category" : "VIP",
      "ticket_sales_id" : 0,
      "sales_date" : null,
      "ticket_quantity_purchased" : 0,
      "actual_price" : 22,
      "extended_price" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot purchase 6 VIP tickets from reseller.  No tickets are available from reseller.  9 tickets are available directly from venue.  14 tickets are available through other resellers."
    }
  ],
  "customer_id" : 337,
  "request_status" : "ERRORS",
  "request_errors" : 2,
  "total_tickets_requested" : 17,
  "total_tickets_purchased" : 5,
  "total_purchase_amount" : 110,
  "purchase_disclaimer" : "All Ticket Sales Are Final."
}
*/
