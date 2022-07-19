--reissue lost ticket serial number using customer email
set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc varchar2(4000);
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_id number;
    l_event_name events.event_name%type := 'New Years Mischief';
    l_customer_id number;    
    l_customer_email varchar2(50) := 'John.Kirby@example.customer.com';
    l_other_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    
    
    
--    l_ticket_id number;
--    l_new_serial_code tickets.serial_code%type;
--    l_original_serial_code tickets.serial_code%type;
--    l_status tickets.status%type;
    type r_ticket is record(ticket_id number, serial_code tickets.serial_code%type, status tickets.status%type);
    type t_tickets is table of r_ticket;
    l_tickets t_tickets;
    l_updated_tickets t_tickets;
    l_ticket_ids util_types.t_ids;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    select t.ticket_id
    bulk collect into l_ticket_ids
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    order by t.ticket_sales_id, t.ticket_id
    fetch first 3 rows only;
    
    select t.ticket_id, t.serial_code, t.status
    bulk collect into l_tickets
    from tickets t join table(l_ticket_ids) ti on t.ticket_id = ti.column_value;
    
l_json_template := 
'
{
    "action" : "ticket_reissue_batch",
    "customer_email" : "$$CUSTOMER$$",
    "tickets" : 
        [ 
            {
                "serial_code" : "$$SERIAL1$$" 
            },
            {
                "serial_code" : "$$SERIAL2$$" 
            },
            {
                "serial_code" : "$$SERIAL3$$" 
            }
        ]
}
';
    l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
    for i in 1..3 loop
        l_json_doc := replace(l_json_doc, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
        dbms_output.put_line('original serial code = ' || l_tickets(i).serial_code || ', status is ' || l_tickets(i).status);
    end loop;
    events_json_api.ticket_reissue_batch(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));
    
    --get the updated serial codes and statuses
    select t.ticket_id, t.serial_code, t.status
    bulk collect into l_updated_tickets
    from tickets t join table(l_ticket_ids) ti on t.ticket_id = ti.column_value;
    for i in 1..l_updated_tickets.count loop    
        dbms_output.put_line('after reissuing ticket serial code = ' || l_updated_tickets(i).serial_code || ', status is ' || l_updated_tickets(i).status);
    end loop;

    dbms_output.put_line('try to reissue tickets using new serial code');
    l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
    for i in 1..l_tickets.count loop
        l_json_doc := replace(l_json_doc, '$$SERIAL' || i || '$$', l_updated_tickets(i).serial_code);
    end loop;
    events_json_api.ticket_reissue_batch(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));
    
    dbms_output.put_line('try to reissue tickets using original serial code');
    l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
    for i in 1..l_tickets.count loop
        l_json_doc := replace(l_json_doc, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
    end loop;
    events_json_api.ticket_reissue_batch(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

    dbms_output.put_line('update tickets to ISSUED with original serial codes and try to update with a different customer');
    forall i in 1..l_tickets.count 
    update tickets t set t.status = 'ISSUED', t.serial_code = l_tickets(i).serial_code
    where t.ticket_id = l_tickets(i).ticket_id;
    commit;

    l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_other_customer_email);
    for i in 1..3 loop
        l_json_doc := replace(l_json_doc, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
    end loop;
    events_json_api.ticket_reissue_batch(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));
    
end;

/*
original serial code = G2442C1910S80203D20220713121101Q0003I0001, status is ISSUED
original serial code = G2442C1910S80203D20220713121101Q0003I0002, status is ISSUED
original serial code = G2442C1910S80203D20220713121101Q0003I0003, status is ISSUED
{
  "action" : "ticket_reissue_batch",
  "customer_email" : "John.Kirby@example.customer.com",
  "tickets" :
  [
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001",
      "status_code" : "SUCCESS",
      "status_message" : "REISSUED"
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0002",
      "status_code" : "SUCCESS",
      "status_message" : "REISSUED"
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0003",
      "status_code" : "SUCCESS",
      "status_message" : "REISSUED"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}
after reissuing ticket serial code = G2442C1910S80203D20220713121101Q0003I0001R, status is REISSUED
after reissuing ticket serial code = G2442C1910S80203D20220713121101Q0003I0002R, status is REISSUED
after reissuing ticket serial code = G2442C1910S80203D20220713121101Q0003I0003R, status is REISSUED
try to reissue tickets using new serial code
{
  "action" : "ticket_reissue_batch",
  "customer_email" : "John.Kirby@example.customer.com",
  "tickets" :
  [
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001R",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Ticket has already been reissued, cannot reissue twice."
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0002R",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Ticket has already been reissued, cannot reissue twice."
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0003R",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Ticket has already been reissued, cannot reissue twice."
    }
  ],
  "request_status" : "ERRORS",
  "request_errors" : 3
}
try to reissue tickets using original serial code
{
  "action" : "ticket_reissue_batch",
  "customer_email" : "John.Kirby@example.customer.com",
  "tickets" :
  [
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Ticket not found for serial code = G2442C1910S80203D20220713121101Q0003I0001"
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0002",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Ticket not found for serial code = G2442C1910S80203D20220713121101Q0003I0002"
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0003",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Ticket not found for serial code = G2442C1910S80203D20220713121101Q0003I0003"
    }
  ],
  "request_status" : "ERRORS",
  "request_errors" : 3
}
update tickets to ISSUED with original serial codes and try to update with a different customer
{
  "action" : "ticket_reissue_batch",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "tickets" :
  [
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue."
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0002",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue."
    },
    {
      "serial_code" : "G2442C1910S80203D20220713121101Q0003I0003",
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue."
    }
  ],
  "request_status" : "ERRORS",
  "request_errors" : 3
}


PL/SQL procedure successfully completed.


*/
