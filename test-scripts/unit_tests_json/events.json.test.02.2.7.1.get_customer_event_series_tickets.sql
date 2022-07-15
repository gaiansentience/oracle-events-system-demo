--get venue information as a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_customer_id number;
    l_customer_email varchar2(100) := 'Albert.Einstein@example.customer.com';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    l_json_doc := events_json_api.get_customer_event_series_tickets(p_customer_id => l_customer_id, p_event_series_id => l_event_series_id, p_formatted => true);   
    dbms_output.put_line(l_json_doc);

 end;

/* 
{
  "customer_id" : 4734,
  "customer_name" : "Albert Einstein",
  "customer_email" : "Albert.Einstein@example.customer.com",
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "series_tickets" : 91,
  "events" :
  [
    {
      "event_id" : 623,
      "event_date" : "2023-06-07T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2457,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80231,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2470,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80244,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 624,
      "event_date" : "2023-06-14T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2458,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80232,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2471,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80245,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 625,
      "event_date" : "2023-06-21T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2459,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80233,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2472,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80246,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 626,
      "event_date" : "2023-06-28T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2460,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80234,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2473,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80247,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 627,
      "event_date" : "2023-07-05T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2461,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80235,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2474,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80248,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 628,
      "event_date" : "2023-07-12T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2462,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80236,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2475,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80249,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 629,
      "event_date" : "2023-07-19T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2463,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80237,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2476,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80250,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 630,
      "event_date" : "2023-07-26T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2464,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80238,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2477,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80251,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 631,
      "event_date" : "2023-08-02T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2465,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80239,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2478,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80252,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 632,
      "event_date" : "2023-08-09T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2466,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80240,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2479,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80253,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 633,
      "event_date" : "2023-08-16T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2467,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80241,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2480,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80254,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 634,
      "event_date" : "2023-08-23T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2468,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80242,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2481,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80255,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 635,
      "event_date" : "2023-08-30T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2469,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80243,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2482,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80256,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.



*/