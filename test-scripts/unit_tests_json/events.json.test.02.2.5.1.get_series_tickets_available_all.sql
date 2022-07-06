set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_event_series_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Monster Truck Smashup');

    l_json_doc := events_json_api.get_event_series_tickets_available_all(p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_json_doc);

end;
--reply format example
/*

{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "events_in_series" : 13,
  "ticket_groups" :
  [
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : 4,
          "reseller_name" : "Source Tix",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : 8,
          "reseller_name" : "Ticketron",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 26000,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 1300,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : 4,
          "reseller_name" : "Source Tix",
          "tickets_available" : 1300,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : 8,
          "reseller_name" : "Ticketron",
          "tickets_available" : 1300,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 2600,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets_available" : 31200,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : 4,
          "reseller_name" : "Source Tix",
          "tickets_available" : 1300,
          "events_available" : 13,
          "events_sold_out" : 0
        },
        {
          "reseller_id" : 8,
          "reseller_name" : "Ticketron",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.


*/