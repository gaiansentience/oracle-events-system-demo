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
select t.serial_code, et.ticket_group_id, et.price_category
into l_serial_code, l_ticket_group_id, l_price_category
from 
customer_event_tickets_v et
join tickets t on et.ticket_sales_id = t.ticket_sales_id
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, t.ticket_id
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
    update tickets t set t.status = 'ISSUED' where t.serial_code = upper(l_serial_code);
    commit;
    events_json_api.ticket_verify_restricted_access(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

    dbms_output.put_line('force the ticket status to VALIDATED to show event entry');
    update tickets t set t.status = 'VALIDATED' where t.serial_code = upper(l_serial_code);
    commit;
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
    
 end;


/*
force the ticket status to ISSUED to show ticket has not been used for event entry
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2322,
  "price_category" : "VIP",
  "serial_code" : "G2322C529S71141D20220706120837Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket has not been validated for event entry, cannot verify access for status ISSUED"
}
force the ticket status to VALIDATED to show event entry
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2322,
  "price_category" : "VIP",
  "serial_code" : "G2322C529S71141D20220706120837Q0003I0001",
  "status_code" : "SUCCESS",
  "status_message" : "ACCESS VERIFIED"
}
try to verify access for an invalid ticket serial code
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2322,
  "price_category" : "VIP",
  "serial_code" : "G2322C529S71141D20220706120837Q0003I0001xxxx",
  "status_code" : "ERROR",
  "status_message" : "ORA-01403: no data found"
}
try to verify access for the wrong ticket group
{
  "action" : "ticket-verify-restricted-access",
  "ticket_group_id" : 2321,
  "price_category" : "SPONSOR",
  "serial_code" : "G2322C529S71141D20220706120837Q0003I0001",
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Ticket is for VIP, ticket not valid for SPONSOR"
}
*/
