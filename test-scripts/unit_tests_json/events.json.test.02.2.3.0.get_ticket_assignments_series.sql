set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_json_doc := events_json_api.get_ticket_assignments_series(p_event_series_id => l_event_series_id, p_formatted => true);
    dbms_output.put_line(l_json_doc);

end;
--reply format example
/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "event_tickets_available" : 10000,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 21,
      "reseller_name" : "New Wave Tickets",
      "reseller_email" : "tickets@NewWaveTickets.com",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
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
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 73,
      "reseller_name" : "Easy Tickets",
      "reseller_email" : "tickets@EasyTickets.com",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    },
    {
      "reseller_id" : 81,
      "reseller_name" : "Ticket Factory",
      "reseller_email" : "sales@TicketFactory.com",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 4500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 5000,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 0,
          "assigned_to_others" : 0,
          "max_available" : 500,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    }
  ]
}


PL/SQL procedure successfully completed.




*/