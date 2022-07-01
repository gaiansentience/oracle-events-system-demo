--get venue information as a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
  v_event_id number := 122;
  v_customer_email varchar2(50) := 'Katherine.Bikram@example.customer.com';
begin

   v_json_doc := events_json_api.get_customer_event_tickets_by_email(p_customer_email => v_customer_email, p_event_id => v_event_id, p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*  customer purchased tickets
{
  "customer_id" : 15,
  "customer_name" : "Katherine Bikram",
  "customer_email" : "Katherine.Bikram@example.customer.com",
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_id: " : 22,
  "event_name" : "The Electric Blues Garage Band",
  "event_date" : "2022-07-15T22:33:47",
  "total_tickets_purchased" : 18,
  "event_ticket_purchases" :
  [
    {
      "price_category" : "VIP",
      "ticket_quantity" : 4,
      "sales_date" : "2022-05-06T22:34:22",
      "purchased_from" : "Ticketron"
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "ticket_quantity" : 4,
      "sales_date" : "2022-05-06T22:33:52",
      "purchased_from" : "Your Ticket Supplier"
    },
    {
      "price_category" : "VIP",
      "ticket_quantity" : 10,
      "sales_date" : "2022-05-06T22:33:52",
      "purchased_from" : "VENUE DIRECT SALES "
    }
  ]
}
*/


/*  customer does not exist or customer did not purchase tickets
{
   "json_method":"get_customer_tickets_by_email",
   "error_code":100,
   "error_message":"ORA-01403: no data found"
}
*/