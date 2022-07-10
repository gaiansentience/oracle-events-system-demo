--verify that the ticket can enter a restricted area (ie, VIP seating)
--raise error if ticket is not valid for ticket group
--raise error if ticket status is not VALIDATED
--raise error if ticket serial number is not found or ticket group is not found
set serveroutput on;
declare
    l_venue_id number;
    l_event_id number;
    l_customer_email varchar2(100) := 'Harry.Potter@example.customer.com';
    l_customer_id number;
    l_serial_code tickets.serial_code%type;
    l_status varchar2(50);

    l_ticket_group_id number;
    l_other_ticket_group_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'The New Toys');
    l_customer_id := events_api.get_customer_id(p_customer_email => l_customer_email);

--get a specific ticket and its ticket group id
select t.serial_code, et.ticket_group_id
into l_serial_code, l_ticket_group_id
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
    events_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id, p_serial_code => l_serial_code);
    dbms_output.put_line('access verified');

    update tickets t set t.status = 'ISSUED' where t.serial_code = upper(l_serial_code);
    commit;
    l_status := events_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before verify validation: serial code ' || l_serial_code || ' status ' || l_status);
    begin
        events_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    update tickets t set t.status = 'VALIDATED' where t.serial_code = upper(l_serial_code);
    commit;
    
    select tg.ticket_group_id into l_other_ticket_group_id from ticket_groups tg where tg.event_id = l_event_id and tg.ticket_group_id <> l_ticket_group_id
    fetch first 1 row only;
    dbms_output.put_line('try to verify access for another ticket group');
    begin
        events_api.ticket_verify_restricted_access(p_ticket_group_id => l_other_ticket_group_id, p_serial_code => l_serial_code);    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to verify access for an invalid ticket serial code');
    begin
        events_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id, p_serial_code => l_serial_code || 'xxxx');    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to verify access for an invalid ticket group id');
    begin
        events_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id + 999, p_serial_code => l_serial_code);    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;


end;

/*
before verify validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status VALIDATED
access verified

before verify validation: serial code G2229C2640S55997D20220701161539Q0011I0001 status ISSUED
ORA-20100: Ticket has not been validated for event entry, cannot verify access for status ISSUED

try to verify access for another ticket group
ORA-20100: Ticket is for VIP, ticket not valid for BACKSTAGE

try to verify access for an invalid ticket serial code
ORA-01403: no data found

try to verify access for an invalid ticket group id
ORA-01403: no data found
*/