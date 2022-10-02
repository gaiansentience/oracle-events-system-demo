--reissue lost ticket serial number using customer id
set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_id number;
    l_event_name events.event_name%type := 'New Years Mischief';

    l_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
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
    and t.issued_to_name is null
    order by p.ticket_sales_id, t.ticket_id
    fetch first 1 row only;

    
l_json_template := 
'
{
    "action" : "ticket_assign_holder",
    "customer_id" : $$CUSTOMER$$,
    "ticket" : 
        {
            "serial_code" : "$$SERIAL$$",
            "issued_to_name" : "Albert Einstein",
            "issued_to_id" : "MA123456789"
        }
}
';
l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_id);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_original_serial_code);

    events_json_api.ticket_assign_holder(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json(l_json_doc));
    
    
    
end;

/*
{
  "action" : "ticket_assign_holder",
  "customer_id" : 529,
  "ticket" :
  {
    "serial_code" : "G2542C529S80389D20221002130825Q0003I0001R",
    "issued_to_name" : "Albert Einstein",
    "issued_to_id" : "MA123456789",
    "status_code" : "SUCCESS",
    "status_message" : "SERIAL CODE G2542C529S80389D20221002130825Q0003I0001R ASSIGNED TO Albert Einstein"
  }
}
*/
