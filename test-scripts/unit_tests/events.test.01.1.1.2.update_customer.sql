--add a new customer to the system
--if email is already in system customer_id for that email will be returned
--if customer already exists customer name will be updated
set serveroutput on;
declare
    l_customer customers%rowtype;
begin

    l_customer.customer_name := 'Jules Irving';
    l_customer.customer_email := 'Julius.Irving@example.customer.com';
    
    l_customer.customer_id := customer_api.get_customer_id(p_customer_email => l_customer.customer_email);
    
    begin
    
        customer_api.update_customer(
            p_customer_id => l_customer.customer_id,
            p_customer_name => l_customer.customer_name,
            p_customer_email => l_customer.customer_email);
    
        dbms_output.put_line('customer updated');

    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
end;
