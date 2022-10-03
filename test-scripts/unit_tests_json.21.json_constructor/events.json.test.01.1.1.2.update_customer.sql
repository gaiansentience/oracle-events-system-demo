--create customer using a json document
--if customer email already exists customer id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;
declare
    l_json_doc clob;
    l_json json;    
    l_customer_id number;
    l_email customers.customer_email%type := 'Andi.Warenko@example.customer.com';
    l_name customers.customer_name%type := 'Andrea Warenko';
begin

    l_customer_id := customer_api.get_customer_id(p_customer_email => l_email);

l_json_doc := 
'
{
  "customer_id" : $$CUSTOMER$$,
  "customer_name" : "$$NAME$$",
  "customer_email" : "$$EMAIL$$"
}
';

    l_json_doc := replace(l_json_doc, '$$CUSTOMER$$', l_customer_id);
    l_json_doc := replace(l_json_doc, '$$NAME$$', l_name);
    l_json_doc := replace(l_json_doc, '$$EMAIL$$', l_email);

    l_json := json(l_json_doc);

    
   events_json_api.update_customer(p_json_doc => l_json);
   dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/*  reply document for success
{
  "customer_id" : 5041,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "status_code" : "SUCCESS",
  "status_message" : "Updated customer"
}
*/