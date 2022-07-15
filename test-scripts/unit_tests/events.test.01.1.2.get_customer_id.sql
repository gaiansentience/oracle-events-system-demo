--get the custmer_id for a ticket purchase
--can also use create customer to get the id which creates the customer if it doesnt exist
set serveroutput on;
declare
    l_customer customers%rowtype;
begin

    l_customer.customer_email := 'Julius.Irving@example.customer.com';
    
    l_customer.customer_id := customer_api.get_customer_id(p_customer_email => l_customer.customer_email);
        
    dbms_output.put_line('customer found with id = ' || l_customer.customer_id);

end;

/*
customer found with id = 5021
*/