set serveroutput on;
declare
  v_event_id number := 10;
  v_json_doc CLOB;
begin

  v_json_doc := events_json_api.get_event_reseller_ticket_assignments(
                                          p_event_id => v_event_id,
                                          p_formatted => true);

  dbms_output.put_line(v_json_doc);

end;
--reply format example
/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "event_id" : 10,
  "event_name" : "The Specials",
  "event_date" : "2022-06-10T16:01:51",
  "event_tickets_available" : 20000,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 1,
      "reseller_name" : "Events For You",
      "reseller_email" : "ticket.sales@EventsForYou.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 221,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 243,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 265,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 254,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 232,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 2,
      "reseller_name" : "MaxTix",
      "reseller_email" : "ticket.sales@MaxTix.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 222,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 244,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 266,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 255,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 233,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 3,
      "reseller_name" : "Old School",
      "reseller_email" : "ticket.sales@OldSchool.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 223,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 245,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 267,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 256,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 234,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 4,
      "reseller_name" : "Source Tix",
      "reseller_email" : "ticket.sales@SourceTix.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 224,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 246,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 268,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 257,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 235,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 5,
      "reseller_name" : "The Source",
      "reseller_email" : "ticket.sales@TheSource.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 225,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 247,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 269,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 258,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 236,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 6,
      "reseller_name" : "Ticket Supply",
      "reseller_email" : "ticket.sales@TicketSupply.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 226,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 248,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 270,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 259,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 237,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 7,
      "reseller_name" : "Ticket Time",
      "reseller_email" : "ticket.sales@TicketTime.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 227,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 249,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 271,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 260,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 238,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 8,
      "reseller_name" : "Ticketron",
      "reseller_email" : "ticket.sales@Ticketron.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 228,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 250,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 272,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 261,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 239,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 9,
      "reseller_name" : "Tickets 2 Go",
      "reseller_email" : "ticket.sales@Tickets2Go.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 229,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 251,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 273,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 262,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 240,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 10,
      "reseller_name" : "Tickets R Us",
      "reseller_email" : "ticket.sales@TicketsRUs.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 230,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 252,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 274,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 263,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 241,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 11,
      "reseller_name" : "Your Ticket Supplier",
      "reseller_email" : "ticket.sales@YourTicketSupplier.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 231,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 253,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 275,
          "assigned_to_others" : 5000,
          "max_available" : 7000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 264,
          "assigned_to_others" : 1000,
          "max_available" : 1000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 242,
          "assigned_to_others" : 1000,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 24,
      "reseller_name" : "Future Event Tickets",
      "reseller_email" : "ticket.sales@ContemporaryEvents.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 938,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : null,
          "assigned_to_others" : 1100,
          "max_available" : 900,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : null,
          "assigned_to_others" : 1100,
          "max_available" : 900,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : null,
          "assigned_to_others" : 5500,
          "max_available" : 6500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : null,
          "assigned_to_others" : 1100,
          "max_available" : 900,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 1500,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : null,
          "assigned_to_others" : 1100,
          "max_available" : 400,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    }
  ]
}
*/