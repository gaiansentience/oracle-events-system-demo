--get venue information as a json document
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_id number;
    l_event_name events.event_name%type := 'New Years Mischief';
    l_customer_email varchar2(50) := 'John.Kirby@example.customer.com';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_json_doc := events_json_api.get_customer_event_tickets_by_email(p_customer_email => l_customer_email, p_event_id => l_event_id, p_formatted => true);   
    dbms_output.put_line(l_json_doc);

 end;

/*  

{
  "customer_id" : 1910,
  "customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 621,
  "event_series_id" : null,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets" : 9,
  "purchases" :
  [
    {
      "ticket_group_id" : 2442,
      "price_category" : "VIP",
      "ticket_sales_id" : 80203,
      "ticket_quantity" : 3,
      "sales_date" : "2022-07-13T12:11:01",
      "reseller_id" : null,
      "reseller_name" : "VENUE DIRECT SALES",
      "tickets" :
      [
        {
          "ticket_id" : 640770,
          "serial_code" : "G2442C1910S80203D20220713121101Q0003I0001",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        },
        {
          "ticket_id" : 640771,
          "serial_code" : "G2442C1910S80203D20220713121101Q0003I0002",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        },
        {
          "ticket_id" : 640772,
          "serial_code" : "G2442C1910S80203D20220713121101Q0003I0003",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        }
      ]
    },
    {
      "ticket_group_id" : 2443,
      "price_category" : "GENERAL ADMISSION",
      "ticket_sales_id" : 80204,
      "ticket_quantity" : 6,
      "sales_date" : "2022-07-13T12:11:01",
      "reseller_id" : null,
      "reseller_name" : "VENUE DIRECT SALES",
      "tickets" :
      [
        {
          "ticket_id" : 640773,
          "serial_code" : "G2443C1910S80204D20220713121101Q0006I0001",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        },
        {
          "ticket_id" : 640774,
          "serial_code" : "G2443C1910S80204D20220713121101Q0006I0002",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        },
        {
          "ticket_id" : 640775,
          "serial_code" : "G2443C1910S80204D20220713121101Q0006I0003",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        },
        {
          "ticket_id" : 640776,
          "serial_code" : "G2443C1910S80204D20220713121101Q0006I0004",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        },
        {
          "ticket_id" : 640777,
          "serial_code" : "G2443C1910S80204D20220713121101Q0006I0005",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        },
        {
          "ticket_id" : 640778,
          "serial_code" : "G2443C1910S80204D20220713121101Q0006I0006",
          "status" : "ISSUED",
          "issued_to_name" : null,
          "issued_to_id" : null,
          "assigned_section" : null,
          "assigned_row" : null,
          "assigned_seat" : null
        }
      ]
    }
  ]
}


*/