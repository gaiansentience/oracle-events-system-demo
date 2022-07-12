--create customer using a json document
--if customer email already exists customer id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc := 
'
{
  "customer_id" : 5003,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}
';

   events_json_api.update_customer(p_json_doc => v_json_doc);
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success
{
  "customer_id" : 5003,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "status_code" : "SUCCESS",
  "status_message" : "Updated customer"
}

*/