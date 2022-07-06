--get venue information as a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_event_series_id number;
    l_customer_id number;
    l_customer_email varchar2(100) := 'Judy.Albright@example.customer.com';
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Monster Truck Smashup');

    l_json_doc := events_json_api.get_customer_event_series_tickets_by_email(p_customer_email => l_customer_email, p_event_series_id => l_event_series_id, p_formatted => true);
   
    dbms_output.put_line(l_json_doc);

 end;

/*

{
  "customer_id" : 513,
  "customer_name" : "Judy Albright",
  "customer_email" : "Judy.Albright@example.customer.com",
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "series_tickets" : 156,
  "events" :
  [
    {
      "event_id" : 582,
      "event_date" : "2023-06-07T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2324,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71252,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2337,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71239,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 583,
      "event_date" : "2023-06-14T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2325,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71253,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2338,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71240,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 584,
      "event_date" : "2023-06-21T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2326,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71254,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2339,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71241,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 585,
      "event_date" : "2023-06-28T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2327,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71255,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2340,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71242,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 586,
      "event_date" : "2023-07-05T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2328,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71256,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2341,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71243,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 587,
      "event_date" : "2023-07-12T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2329,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71257,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2342,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71244,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 588,
      "event_date" : "2023-07-19T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2330,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71258,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2343,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71245,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 589,
      "event_date" : "2023-07-26T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2331,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71259,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2344,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71246,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 590,
      "event_date" : "2023-08-02T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2332,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71260,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2345,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71247,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 591,
      "event_date" : "2023-08-09T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2333,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71261,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2346,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71248,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 592,
      "event_date" : "2023-08-16T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2334,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71262,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2347,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71249,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 593,
      "event_date" : "2023-08-23T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2335,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71263,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2348,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71250,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 594,
      "event_date" : "2023-08-30T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2336,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 71264,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2349,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71251,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-06T13:53:48",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.



*/