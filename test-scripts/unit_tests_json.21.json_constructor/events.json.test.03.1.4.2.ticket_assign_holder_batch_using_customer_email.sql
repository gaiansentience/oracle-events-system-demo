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
    
    type r_ticket is record(serial_code tickets.serial_code%type);
    type t_tickets is table of r_ticket;
    l_tickets t_tickets;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    select t.serial_code
    bulk collect into l_tickets
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    and t.issued_to_name is null
    order by t.ticket_sales_id, t.ticket_id
    fetch first 4 rows only;
        
l_json_template := 
'
{
    "action" : "ticket_assign_holder_batch",
    "customer_email" : "$$CUSTOMER$$",
    "tickets" : 
        [ 
            {
                "serial_code" : "$$SERIAL1$$", 
                "issued_to_name" : "Louis Armstrong",
                "issued_to_id" : "USA0000101"
            },
            {
                "serial_code" : "$$SERIAL2$$", 
                "issued_to_name" : "Billie Holiday",
                "issued_to_id" : "USA0000102"
            },
            {
                "serial_code" : "$$SERIAL3$$", 
                "issued_to_name" : "Ella Fitzgerald",
                "issued_to_id" : "USA0000100"
            },
            {
                "serial_code" : "$$SERIAL4$$", 
                "issued_to_name" : "Margaret Wayland",
                "issued_to_id" : "CA78462365"
            }
        ]
}
';
    l_json_doc := replace(l_json_template, '$$CUSTOMER$$', l_customer_email);
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
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "tickets" :
  [
    {
      "serial_code" : "G2543C529S80390D20221002130825Q0006I0003",
      "issued_to_name" : "Louis Armstrong",
      "issued_to_id" : "USA0000101",
      "status_code" : "SUCCESS",
      "status_message" : "SERIAL CODE G2543C529S80390D20221002130825Q0006I0003 ASSIGNED TO Louis Armstrong"
    },
    {
      "serial_code" : "G2543C529S80390D20221002130825Q0006I0004",
      "issued_to_name" : "Billie Holiday",
      "issued_to_id" : "USA0000102",
      "status_code" : "SUCCESS",
      "status_message" : "SERIAL CODE G2543C529S80390D20221002130825Q0006I0004 ASSIGNED TO Billie Holiday"
    },
    {
      "serial_code" : "G2543C529S80390D20221002130825Q0006I0005",
      "issued_to_name" : "Ella Fitzgerald",
      "issued_to_id" : "USA0000100",
      "status_code" : "SUCCESS",
      "status_message" : "SERIAL CODE G2543C529S80390D20221002130825Q0006I0005 ASSIGNED TO Ella Fitzgerald"
    },
    {
      "serial_code" : "G2543C529S80390D20221002130825Q0006I0006",
      "issued_to_name" : "Margaret Wayland",
      "issued_to_id" : "CA78462365",
      "status_code" : "SUCCESS",
      "status_message" : "SERIAL CODE G2543C529S80390D20221002130825Q0006I0006 ASSIGNED TO Margaret Wayland"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}
view customer tickets with assigned names
{
  "customer_id" : 529,
  "customer_name" : "Maggie Wayland",
  "customer_email" : "Maggie.Wayland@example.customer.com",
  "venue_id" : 101,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 662,
  "event_series_id" : null,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets" : 9,
  "purchases" :
  [
    {
      "ticket_group_id" : 2542,
      "price_category" : "VIP",
      "ticket_sales_id" : 80389,
      "ticket_quantity" : 3,
      "sales_date" : "2022-10-02T13:08:25",
      "reseller_id" : 3,
      "reseller_name" : "Old School",
      "tickets" :
      [
        {
          "ticket_id" : 641397,
          "serial_code" : "G2542C529S80389D20221002130825Q0003I0001R",
          "status" : "ISSUED",
          "issued_to_name" : "Albert Einstein",
          "issued_to_id" : "MA123456789"
        },
        {
          "ticket_id" : 641398,
          "serial_code" : "G2542C529S80389D20221002130825Q0003I0002R",
          "status" : "REISSUED",
          "issued_to_name" : "Judith Einstein",
          "issued_to_id" : "MA12300077880"
        },
        {
          "ticket_id" : 641399,
          "serial_code" : "G2542C529S80389D20221002130825Q0003I0003R",
          "status" : "REISSUED",
          "issued_to_name" : "Mary Shelley",
          "issued_to_id" : "UK2234567"
        }
      ]
    },
    {
      "ticket_group_id" : 2543,
      "price_category" : "GENERAL ADMISSION",
      "ticket_sales_id" : 80390,
      "ticket_quantity" : 6,
      "sales_date" : "2022-10-02T13:08:25",
      "reseller_id" : 3,
      "reseller_name" : "Old School",
      "tickets" :
      [
        {
          "ticket_id" : 641400,
          "serial_code" : "G2543C529S80390D20221002130825Q0006I0001",
          "status" : "ISSUED",
          "issued_to_name" : "Percy Byron",
          "issued_to_id" : "UK8765409"
        },
        {
          "ticket_id" : 641401,
          "serial_code" : "G2543C529S80390D20221002130825Q0006I0002",
          "status" : "ISSUED",
          "issued_to_name" : "John Keats",
          "issued_to_id" : "UK3456001"
        },
        {
          "ticket_id" : 641402,
          "serial_code" : "G2543C529S80390D20221002130825Q0006I0003",
          "status" : "ISSUED",
          "issued_to_name" : "Louis Armstrong",
          "issued_to_id" : "USA0000101"
        },
        {
          "ticket_id" : 641403,
          "serial_code" : "G2543C529S80390D20221002130825Q0006I0004",
          "status" : "ISSUED",
          "issued_to_name" : "Billie Holiday",
          "issued_to_id" : "USA0000102"
        },
        {
          "ticket_id" : 641404,
          "serial_code" : "G2543C529S80390D20221002130825Q0006I0005",
          "status" : "ISSUED",
          "issued_to_name" : "Ella Fitzgerald",
          "issued_to_id" : "USA0000100"
        },
        {
          "ticket_id" : 641405,
          "serial_code" : "G2543C529S80390D20221002130825Q0006I0006",
          "status" : "ISSUED",
          "issued_to_name" : "Margaret Wayland",
          "issued_to_id" : "CA78462365"
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.


*/
