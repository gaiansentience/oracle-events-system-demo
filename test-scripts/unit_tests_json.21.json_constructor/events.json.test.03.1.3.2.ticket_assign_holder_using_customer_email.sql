--assign name and identification to tickets
set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc clob;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_name events.event_name%type := 'New Years Mischief';
    l_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    l_event_id number;
    l_venue_id number;
    l_customer_id number;
    l_serial_code tickets.serial_code%type;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    select t.serial_code 
    into l_serial_code
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    and t.issued_to_name is null
    order by t.ticket_sales_id, t.ticket_id
    fetch first 1 row only;
    
l_json_template := 
'
{
    "action" : "ticket_assign_holder",
    "customer_email" : "$$CUSTOMER$$",
    "ticket" : 
        {
            "serial_code" : "$$SERIAL$$",
            "issued_to_name" : "Judith Einstein",
            "issued_to_id" : "MA12300077880"
        }
}
';
l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
l_json_doc := replace(l_json_doc, '$$SERIAL$$', l_serial_code);

    events_json_api.ticket_assign_holder(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json(l_json_doc));
    
    
end;

/*
{
  "action" : "ticket_assign_holder",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "ticket" :
  {
    "serial_code" : "G2542C529S80389D20221002130825Q0003I0002R",
    "issued_to_name" : "Judith Einstein",
    "issued_to_id" : "MA12300077880",
    "status_code" : "SUCCESS",
    "status_message" : "SERIAL CODE G2542C529S80389D20221002130825Q0003I0002R ASSIGNED TO Judith Einstein"
  }
}


PL/SQL procedure successfully completed.


*/
