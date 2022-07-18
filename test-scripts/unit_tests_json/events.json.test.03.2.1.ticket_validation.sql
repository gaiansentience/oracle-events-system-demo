set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc varchar2(4000);
    l_venue_id number;
    l_event_id number;    
    l_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    l_customer_id number;    
    l_serial_code varchar2(100);
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => 'Another Roadside Attraction');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'New Years Mischief');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
--get a specific ticket
select et.serial_code
into l_serial_code
from customer_event_tickets_v et
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, et.ticket_id
fetch first 1 row only;    

l_json_template := 
'
{
    "action" : "ticket-validate",
    "event_id" : $$EVENT$$,
    "serial_code" : "$$SERIAL$$"
}    
';
l_json_doc := replace(l_json_template, '$$EVENT$$', l_event_id);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code);

    dbms_output.put_line('force the ticket to ISSUED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    events_json_api.ticket_validate(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

    dbms_output.put_line('force the ticket to REISSUED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_reissued, p_use_commit => true);
    events_json_api.ticket_validate(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

    dbms_output.put_line('try to revalidate the same ticket');
    events_json_api.ticket_validate(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);

l_json_doc := replace(l_json_template, '$$EVENT$$', l_event_id + 1);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code);
    dbms_output.put_line('try to validate the ticket for a different event');
    events_json_api.ticket_validate(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));


l_json_doc := replace(l_json_template, '$$EVENT$$', l_event_id);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code || 'xxxx');
    dbms_output.put_line('try to validate a ticket with an invalid serial number');
    events_json_api.ticket_validate(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

    
end;

/*
force the ticket to ISSUED
{
  "action" : "ticket-validate",
  "event_id" : 621,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "SUCCESS",
  "status_message" : "VALIDATED"
}
force the ticket to REISSUED
{
  "action" : "ticket-validate",
  "event_id" : 621,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "SUCCESS",
  "status_message" : "VALIDATED"
}
try to revalidate the same ticket
{
  "action" : "ticket-validate",
  "event_id" : 621,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket has already been used for event entry, cannot revalidate."
}
try to validate the ticket for a different event
{
  "action" : "ticket-validate",
  "event_id" : 622,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket is for a different event, cannot validate."
}
try to validate a ticket with an invalid serial number
{
  "action" : "ticket-validate",
  "event_id" : 621,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001xxxx",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket not found for serial code = G2442C529S80201D20220713120938Q0003I0001xxxx"
}


PL/SQL procedure successfully completed.



*/
