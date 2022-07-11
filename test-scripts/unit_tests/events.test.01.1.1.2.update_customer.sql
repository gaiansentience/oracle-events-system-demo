--add a new customer to the system
--if email is already in system customer_id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;
declare
    l_customer customers%rowtype;
begin

    l_customer.customer_name := 'Jules Irving';
    l_customer.customer_email := 'Julius.Irving@example.customer.com';
    
    select c.customer_id
    into l_customer.customer_id
    from customers c 
    where c.customer_email = l_customer.customer_email;    
    
    event_system.events_api.update_customer(
        p_customer_id => l_customer.customer_id,
        p_customer_name => l_customer.customer_name,
        p_customer_email => l_customer.customer_email);
    
    dbms_output.put_line('customer updated');

end;
