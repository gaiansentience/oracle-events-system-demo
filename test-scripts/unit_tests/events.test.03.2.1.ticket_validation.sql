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
    
    --force the ticket to ISSUED (allows repeatable test)
    update tickets t set t.status = 'ISSUED' where t.serial_code = upper(l_serial_code);
    commit;
    
    dbms_output.put_line('try to validate an invalid serial number');
    begin
        events_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code || 'xxxx');
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;


    dbms_output.put_line('try to validate the ticket for the wrong event');
    begin
        events_api.ticket_validate(p_event_id => l_event_id + 1, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before validation: serial code ' || l_serial_code || ' status ' || l_status);    
    events_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('after validation: serial code ' || l_serial_code || ' status ' || l_status);

    dbms_output.put_line('force the ticket status to REISSUED');
    update tickets t set t.status = 'REISSUED' where t.serial_code = upper(l_serial_code);
    commit;

    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before validation: serial code ' || l_serial_code || ' status ' || l_status);    
    events_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('after validation: serial code ' || l_serial_code || ' status ' || l_status);

    dbms_output.put_line('try to revalidate the ticket with status of VALIDATED');
    begin
        events_api.ticket_validate(p_event_id => l_event_id, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

end;


/*
try to validate an invalid serial number
ORA-20100: Ticket serial code not found for event, cannot validate

try to validate the ticket for the wrong event
ORA-20100: Ticket is for a different event, cannot validate.

before validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status ISSUED
after validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status VALIDATED

force the ticket status to REISSUED
before validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status REISSUED
after validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status VALIDATED

try to revalidate the ticket with status of VALIDATED
ORA-20100: Ticket has already been used for event entry, cannot revalidate.

*/