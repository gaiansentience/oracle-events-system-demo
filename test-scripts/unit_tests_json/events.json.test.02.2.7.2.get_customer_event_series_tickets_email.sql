--get venue information as a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_customer_email varchar2(100) := 'Judy.Albright@example.customer.com';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

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
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "series_tickets" : 156,
  "events" :
  [
    {
      "event_id" : 623,
      "event_date" : "2023-06-07T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2444,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80218,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2457,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80205,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 624,
      "event_date" : "2023-06-14T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2445,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80219,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2458,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80206,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 625,
      "event_date" : "2023-06-21T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2446,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80220,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2459,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80207,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 626,
      "event_date" : "2023-06-28T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2447,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80221,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2460,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80208,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 627,
      "event_date" : "2023-07-05T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2448,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80222,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2461,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80209,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 628,
      "event_date" : "2023-07-12T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2449,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80223,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2462,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80210,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 629,
      "event_date" : "2023-07-19T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2450,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80224,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2463,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80211,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 630,
      "event_date" : "2023-07-26T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2451,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80225,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2464,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80212,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 631,
      "event_date" : "2023-08-02T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2452,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80226,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2465,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80213,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 632,
      "event_date" : "2023-08-09T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2453,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80227,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2466,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80214,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 633,
      "event_date" : "2023-08-16T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2454,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80228,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2467,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80215,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 634,
      "event_date" : "2023-08-23T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2455,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80229,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2468,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80216,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    },
    {
      "event_id" : 635,
      "event_date" : "2023-08-30T19:00:00",
      "event_tickets" : 12,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2456,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80230,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        },
        {
          "ticket_group_id" : 2469,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80217,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix"
        }
      ]
    }
  ]
}


*/