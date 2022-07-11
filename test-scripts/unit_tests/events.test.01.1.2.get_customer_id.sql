--get the custmer_id for a ticket purchase
--can also use create customer to get the id which creates the customer if it doesnt exist
set serveroutput on;

declare
    v_customer customers%rowtype;
begin

    v_customer.customer_email := 'Julius.Irving@example.customer.com';
    
    v_customer.customer_id := events_api.get_customer_id(v_customer.customer_email);
        
    dbms_output.put_line('customer found with id = ' || v_customer.customer_id);

end;

/*
customer found with id = 4941
*/