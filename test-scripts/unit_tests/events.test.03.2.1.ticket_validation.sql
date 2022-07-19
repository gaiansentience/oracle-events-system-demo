--validate ticket is used on event entry to set ticket status to VALIDATED
--ticket status must be ISSUED or REISSUED
--raise error for invalid serial number
--raise error if ticket is not issued for the event
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
    
    --force the ticket to ISSUED (allows repeatable test)
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    dbms_output.put_line('try to validate an invalid serial number');
    begin
        event_tickets_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code || 'xxxx');
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to validate the ticket for the wrong event');
    begin
        event_tickets_api.ticket_validate(p_event_id => l_event_id + 1, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('ticket is ISSUED, normal validation result');    
    begin
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('before validation: serial code ' || l_serial_code || ' status ' || l_status);    
        event_tickets_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('after validation: serial code ' || l_serial_code || ' status ' || l_status);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('force the ticket status to REISSUED, normal validation result');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_reissued, p_use_commit => true);
    begin
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('before validation: serial code ' || l_serial_code || ' status ' || l_status);    
        event_tickets_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('after validation: serial code ' || l_serial_code || ' status ' || l_status);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to revalidate the ticket with status of VALIDATED');
    begin
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('before validation: serial code ' || l_serial_code || ' status ' || l_status);    
        event_tickets_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('after validation: serial code ' || l_serial_code || ' status ' || l_status);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('force the ticket status to CANCELLED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_cancelled, p_use_commit => true);
    begin
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('before validation: serial code ' || l_serial_code || ' status ' || l_status);    
        event_tickets_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('after validation: serial code ' || l_serial_code || ' status ' || l_status);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('force the ticket status to REFUNDED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_refunded, p_use_commit => true);
    begin
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('before validation: serial code ' || l_serial_code || ' status ' || l_status);    
        event_tickets_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
        l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('after validation: serial code ' || l_serial_code || ' status ' || l_status);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    --reset the ticket to status of issued for continued testing
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);


end;


/*
try to validate an invalid serial number
ORA-20100: Ticket not found for serial code = G2381C2640S71343D20220712152931Q0011I0001xxxx

try to validate the ticket for the wrong event
ORA-20100: Ticket is for a different event, cannot validate.

ticket is ISSUED, normal validation result
before validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status ISSUED
after validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status VALIDATED

force the ticket status to REISSUED, normal validation result
before validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status REISSUED
after validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status VALIDATED

try to revalidate the ticket with status of VALIDATED
before validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status VALIDATED
ORA-20100: Ticket has already been used for event entry, cannot revalidate.

force the ticket status to CANCELLED
before validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status CANCELLED
ORA-20100: Ticket has been cancelled.  Cannot validate.

force the ticket status to REFUNDED
before validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status REFUNDED
ORA-20100: Ticket has been refunded.  Cannot validate.


PL/SQL procedure successfully completed.




*/