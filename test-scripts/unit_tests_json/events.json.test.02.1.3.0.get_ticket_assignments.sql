set serveroutput on;
declare
    l_event_id number;
    l_venue_id number;
    l_json_doc CLOB;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'Another Roadside Attraction');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'New Years Mischief');

    l_json_doc := events_json_api.get_ticket_assignments(p_event_id => l_event_id, p_formatted => true);

    dbms_output.put_line(l_json_doc);

end;
--reply format example
/*

{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
  "organizer_name" : "Susan Brewer",
  "event_id" : 621,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "event_tickets_available" : 400,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 21,
      "reseller_name" : "New Wave Tickets",
      "reseller_email" : "tickets@NewWaveTickets.com",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
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
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "price" : 150,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "price" : 80,
          "tickets_in_group" : 100,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 100,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "price" : 50,
          "tickets_in_group" : 200,
          "tickets_assigned" : 0,
          "ticket_assignment_id" : 0,
          "assigned_to_others" : 0,
          "max_available" : 200,
          "min_assignment" : 0,
          "sold_by_reseller" : 0,
          "sold_by_venue" : 0
        }
      ]
    }
  ]
}


*/