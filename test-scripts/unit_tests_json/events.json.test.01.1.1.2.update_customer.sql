--create customer using a json document
--if customer email already exists customer id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc := 
'{
  "customer_name" : "Andi Warenkov",
  "customer_email" : "Andi.Warenko@example.customer.com"
}';

   events_json_api.create_customer(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success
{
  "customer_name" : "Andi Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "customer_id" : 4981,
  "status_code" : "SUCCESS",
  "status_message" : "Created customer"
}

--if email exists then customer id is returned
--if existing customer and name is different name is updated
{
  "customer_name" : "Andi Warenkov",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "customer_id" : 4981,
  "status_code" : "SUCCESS",
  "status_message" : "Created customer"
}

*/