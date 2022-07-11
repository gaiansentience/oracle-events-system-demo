--add a new customer to the system
--if email is already in system customer_id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;

declare
    l_customer customers%rowtype;
begin

    l_customer.customer_name := 'Julius Irving';
    l_customer.customer_email := 'Julius.Irving@example.customer.com';
    
    event_system.events_api.create_customer(
        p_customer_name => l_customer.customer_name,
        p_customer_email => l_customer.customer_email,
        p_customer_id => l_customer.customer_id);
    
    dbms_output.put_line('customer created with id = ' || l_customer.customer_id);

end;

/*
customer created with id = 4941
*/