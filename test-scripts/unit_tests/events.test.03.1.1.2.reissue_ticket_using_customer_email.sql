--reissue serial number for lost ticket using customer email
set serveroutput on;
declare
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';
    l_event_id number;
    l_event_name events.event_name%type := 'The New Toys';
    l_customer_id number;
    l_customer_email customers.customer_name%type := 'James.Kirk@example.customer.com';
    l_other_customer_email customers.customer_name%type := 'Harry.Potter@example.customer.com';
    l_ticket_sales_id number;
    l_ticket_id number;
    l_original_serial_code tickets.serial_code%type;
    l_new_serial_code tickets.serial_code%type;
    l_status tickets.status%type;

begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select t.ticket_id, t.serial_code, t.status into l_ticket_id, l_original_serial_code, l_status
    from customer_purchases_mv p join tickets t on p.ticket_sales_id = t.ticket_sales_id
    where p.event_id = l_event_id and p.customer_id = l_customer_id
    order by p.ticket_sales_id, t.ticket_id
    fetch first 1 row only;
    
    dbms_output.put_line('original serial code = ' || l_original_serial_code || ', status is ' || l_status);
    customer_api.ticket_reissue_using_email(p_customer_email => l_customer_email, p_serial_code => l_original_serial_code);
    
    select t.serial_code, t.status into l_new_serial_code, l_status
    from tickets t where t.ticket_id = l_ticket_id;
    dbms_output.put_line('after reissuing ticket serial code = ' || l_new_serial_code || ', status is ' || l_status);
    
    dbms_output.put_line('try to reissue the same ticket using the updated serial code');
    begin
        customer_api.ticket_reissue_using_email(p_customer_email => l_customer_email, p_serial_code => l_new_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to reissue the same ticket using the original serial code');
    begin
        customer_api.ticket_reissue_using_email(p_customer_email => l_customer_email, p_serial_code => l_original_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
    update tickets t set t.status = 'ISSUED', t.serial_code = l_original_serial_code
    where t.ticket_id = l_ticket_id;
    commit;
    
    dbms_output.put_line('reset ticket to issued state and serial code, then try to reissue for another customer');
    begin
        customer_api.ticket_reissue_using_email(p_customer_email => l_other_customer_email, p_serial_code => l_original_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
    
end;

/*
original serial code = G2383C3961S80361D20220718124146Q0021I0001, status is ISSUED
after reissuing ticket serial code = G2383C3961S80361D20220718124146Q0021I0001R, status is REISSUED

try to reissue the same ticket using the updated serial code
ORA-20100: Ticket has already been reissued, cannot reissue twice.

try to reissue the same ticket using the original serial code
ORA-01403: no data found

reset ticket to issued state and serial code, then try to reissue for another customer
ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue.

*/