--get venue information as a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_event_series_id number;
    l_customer_id number;
    l_customer_email varchar2(100) := 'Albert.Einstein@example.customer.com';
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Monster Truck Smashup');
    l_customer_id := events_api.get_customer_id(p_customer_email => l_customer_email);


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
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "series_tickets" : 91,
  "events" :
  [
    {
      "event_id" : 582,
      "event_date" : "2023-06-07T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2337,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71213,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2350,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71226,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 583,
      "event_date" : "2023-06-14T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2338,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71214,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2351,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71227,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 584,
      "event_date" : "2023-06-21T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2339,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71215,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2352,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71228,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 585,
      "event_date" : "2023-06-28T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2340,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71216,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2353,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71229,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 586,
      "event_date" : "2023-07-05T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2341,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71217,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2354,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71230,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 587,
      "event_date" : "2023-07-12T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2342,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71218,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2355,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71231,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 588,
      "event_date" : "2023-07-19T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2343,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71219,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2356,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71232,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 589,
      "event_date" : "2023-07-26T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2344,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71220,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2357,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71233,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 590,
      "event_date" : "2023-08-02T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2345,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71221,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2358,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71234,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 591,
      "event_date" : "2023-08-09T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2346,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71222,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2359,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71235,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 592,
      "event_date" : "2023-08-16T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2347,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71223,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2360,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71236,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 593,
      "event_date" : "2023-08-23T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2348,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71224,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2361,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71237,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    },
    {
      "event_id" : 594,
      "event_date" : "2023-08-30T19:00:00",
      "event_tickets" : 7,
      "event_ticket_purchases" :
      [
        {
          "ticket_group_id" : 2349,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 71225,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        },
        {
          "ticket_group_id" : 2362,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 71238,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-06T13:53:26",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES"
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.


*/