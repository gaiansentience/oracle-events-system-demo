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

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'The New Toys');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

--get a specific ticket and its ticket group id
select et.serial_code, et.ticket_group_id
into l_serial_code, l_ticket_group_id
from customer_event_tickets_v et
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, et.ticket_id
fetch first 1 row only;

    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_validated, p_use_commit => true);
    l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before verify validation: serial code ' || l_serial_code || ' status ' || l_status);
    event_tickets_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id, p_serial_code => l_serial_code);
    dbms_output.put_line('access verified');

    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    l_status := event_tickets_api.get_ticket_status(p_serial_code => l_serial_code);
    dbms_output.put_line('before verify validation: serial code ' || l_serial_code || ' status ' || l_status);
    begin
        event_tickets_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id, p_serial_code => l_serial_code);
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_validated, p_use_commit => true);
    
    select tg.ticket_group_id into l_other_ticket_group_id from ticket_groups tg where tg.event_id = l_event_id and tg.ticket_group_id <> l_ticket_group_id
    fetch first 1 row only;
    dbms_output.put_line('try to verify access for another ticket group');
    begin
        event_tickets_api.ticket_verify_restricted_access(p_ticket_group_id => l_other_ticket_group_id, p_serial_code => l_serial_code);    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to verify access for an invalid ticket serial code');
    begin
        event_tickets_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id, p_serial_code => l_serial_code || 'xxxx');    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('try to verify access for an invalid ticket group id');
    begin
        event_tickets_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id + 999, p_serial_code => l_serial_code);    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;

    --reset ticket to issued
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);

end;

/*
before verify validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status VALIDATED
access verified

before verify validation: serial code G2381C2640S71343D20220712152931Q0011I0001 status ISSUED
ORA-20100: Ticket has not been validated for event entry, cannot verify access for status ISSUED

try to verify access for another ticket group
ORA-20100: Ticket is for VIP, ticket not valid for BACKSTAGE

try to verify access for an invalid ticket serial code
ORA-20100: Ticket not found for serial code = G2381C2640S71343D20220712152931Q0011I0001xxxx

try to verify access for an invalid ticket group id
ORA-01403: no data found


PL/SQL procedure successfully completed.

*/