set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc clob;
    l_json json;

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
    "action" : "ticket-verify-validation",
    "event_id" : $$EVENT$$,
    "serial_code" : "$$SERIAL$$"
}        
';
l_json_doc := replace(l_json_template, '$$EVENT$$', l_event_id);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code);

    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    dbms_output.put_line('force the ticket status to ISSUED');
    
    l_json := json(l_json_doc);    
    events_json_api.ticket_verify_validation(p_json_doc => l_json);   
    dbms_output.put_line(events_json_api.json_as_clob(l_json));


    dbms_output.put_line('force the ticket status to VALIDATED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_validated, p_use_commit => true);

    l_json := json(l_json_doc);
    events_json_api.ticket_verify_validation(p_json_doc => l_json);   
    dbms_output.put_line(events_json_api.json_as_clob(l_json));


l_json_doc := replace(l_json_template, '$$EVENT$$', l_event_id + 1);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code);

    dbms_output.put_line('use a ticket from the wrong event');

    l_json := json(l_json_doc);
    events_json_api.ticket_verify_validation(p_json_doc => l_json);   
    dbms_output.put_line(events_json_api.json_as_clob(l_json));


l_json_doc := replace(l_json_template, '$$EVENT$$', l_event_id);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code || 'xxxxx');

    dbms_output.put_line('use a ticket with an invalid serial code');

    l_json := json(l_json_doc);
    events_json_api.ticket_verify_validation(p_json_doc => l_json);   
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

    --reset the ticket to issued for other testing
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);


end;


/*

force the ticket status to ISSUED
{
  "action" : "ticket-verify-validation",
  "event_id" : 621,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket has not been validated for event entry."
}
force the ticket status to VALIDATED
{
  "action" : "ticket-verify-validation",
  "event_id" : 621,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "SUCCESS",
  "status_message" : "VERIFIED"
}
use a ticket from the wrong event
{
  "action" : "ticket-verify-validation",
  "event_id" : 622,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket is for different event, cannot verify."
}
use a ticket with an invalid serial code
{
  "action" : "ticket-verify-validation",
  "event_id" : 621,
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001xxxxx",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket not found for serial code = G2442C529S80201D20220713120938Q0003I0001xxxxx"
}


PL/SQL procedure successfully completed.


*/
