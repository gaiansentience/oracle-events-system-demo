--reissue lost ticket serial number using customer email
set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_id number;
    l_event_name events.event_name%type := 'New Years Mischief';

    l_customer_email varchar2(50) := 'John.Kirby@example.customer.com';
    l_other_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    
    l_customer_id number;    
    
    l_ticket_id number;
    l_new_serial_code tickets.serial_code%type;
    l_original_serial_code tickets.serial_code%type;
    l_status tickets.status%type;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    select t.ticket_id, t.serial_code, t.status 
    into l_ticket_id, l_original_serial_code, l_status
    from customer_purchases_mv p join tickets t on p.ticket_sales_id = t.ticket_sales_id
    where p.event_id = l_event_id and p.customer_id = l_customer_id
    order by p.ticket_sales_id, t.ticket_id
    fetch first 1 row only;
    
l_json_template := 
'
{
    "action" : "ticket_reissue",
    "customer_email" : "$$CUSTOMER$$",
    "ticket" : 
        {
            "serial_code" : "$$SERIAL$$"
        }
}
';
l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_original_serial_code);
    dbms_output.put_line('original serial code = ' || l_original_serial_code || ', status is ' || l_status);
    events_json_api.ticket_reissue(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json(l_json_doc));

    select t.serial_code, t.status into l_new_serial_code, l_status
    from tickets t where t.ticket_id = l_ticket_id;
    dbms_output.put_line('after reissuing ticket serial code = ' || l_new_serial_code || ', status is ' || l_status);

    dbms_output.put_line('try to reissue the ticket with the new serial code');
l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_new_serial_code);
    events_json_api.ticket_reissue(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json(l_json_doc));
    
    
    dbms_output.put_line('try to reissue the ticket with the original serial code');
l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_original_serial_code);
    events_json_api.ticket_reissue(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json(l_json_doc));
        
    dbms_output.put_line('reset ticket to ISSUED and original serial number and try to reissue for a different customer');
    update tickets t set t.status = 'ISSUED', t.serial_code = l_original_serial_code
    where t.ticket_id = l_ticket_id;
    commit;

l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_other_customer_email);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_original_serial_code);
    events_json_api.ticket_reissue(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json(l_json_doc));

    
end;

/*
original serial code = G2442C1910S80203D20220713121101Q0003I0001, status is ISSUED
{
  "action" : "ticket_reissue",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket" :
  {
    "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001",
    "status_code" : "SUCCESS",
    "status_message" : "REISSUED"
  }
}
after reissuing ticket serial code = G2442C1910S80203D20220713121101Q0003I0001R, status is REISSUED
try to reissue the ticket with the new serial code
{
  "action" : "ticket_reissue",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket" :
  {
    "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001R",
    "status_code" : "ERROR",
    "status_message" : "ORA-20100: Ticket has already been reissued, cannot reissue twice."
  }
}
try to reissue the ticket with the original serial code
{
  "action" : "ticket_reissue",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket" :
  {
    "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001",
    "status_code" : "ERROR",
    "status_message" : "ORA-20100: Ticket not found for serial code = G2442C1910S80203D20220713121101Q0003I0001"
  }
}
reset ticket to ISSUED and original serial number and try to reissue for a different customer
{
  "action" : "ticket_reissue",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "ticket" :
  {
    "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001",
    "status_code" : "ERROR",
    "status_message" : "ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue."
  }
}

*/
