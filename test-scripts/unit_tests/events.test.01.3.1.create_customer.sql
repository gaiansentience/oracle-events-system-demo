--add a new customer to the system
--if email is already in system customer_id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;

declare
    v_customer customers%rowtype;
begin

    v_customer.customer_name := 'Julius Irving';
    v_customer.customer_email := 'Julius.Irving@example.customer.com';
    
    event_system.events_api.create_customer(
        p_customer_name => v_customer.customer_name,
        p_customer_email => v_customer.customer_email,
        p_customer_id => v_customer.customer_id);
    
    dbms_output.put_line('customer created with id = ' || v_customer.customer_id);

end;
