--verify that the ticket status has been set to VALIDATED on entry to the event
--raise error for any other status
--raise error if ticket serial number is not found
--raise error if ticket is issued for a different event
set serveroutput on;
declare
    l_venue_id number;
    l_event_id number;
    l_customer_email varchar2(100) := 'Harry.Potter@example.customer.com';
    l_customer_id number;
    l_serial_code tickets.serial_code%type;
    l_status varchar2(50);
begin
    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'The New Toys');
    l_customer_id := events_api.get_customer_id(p_customer_email => l_customer_email);

--get a specific ticket
select t.serial_code
into l_serial_code
from 
customer_event_tickets_v et
join tickets t on et.ticket_sales_id = t.ticket_sales_id
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, t.ticket_id
fetch first 1 row only;

    update tickets t set t.status = 'VALIDATED' where t.serial_code = upper(l_serial_code);
    commit;
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before verify validation: serial code ' || l_serial_code || ' status ' || l_status);
    begin
    events_api.ticket_verify_validation(p_event_id => l_event_id, p_serial_code => l_serial_code);
    dbms_output.put_line('validation verified');
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
    dbms_output.put_line('try to verify a ticket from a different event');
    begin
    events_api.ticket_verify_validation(p_event_id => l_event_id + 1, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to verify a ticket with an invalid serial code');
    begin
    events_api.ticket_verify_validation(p_event_id => l_event_id, p_serial_code => l_serial_code || 'xxxx');
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;


    update tickets t set t.status = 'ISSUED' where t.serial_code = upper(l_serial_code);
    commit;
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before verify validation: serial code ' || l_serial_code || ' status ' || l_status);
    begin
    events_api.ticket_verify_validation(p_event_id => l_event_id, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    update tickets t set t.status = 'CANCELLED' where t.serial_code = upper(l_serial_code);
    commit;
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before verify validation: serial code ' || l_serial_code || ' status ' || l_status);
    begin
    events_api.ticket_verify_validation(p_event_id => l_event_id, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    --set the ticket back to validated state for next test
    update tickets t set t.status = 'VALIDATED' where t.serial_code = upper(l_serial_code);
    commit;
    
end;


/*

before verify validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status VALIDATED
validation verified

try to verify a ticket from a different event
ORA-20100: Ticket is for different event, cannot verify.

try to verify a ticket with an invalid serial code
ORA-20100: Ticket serial code not found for event, cannot validate

before verify validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status ISSUED
ORA-20100: Ticket has not been validated for event entry.

before verify validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status CANCELLED
ORA-20100: Ticket has not been validated for event entry.

*/