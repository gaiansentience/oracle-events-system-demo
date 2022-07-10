

set serveroutput on;
declare
    l_ticket_group_id number;
    l_serial_code tickets.serial_code%type;
begin

    event_api.ticket_verify_restricted_access(p_ticket_group_id => l_ticket_group_id, p_serial_code => l_serial_code);
    
end;