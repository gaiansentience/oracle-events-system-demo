--create event using a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc := 
'{
  "customer_name" : "Andi Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}';

   events_json_api.create_customer(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success
{
  "customer_name" : "Andi Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "customer_id" : 1041,
  "status_code" : "SUCCESS",
  "status_message" : "Created customer"
}
*/

/*  reply document for duplicate existing customer email
    --??should this give current customer id for the email?
{
  "customer_name" : "Andi Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "customer_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-00001: unique constraint (TOPTAL.CUSTOMERS_U_CUSTOMER_EMAIL) violated"
}
*/