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
    and t.issued_to_name is null
    order by t.ticket_sales_id, t.ticket_id
    fetch first 3 rows only;
    
    select t.ticket_id, t.serial_code, t.status
    bulk collect into l_tickets
    from tickets t join table(l_ticket_ids) ti on t.ticket_id = ti.column_value;
    
l_json_template := 
'
{
    "action" : "ticket_assign_holder_batch",
    "customer_id" : $$CUSTOMER$$,
    "tickets" : 
        [ 
            {
                "serial_code" : "$$SERIAL1$$", 
                "issued_to_name" : "Mary Shelley",
                "issued_to_id" : "UK2234567"
            },
            {
                "serial_code" : "$$SERIAL2$$", 
                "issued_to_name" : "Percy Byron",
                "issued_to_id" : "UK8765409"
            },
            {
                "serial_code" : "$$SERIAL3$$", 
                "issued_to_name" : "John Keats",
                "issued_to_id" : "UK3456001"
            }
        ]
}
';
    l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_id);
    for i in 1..l_tickets.count loop
        l_json_doc := replace(l_json_doc, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
    end loop;
    events_json_api.ticket_assign_holder_batch(p_json_doc => l_json_doc);   
    dbms_output.put_line(events_json_api.format_json(l_json_doc));

    dbms_output.put_line('view customer tickets with assigned names');

    l_json_doc := events_json_api.get_customer_event_tickets(p_customer_id => l_customer_id, p_event_id => l_event_id, p_formatted => true);
    dbms_output.put_line(l_json_doc);


end;

/*
{
  "action" : "ticket_assign_holder_batch",
  "customer_id" : 529,
  "tickets" :
  [
    {
      "serial_code" : "G2542C529S80389D20221002130825Q0003I0003R",
      "issued_to_name" : "Mary Shelley",
      "issued_to_id" : "UK2234567",
      "status_code" : "SUCCESS",
      "status_message" : "SERIAL CODE G2542C529S80389D20221002130825Q0003I0003R ASSIGNED TO Mary Shelley"
    },
    {
      "serial_code" : "G2543C529S80390D20221002130825Q0006I0001",
      "issued_to_name" : "Percy Byron",
      "issued_to_id" : "UK8765409",
      "status_code" : "SUCCESS",
      "status_message" : "SERIAL CODE G2543C529S80390D20221002130825Q0006I0001 ASSIGNED TO Percy Byron"
    },
    {
      "serial_code" : "G2543C529S80390D20221002130825Q0006I0002",
      "issued_to_name" : "John Keats",
      "issued_to_id" : "UK3456001",
      "status_code" : "SUCCESS",
      "status_message" : "SERIAL CODE G2543C529S80390D20221002130825Q0006I0002 ASSIGNED TO John Keats"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}


PL/SQL procedure successfully completed.



*/
