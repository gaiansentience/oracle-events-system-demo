--get customer information using id
--use for update customer
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_customer_id number;
    l_email customers.customer_email%type := 'Andi.Warenko@example.customer.com';
begin

    l_customer_id := customer_api.get_customer_id(p_customer_email => l_email);

    
    l_json_doc := events_json_api.get_customer(p_customer_id => l_customer_id, p_formatted => true);    
    dbms_output.put_line(l_json_doc);

 end;

/*  reply document for success
{
  "customer_id" : 5041,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}
*/