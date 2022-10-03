set serveroutput on;
declare
    l_json json;
    l_json_doc clob;
    l_customer_email varchar2(100) := 'Judy.Albright@example.customer.com';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_json := events_json_api.get_customer_event_series_tickets_by_email(p_customer_email => l_customer_email, p_event_series_id => l_event_series_id, p_formatted => true);

    l_json_doc := events_json_api.json_as_clob(l_json);
    
    if dbms_lob.getlength(l_json_doc) < 32000 then
        dbms_output.put_line(l_json_doc);
    else
        events_test_data_api.output_put_clob(p_doc => l_json_doc, p_chunksize => 16000);
    end if;
    
 end;

/*
Document is 38616 characters, outputting in 16000 character chunks
{
  "customer_id" : 513,
  "customer_name" : "Judy Albright",
  "customer_email" : "Judy.Albright@example.customer.com",
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 81,
  "event_series_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "series_events" : 13,
  "series_tickets" : 156,
  "events" :
  [
    {
      "event_id" : 623,
      "event_name" : "Monster Truck Smashup",
      "event_date" : "2023-06-07T19:00:00",
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2444,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80218,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640883,
              "serial_code" : "G2444C513S80218D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640884,
              "serial_code" : "G2444C513S80218D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640885,
              "serial_code" : "G2444C513S80218D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640886,
              "serial_code" : "G2444C513S80218D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2457,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80205,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640779,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640780,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640781,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640782,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640783,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640784,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640785,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640786,
              "serial_code" : "G2457C513S80205D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2445,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80219,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640887,
              "serial_code" : "G2445C513S80219D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640888,
              "serial_code" : "G2445C513S80219D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640889,
              "serial_code" : "G2445C513S80219D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640890,
              "serial_code" : "G2445C513S80219D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2458,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80206,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640787,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640788,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640789,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640790,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640791,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640792,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640793,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640794,
              "serial_code" : "G2458C513S80206D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2446,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80220,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640891,
              "serial_code" : "G2446C513S80220D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640892,
              "serial_code" : "G2446C513S80220D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640893,
              "serial_code" : "G2446C513S80220D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640894,
              "serial_code" : "G2446C513S80220D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2459,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80207,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640795,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640796,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640797,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640798,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640799,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640800,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640801,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640802,
              "serial_code" : "G2459C513S80207D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2447,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80221,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640895,
              "serial_code" : "G2447C513S80221D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640896,
              "serial_code" : "G2447C513S80221D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640897,
              "serial_code" : "G2447C513S80221D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640898,
              "serial_code" : "G2447C513S80221D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2460,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80208,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640803,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640804,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640805,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640806,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640807,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640808,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640809,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640810,
              "serial_code" : "G2460C513S80208D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2448,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80222,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640899,
              "serial_code" : "G2448C513S80222D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640900,
              "serial_code" : "G2448C513S80222D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640901,
              "serial_code" : "G2448C513S80222D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640902,
              "serial_code" : "G2448C513S80222D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2461,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80209,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640811,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640812,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640813,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640814,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640815,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640816,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640817,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640818,
              "serial_code" : "G2461C513S80209D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2449,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80223,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640903,
              "serial_code" : "G2449C513S80223D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640904,
              "serial_code" : "G2449C513S80223D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640905,
              
"serial_code" : "G2449C513S80223D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640906,
              "serial_code" : "G2449C513S80223D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2462,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80210,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640819,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640820,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640821,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640822,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640823,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640824,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640825,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640826,
              "serial_code" : "G2462C513S80210D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2450,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80224,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640907,
              "serial_code" : "G2450C513S80224D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640908,
              "serial_code" : "G2450C513S80224D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640909,
              "serial_code" : "G2450C513S80224D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640910,
              "serial_code" : "G2450C513S80224D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2463,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80211,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640827,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640828,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640829,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640830,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640831,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640832,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640833,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640834,
              "serial_code" : "G2463C513S80211D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2451,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80225,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640911,
              "serial_code" : "G2451C513S80225D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640912,
              "serial_code" : "G2451C513S80225D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640913,
              "serial_code" : "G2451C513S80225D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640914,
              "serial_code" : "G2451C513S80225D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2464,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80212,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640839,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640840,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640841,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640842,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0008",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640835,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640836,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640837,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640838,
              "serial_code" : "G2464C513S80212D20220713125927Q0008I0004",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2452,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80226,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640915,
              "serial_code" : "G2452C513S80226D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640916,
              "serial_code" : "G2452C513S80226D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640917,
              "serial_code" : "G2452C513S80226D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640918,
              "serial_code" : "G2452C513S80226D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2465,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80213,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640843,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640844,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640845,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640846,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640847,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640848,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640849,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640850,
              "serial_code" : "G2465C513S80213D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2453,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80227,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640919,
              "serial_code" : "G2453C513S80227D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640920,
              "serial_code" : "G2453C513S80227D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640921,
              "serial_code" : "G2453C513S80227D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640922,
              "serial_code" : "G2453C513S80227D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2466,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80214,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640851,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640852,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640853,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640854,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640855,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640856,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640857,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640858,
              "serial_code" : "G2466C513S80214D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2454,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80228,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640923,
              "serial_code" : "G2454C513S80228D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640924,
              "serial_code" : "G2454C513S80228D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640925,
              "serial_code" : "G2454C513S80228D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640926,
              "serial_code" : "G2454C513S80228D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2467,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80215,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640859,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640860,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640861,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640862,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0004",
              "status" : "ISSUED"
         
   },
            {
              "ticket_id" : 640863,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640864,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640865,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640866,
              "serial_code" : "G2467C513S80215D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2455,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80229,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640927,
              "serial_code" : "G2455C513S80229D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640928,
              "serial_code" : "G2455C513S80229D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640929,
              "serial_code" : "G2455C513S80229D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640930,
              "serial_code" : "G2455C513S80229D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2468,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80216,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640867,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640868,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640869,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640870,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640871,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640872,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640873,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640874,
              "serial_code" : "G2468C513S80216D20220713125927Q0008I0008",
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
      "event_tickets" : 12,
      "purchases" :
      [
        {
          "ticket_group_id" : 2456,
          "price_category" : "RESERVED SEATING",
          "ticket_sales_id" : 80230,
          "ticket_quantity" : 4,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640931,
              "serial_code" : "G2456C513S80230D20220713125927Q0004I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640932,
              "serial_code" : "G2456C513S80230D20220713125927Q0004I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640933,
              "serial_code" : "G2456C513S80230D20220713125927Q0004I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640934,
              "serial_code" : "G2456C513S80230D20220713125927Q0004I0004",
              "status" : "ISSUED"
            }
          ]
        },
        {
          "ticket_group_id" : 2469,
          "price_category" : "GENERAL ADMISSION",
          "ticket_sales_id" : 80217,
          "ticket_quantity" : 8,
          "sales_date" : "2022-07-13T12:59:27",
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets" :
          [
            {
              "ticket_id" : 640875,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0001",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640876,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0002",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640877,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0003",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640878,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0004",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640879,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0005",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640880,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0006",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640881,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0007",
              "status" : "ISSUED"
            },
            {
              "ticket_id" : 640882,
              "serial_code" : "G2469C513S80217D20220713125927Q0008I0008",
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