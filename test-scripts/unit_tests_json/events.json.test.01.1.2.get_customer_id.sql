--create customer using a json document
--if customer email already exists customer id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc := 
'{
  "customer_name" : "Andi Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}';

    --not implemented
   events_json_api.get_customer_id(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success

*/