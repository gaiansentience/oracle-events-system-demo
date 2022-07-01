set serveroutput on;
declare
  v_event_id number := 16;
  v_json_doc CLOB;
begin

  v_json_doc := events_json_api.get_ticket_assignments(
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
  "event_id" : 16,
  "event_name" : "The Specials",
  "event_date" : "2022-07-08T16:07:19",
  "event_tickets_available" : 20000,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 21,
      "reseller_name" : "New Wave Tickets",
      "reseller_email" : "ticket.sales@NewWaveTickets.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 600,
          "max_available" : 43,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 19,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 57,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 3000,
          "max_available" : 6755,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 2245
        }
      ]
    },
    {
      "reseller_id" : 1,
      "reseller_name" : "Events For You",
      "reseller_email" : "ticket.sales@EventsForYou.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 170,
          "assigned_to_others" : 500,
          "max_available" : 143,
          "min_assignment" : 93,
          "sold_by_reseller" : 93,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 19,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 57,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 3000,
          "max_available" : 6755,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 600,
          "max_available" : 43,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 175,
          "assigned_to_others" : 400,
          "max_available" : 119,
          "min_assignment" : 97,
          "sold_by_reseller" : 97,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 181,
          "assigned_to_others" : 400,
          "max_available" : 157,
          "min_assignment" : 97,
          "sold_by_reseller" : 97,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 3000,
          "max_available" : 6755,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 166,
          "assigned_to_others" : 500,
          "max_available" : 143,
          "min_assignment" : 98,
          "sold_by_reseller" : 98,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 19,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 57,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 3000,
          "max_available" : 6755,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 600,
          "max_available" : 43,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 19,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 180,
          "assigned_to_others" : 400,
          "max_available" : 157,
          "min_assignment" : 94,
          "sold_by_reseller" : 94,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 191,
          "assigned_to_others" : 2500,
          "max_available" : 7255,
          "min_assignment" : 464,
          "sold_by_reseller" : 464,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 169,
          "assigned_to_others" : 500,
          "max_available" : 143,
          "min_assignment" : 92,
          "sold_by_reseller" : 92,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 19,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 177,
          "assigned_to_others" : 400,
          "max_available" : 157,
          "min_assignment" : 98,
          "sold_by_reseller" : 98,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 182,
          "assigned_to_others" : 300,
          "max_available" : 126,
          "min_assignment" : 97,
          "sold_by_reseller" : 97,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 186,
          "assigned_to_others" : 2500,
          "max_available" : 7255,
          "min_assignment" : 494,
          "sold_by_reseller" : 494,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 600,
          "max_available" : 43,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 176,
          "assigned_to_others" : 400,
          "max_available" : 119,
          "min_assignment" : 98,
          "sold_by_reseller" : 98,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 57,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 183,
          "assigned_to_others" : 300,
          "max_available" : 126,
          "min_assignment" : 96,
          "sold_by_reseller" : 96,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 188,
          "assigned_to_others" : 2500,
          "max_available" : 7255,
          "min_assignment" : 478,
          "sold_by_reseller" : 478,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 167,
          "assigned_to_others" : 500,
          "max_available" : 143,
          "min_assignment" : 96,
          "sold_by_reseller" : 96,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 174,
          "assigned_to_others" : 400,
          "max_available" : 119,
          "min_assignment" : 92,
          "sold_by_reseller" : 92,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 178,
          "assigned_to_others" : 400,
          "max_available" : 157,
          "min_assignment" : 98,
          "sold_by_reseller" : 98,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 185,
          "assigned_to_others" : 300,
          "max_available" : 126,
          "min_assignment" : 98,
          "sold_by_reseller" : 98,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 3000,
          "max_available" : 6755,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 168,
          "assigned_to_others" : 500,
          "max_available" : 143,
          "min_assignment" : 96,
          "sold_by_reseller" : 96,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 172,
          "assigned_to_others" : 400,
          "max_available" : 119,
          "min_assignment" : 91,
          "sold_by_reseller" : 91,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 57,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 184,
          "assigned_to_others" : 300,
          "max_available" : 126,
          "min_assignment" : 98,
          "sold_by_reseller" : 98,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 190,
          "assigned_to_others" : 2500,
          "max_available" : 7255,
          "min_assignment" : 468,
          "sold_by_reseller" : 468,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 171,
          "assigned_to_others" : 500,
          "max_available" : 143,
          "min_assignment" : 97,
          "sold_by_reseller" : 97,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 19,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 179,
          "assigned_to_others" : 400,
          "max_available" : 157,
          "min_assignment" : 98,
          "sold_by_reseller" : 98,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 187,
          "assigned_to_others" : 2500,
          "max_available" : 7255,
          "min_assignment" : 497,
          "sold_by_reseller" : 497,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 600,
          "max_available" : 43,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 19,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 57,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 189,
          "assigned_to_others" : 2500,
          "max_available" : 7255,
          "min_assignment" : 477,
          "sold_by_reseller" : 477,
          "sold_by_venue" : 2245
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
          "ticket_group_id" : 958,
          "price_category" : "BACKSTAGE-ALL ACCESS",
          "price" : 150,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 600,
          "max_available" : 43,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1357
        },
        {
          "ticket_group_id" : 959,
          "price_category" : "VIP",
          "price" : 100,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 173,
          "assigned_to_others" : 400,
          "max_available" : 119,
          "min_assignment" : 93,
          "sold_by_reseller" : 93,
          "sold_by_venue" : 1481
        },
        {
          "ticket_group_id" : 960,
          "price_category" : "EARLYBIRD DISCOUNT",
          "price" : 40,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 500,
          "max_available" : 57,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1443
        },
        {
          "ticket_group_id" : 961,
          "price_category" : "RESERVED SEATING",
          "price" : 75,
          "tickets_in_group" : 2000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 400,
          "max_available" : 26,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 1574
        },
        {
          "ticket_group_id" : 962,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 12000,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 3000,
          "max_available" : 6755,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 2245
        }
      ]
    }
  ]
}

*/