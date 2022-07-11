--get customer information using email
--use for update customer or purchase tickets
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_customer_email customers.customer_email%type := 'Andi.Warenko@example.customer.com';
begin
    
    l_json_doc := events_json_api.get_customer_id(p_customer_email => l_customer_email, p_formatted => true);
    dbms_output.put_line(l_json_doc);

 end;

/*  reply document for success
{
  "customer_id" : 5003,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}

*/