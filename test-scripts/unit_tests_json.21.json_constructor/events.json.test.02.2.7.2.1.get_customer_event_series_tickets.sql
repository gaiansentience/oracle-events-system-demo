set serveroutput on;
declare
    l_json json;
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

    l_json := events_json_api.get_customer_event_series_tickets(p_customer_id => l_customer_id, p_event_series_id => l_event_series_id, p_formatted => true);  
    
    l_json_doc := events_json_api.json_as_clob(l_json);
    
    if dbms_lob.getlength(l_json_doc) < 32000 then
        dbms_output.put_line(l_json_doc);
    else
        events_test_data_api.output_put_clob(p_doc => l_json_doc, p_chunksize => 16000);
    end if;
    

 end;

/* 
{
  "customer_id" : 4734,
  "customer_name" : "Albert Einstein",
  "customer_email" : "Albert.Einstein@example.customer.com",
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 81,
  "event_series_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "series_events" : 13,
  "series_tickets" : 91,
  "events" :
  [
    {
      "event_id" : 623,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-07T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2457,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80231,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640935,
              "serial_code" : "G2457C4734S80231D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640936,
              "serial_code" : "G2457C4734S80231D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640937,
              "serial_code" : "G2457C4734S80231D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640938,
              "serial_code" : "G2457C4734S80231D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640939,
              "serial_code" : "G2457C4734S80231D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2470,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80244,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641000,
              "serial_code" : "G2470C4734S80244D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641001,
              "serial_code" : "G2470C4734S80244D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 624,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-14T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2458,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80232,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640940,
              "serial_code" : "G2458C4734S80232D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640941,
              "serial_code" : "G2458C4734S80232D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640942,
              "serial_code" : "G2458C4734S80232D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640943,
              "serial_code" : "G2458C4734S80232D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640944,
              "serial_code" : "G2458C4734S80232D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2471,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80245,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641002,
              "serial_code" : "G2471C4734S80245D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641003,
              "serial_code" : "G2471C4734S80245D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 625,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-21T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2459,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80233,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640945,
              "serial_code" : "G2459C4734S80233D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640946,
              "serial_code" : "G2459C4734S80233D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640947,
              "serial_code" : "G2459C4734S80233D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640948,
              "serial_code" : "G2459C4734S80233D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640949,
              "serial_code" : "G2459C4734S80233D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2472,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80246,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641004,
              "serial_code" : "G2472C4734S80246D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641005,
              "serial_code" : "G2472C4734S80246D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 626,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-28T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2460,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80234,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640950,
              "serial_code" : "G2460C4734S80234D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640951,
              "serial_code" : "G2460C4734S80234D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640952,
              "serial_code" : "G2460C4734S80234D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640953,
              "serial_code" : "G2460C4734S80234D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640954,
              "serial_code" : "G2460C4734S80234D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2473,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80247,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641006,
              "serial_code" : "G2473C4734S80247D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641007,
              "serial_code" : "G2473C4734S80247D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 627,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-05T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2461,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80235,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640955,
              "serial_code" : "G2461C4734S80235D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640956,
              "serial_code" : "G2461C4734S80235D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640957,
              "serial_code" : "G2461C4734S80235D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640958,
              "serial_code" : "G2461C4734S80235D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640959,
              "serial_code" : "G2461C4734S80235D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2474,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80248,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641008,
              "serial_code" : "G2474C4734S80248D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641009,
              "serial_code" : "G2474C4734S80248D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 628,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-12T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2462,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80236,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640960,
              "serial_code" : "G2462C4734S80236D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640961,
              "serial_code" : "G2462C4734S80236D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640962,
              "serial_code" : "G2462C4734S80236D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640963,
              "serial_code" : "G2462C4734S80236D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640964,
              "serial_code" : "G2462C4734S80236D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2475,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80249,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641010,
              "serial_code" : "G2475C4734S80249D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641011,
              "serial_code" : "G2475C4734S80249D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 629,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-19T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2463,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80237,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640965,
              "serial_code" : "G2463C4734S80237D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640966,
              "serial_code" : "G2463C4734S80237D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640967,
              "serial_code" : "G2463C4734S80237D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640968,
              "serial_code" : "G2463C4734S80237D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640969,
              "serial_code" : "G2463C4734S80237D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2476,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80250,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641012,
              "serial_code" : "G2476C4734S80250D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641013,
              "serial_code" : "G2476C4734S80250D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 630,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-07-26T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2464,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80238,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640970,
              "serial_code" : "G2464C4734S80238D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640971,
              "serial_code" : "G2464C4734S80238D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640972,
              "serial_code" : "G2464C4734S80238D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640973,
              "serial_code" : "G2464C4734S80238D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640974,
              "serial_code" : "G2464C4734S80238D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2477,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80251,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641014,
              "serial_code" : "G2477C4734S80251D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641015,
              "serial_code" : "G2477C4734S80251D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 631,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-02T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2465,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80239,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640975,
              "serial_code" : "G2465C4734S80239D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640976,
              "serial_code" : "G2465C4734S80239D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640977,
              "serial_code" : "G2465C4734S80239D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640978,
              "serial_code" : "G2465C4734S80239D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640979,
              "serial_code" : "G2465C4734S80239D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2478,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80252,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641016,
              "serial_code" : "G2478C4734S80252D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641017,
              "serial_code" : "G2478C4734S80252D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 632,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-09T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2466,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80240,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640980,
              "serial_code" : "G2466C4734S80240D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640981,
              "serial_code" : "G2466C4734S80240D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640982,
              "serial_code" : "G2466C4734S80240D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640983,
              "serial_code" : "G2466C4734S80240D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640984,
              "serial_code" : "G2466C4734S80240D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2479,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80253,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641018,
              "serial_code" : "G2479C4734S80253D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641019,
              "serial_code" : "G2479C4734S80253D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 633,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-16T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2467,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80241,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640985,
              "serial_code" : "G2467C4734S80241D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640986,
              "serial_code" : "G2467C4734S80241D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640987,
              "serial_code" : "G2467C4734S80241D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640988,
              "serial_code" : "G2467C4734S80241D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640989,
              "serial_code" : "G2467C4734S80241D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2480,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80254,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641020,
              "serial_code" : "G2480C4734S80254D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641021,
              "serial_code" : "G2480C4734S80254D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 634,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-23T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2468,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80242,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640990,
              "serial_code" : "G2468C4734S80242D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640991,
              "serial_code" : "G2468C4734S80242D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640992,
              "serial_code" : "G2468C4734S80242D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640993,
              "serial_code" : "G2468C4734S80242D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640994,
              "serial_code" : "G2468C4734S80242D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2481,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80255,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641022,
              "serial_code" : "G2481C4734S80255D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641023,
              "serial_code" : "G2481C4734S80255D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    },
    {
      "event_id" : 635,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-08-30T19:00:00",
      "event_tickets" : 7,
      "purchases" :
      [
        {
          "ticket_group_id" : 2469,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80243,
          "ticket_quantity" : 5,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 640995,
              "serial_code" : "G2469C4734S80243D20220713130427Q0005I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640996,
              "serial_code" : "G2469C4734S80243D20220713130427Q0005I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640997,
              "serial_code" : "G2469C4734S80243D20220713130427Q0005I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640998,
              "serial_code" : "G2469C4734S80243D20220713130427Q0005I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640999,
              "serial_code" : "G2469C4734S80243D20220713130427Q0005I0005",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2482,
          "price_category" : "VIP PIT ACCESS",
          "ticket_sales_id" : 80256,
          "ticket_quantity" : 2,
          "sales_date" : "2022-07-13T13:04:27",
          "reseller_id" : null,
          "reseller_name" : "VENUE DIRECT SALES",
          "tickets" :
          [
            {
              "ticket_id" : 641024,
              "serial_code" : "G2482C4734S80256D20220713130427Q0002I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 641025,
              "serial_code" : "G2482C4734S80256D20220713130427Q0002I0002",
              "status" : "ISSUED"
            }
          ]
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.



*/