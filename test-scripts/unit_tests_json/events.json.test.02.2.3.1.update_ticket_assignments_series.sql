set serveroutput on;
declare
   v_json_doc clob;
begin
v_json_doc := 
'
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "event_tickets_available" : 10000,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 2,
      "reseller_name" : "MaxTix",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "tickets_assigned" : 100
        }
      ]
    },
    {
      "reseller_id" : 4,
      "reseller_name" : "Source Tix",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 100
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "tickets_assigned" : 100
        }
      ]
    },
    {
      "reseller_id" : 8,
      "reseller_name" : "Ticketron",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "tickets_assigned" : 100
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
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 41,
  "event_name" : "Monster Truck Smashup",
  "event_tickets_available" : 10000,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 2,
      "reseller_name" : "MaxTix",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (RESERVED SEATING) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "tickets_assigned" : 100,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (VIP PIT ACCESS) assigned to reseller for 13 events in series"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    },
    {
      "reseller_id" : 4,
      "reseller_name" : "Source Tix",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 100,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (RESERVED SEATING) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "tickets_assigned" : 100,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (VIP PIT ACCESS) assigned to reseller for 13 events in series"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    },
    {
      "reseller_id" : 8,
      "reseller_name" : "Ticketron",
      "ticket_assignments" :
      [
        {
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (RESERVED SEATING) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series"
        },
        {
          "price_category" : "VIP PIT ACCESS",
          "tickets_assigned" : 100,
          "status_code" : "SUCCESS",
          "status_message" : "Ticket group (VIP PIT ACCESS) assigned to reseller for 13 events in series"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}


PL/SQL procedure successfully completed.


*/

