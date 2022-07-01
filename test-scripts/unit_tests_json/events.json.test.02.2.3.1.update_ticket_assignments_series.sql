set serveroutput on;
declare
   v_json_doc clob;
   v_event_id number := 10;
begin
v_json_doc := 
'
{
  "venue_name" : "City Stadium",
  "event_series_id" : 13,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "event_tickets_available" : 10000,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 2,
      "reseller_name" : "MaxTix",
      "reseller_email" : "ticket.sales@MaxTix.com",
      "ticket_assignments" :
      [
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 50
        },
        {
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 1000
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
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 50
        },
        {
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 1000
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
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 1000
        }
      ]
    }
  ]
}

';


events_json_api.update_ticket_assignments_series(p_json_doc => v_json_doc);
--dbms_output.put_line(v_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_clob(v_json_doc));


end;

--reply for successful update/creation
/*

{
  "venue_name" : "City Stadium",
  "event_series_id" : 13,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "event_tickets_available" : 10000,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 2,
      "reseller_name" : "MaxTix",
      "reseller_email" : "ticket.sales@MaxTix.com",
      "ticket_assignments" :
      [
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 50,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (VIP PIT ACCESS) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (RESERVED SEATING) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    },
    {
      "reseller_id" : 8,
      "reseller_name" : "Ticketron",
      "reseller_email" : "ticket.sales@Ticketron.com",
      "ticket_assignments" :
      [
        {
          "price_category" : "VIP PIT ACCESS",
          "price" : 500,
          "tickets_in_group" : 500,
          "tickets_assigned" : 50,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (VIP PIT ACCESS) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "RESERVED SEATING",
          "price" : 350,
          "tickets_in_group" : 4500,
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (RESERVED SEATING) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
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
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (RESERVED SEATING) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "price" : 200,
          "tickets_in_group" : 5000,
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}
*/

