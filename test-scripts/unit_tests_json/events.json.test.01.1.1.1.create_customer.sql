--create customer using a json document
--if customer email already exists customer id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_email customers.customer_email%type := 'Andi.Warenko@example.customer.com';
    l_name customers.customer_name%type := 'Andi Warenkovna';    
begin

l_json_doc := 
'
{
  "customer_name" : "$$NAME$$",
  "customer_email" : "$$EMAIL$$"
}
';

    l_json_doc := replace(l_json_doc, '$$NAME$$', l_name);
    l_json_doc := replace(l_json_doc, '$$EMAIL$$', l_email);


    events_json_api.create_customer(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

 end;

/*  reply document for success
{
  "customer_name" : "Andi Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "customer_id" : 5041,
  "status_code" : "SUCCESS",
  "status_message" : "Created customer"
}

--if email exists then customer id is returned
--if existing customer and name is different name is updated
{
  "customer_name" : "Andi Warenkovna",
  "customer_email" : "Andi.Warenko@example.customer.com",
  "customer_id" : 5041,
  "status_code" : "SUCCESS",
  "status_message" : "Created customer"
}
*/