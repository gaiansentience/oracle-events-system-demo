set serveroutput on;
declare
    l_event_id number;
    l_serial_code tickets.serial_code%type;
begin

    event_api.ticket_verify_validation(p_event_id => l_event_id, p_serial_code => l_serial_code);
    
end;