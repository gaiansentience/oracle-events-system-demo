--get customer information using email
--use for update customer or purchase tickets
set serveroutput on;
declare
    l_json json;
    l_customer_email customers.customer_email%type := 'Andi.Warenko@example.customer.com';
begin
    
    l_json := events_json_api.get_customer_id(p_customer_email => l_customer_email, p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/*  reply document for success
{
  "customer_id" : 5041,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}

*/