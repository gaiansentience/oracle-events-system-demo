--get customer information using id
--use for update customer
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_customer_id number;
begin

    select c.customer_id into l_customer_id
    from customers c where c.customer_email = 'Andi.Warenko@example.customer.com';
    
    l_json_doc := events_json_api.get_customer(p_customer_id => l_customer_id, p_formatted => true);
    
    dbms_output.put_line(l_json_doc);

 end;

/*  reply document for success
{
  "customer_id" : 5003,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}

*/