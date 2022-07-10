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

    update tickets t set t.status = 'ISSUED' where t.serial_code = upper(l_serial_code);
    commit;
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before cancel: serial code ' || l_serial_code || ' status ' || l_status);
    begin
        events_api.ticket_cancel(p_event_id => l_event_id, p_serial_code => l_serial_code);
        l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
        dbms_output.put_line('after cancel: serial code ' || l_serial_code || ' status ' || l_status);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
    update tickets t set t.status = 'VALIDATED' where t.serial_code = upper(l_serial_code);
    commit;
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before cancel: serial code ' || l_serial_code || ' status ' || l_status);
    begin
        events_api.ticket_cancel(p_event_id => l_event_id, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    update tickets t set t.status = 'ISSUED' where t.serial_code = upper(l_serial_code);
    commit;

    dbms_output.put_line('try to cancel a ticket with an invalid serial number');
    begin
    events_api.ticket_cancel(p_event_id => l_event_id, p_serial_code => l_serial_code || 'xxxx');
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to cancel a ticket issued for a different event');
    begin
    events_api.ticket_cancel(p_event_id => l_event_id + 1, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;


    
end;

/*
before cancel: serial code G2229C2640S55997D20220701161539Q0011I0001 status ISSUED
after cancel: serial code G2229C2640S55997D20220701161539Q0011I0001 status CANCELLED
before cancel: serial code G2229C2640S55997D20220701161539Q0011I0001 status VALIDATED
ORA-20100: Ticket has been validated for event entry, cannot cancel
try to cancel a ticket with an invalid serial number
ORA-20100: Ticket serial code not found for event, cannot cancel
try to cancel a ticket issued for a different event
ORA-20100: Ticket is for different event, cannot cancel

*/