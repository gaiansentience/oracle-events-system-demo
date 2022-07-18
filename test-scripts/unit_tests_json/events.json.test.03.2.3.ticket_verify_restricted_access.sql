set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc varchar2(4000);
    l_venue_id number;
    l_event_id number;    
    l_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    l_customer_id number;    
    l_serial_code varchar2(100);
    l_ticket_group_id number;
    l_price_category ticket_groups.price_category%type;
    l_other_ticket_group_id number;
    l_other_price_category ticket_groups.price_category%type;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'Another Roadside Attraction');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'New Years Mischief');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
--get a specific ticket
select et.serial_code, et.ticket_group_id, et.price_category
into l_serial_code, l_ticket_group_id, l_price_category
from customer_event_tickets_v et
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, et.ticket_id
fetch first 1 row only;

l_json_template := 
'
{
    "action" : "ticket-verify-restricted-access",
    "ticket_group_id" : $$GROUP$$,
    "price_category" : "$$CATEGORY$$",
    "serial_code" : "$$SERIAL$$"
}        
';

l_json_doc := replace(l_json_template, '$$GROUP$$', l_ticket_group_id);
l_json_doc := replace(l_json_doc, '$$CATEGORY$$', l_price_category);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code);

    dbms_output.put_line('force the ticket status to ISSUED to show ticket has not been used for event entry');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    events_json_api.ticket_verify_restricted_access(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

    dbms_output.put_line('force the ticket status to VALIDATED to show event entry');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_validated, p_use_commit => true);
    events_json_api.ticket_verify_restricted_access(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));


l_json_doc := replace(l_json_template, '$$GROUP$$', l_ticket_group_id);
l_json_doc := replace(l_json_doc, '$$CATEGORY$$', l_price_category);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code || 'xxxx');

    dbms_output.put_line('try to verify access for an invalid ticket serial code');
    events_json_api.ticket_verify_restricted_access(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));


    select tg.ticket_group_id, tg.price_category
    into l_other_ticket_group_id, l_other_price_category
    from ticket_groups tg where tg.event_id = l_event_id and tg.ticket_group_id <> l_ticket_group_id
    fetch first 1 row only;


l_json_doc := replace(l_json_template, '$$GROUP$$', l_other_ticket_group_id);
l_json_doc := replace(l_json_doc, '$$CATEGORY$$', l_other_price_category);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code);

    dbms_output.put_line('try to verify access for the wrong ticket group');
    events_json_api.ticket_verify_restricted_access(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));
    
    --reset the ticket status to ISSUED for other testing
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    
    
 end;


/*
force the ticket status to ISSUED to show ticket has not been used for event entry
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2442,
  "price_category" : "VIP",
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket has not been validated for event entry, cannot verify access for status ISSUED"
}
force the ticket status to VALIDATED to show event entry
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2442,
  "price_category" : "VIP",
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "SUCCESS",
  "status_message" : "ACCESS VERIFIED"
}
try to verify access for an invalid ticket serial code
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2442,
  "price_category" : "VIP",
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001xxxx",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket not found for serial code = G2442C529S80201D20220713120938Q0003I0001xxxx"
}
try to verify access for the wrong ticket group
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2441,
  "price_category" : "SPONSOR",
  "serial_code" : "G2442C529S80201D20220713120938Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket is for VIP, ticket not valid for SPONSOR"
}


PL/SQL procedure successfully completed.


*/
