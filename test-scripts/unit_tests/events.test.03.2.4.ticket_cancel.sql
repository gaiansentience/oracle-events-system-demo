--set ticket status to CANCELLED
--raise error if ticket is for a different event
--raise error if ticket status is VALIDATED
--raise error if ticket serial number is not found
set serveroutput on;
declare
    l_venue_id number;
    l_event_id number;
    l_customer_email varchar2(100) := 'Harry.Potter@example.customer.com';
    l_customer_id number;
    l_serial_code tickets.serial_code%type;
    l_status varchar2(50);
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'The New Toys');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

--get a specific ticket
select et.serial_code
into l_serial_code
from customer_event_tickets_v et
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, et.ticket_id
fetch first 1 row only;

    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before cancel: serial code ' || l_serial_code || ' status ' || l_status);
    begin
        event_tickets_api.ticket_cancel(p_event_id => l_event_id, p_serial_code => l_serial_code);
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('after cancel: serial code ' || l_serial_code || ' status ' || l_status);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_validated, p_use_commit => true);
    l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before cancel: serial code ' || l_serial_code || ' status ' || l_status);
    begin
        event_tickets_api.ticket_cancel(p_event_id => l_event_id, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);

    dbms_output.put_line('try to cancel a ticket with an invalid serial number');
    begin
    event_tickets_api.ticket_cancel(p_event_id => l_event_id, p_serial_code => l_serial_code || 'xxxx');
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to cancel a ticket issued for a different event');
    begin
    event_tickets_api.ticket_cancel(p_event_id => l_event_id + 1, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;


    
end;

/*
before cancel: serial code G2381C2640S71343D20220712152931Q0011I0001 status ISSUED
after cancel: serial code G2381C2640S71343D20220712152931Q0011I0001 status CANCELLED

before cancel: serial code G2381C2640S71343D20220712152931Q0011I0001 status VALIDATED
ORA-20100: Ticket has been validated for event entry, cannot cancel

try to cancel a ticket with an invalid serial number
ORA-20100: Ticket not found for serial code = G2381C2640S71343D20220712152931Q0011I0001xxxx

try to cancel a ticket issued for a different event
ORA-20100: Ticket is for different event, cannot cancel


PL/SQL procedure successfully completed.



*/