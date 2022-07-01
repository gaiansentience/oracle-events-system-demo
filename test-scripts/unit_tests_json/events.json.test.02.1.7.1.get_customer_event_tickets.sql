--get venue information as a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
  v_event_id number := 22;
  v_customer_id number := 15;   --517, 919
begin

   v_json_doc := events_json_api.get_customer_event_tickets(
                                            p_customer_id => v_customer_id, 
                                            p_event_id => v_event_id, 
                                            p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*  customer purchased tickets from reseller and directly from venue

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



/*  customer or event does not exist or customer did not purchase tickets for the event
{
  "json_method" : "get_customer_event_tickets",
  "error_code" : 100,
  "error_message" : "ORA-01403: no data found"
}
*/