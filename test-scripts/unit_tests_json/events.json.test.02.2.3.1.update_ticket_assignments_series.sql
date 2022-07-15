set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);


l_json_doc := 
'
{
  "event_series_id" : $$SERIES$$,
  "event_name" : "$$NAME$$",
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

    l_json_doc := replace(l_json_doc, '$$SERIES$$', l_event_series_id);
    l_json_doc := replace(l_json_doc, '$$NAME$$', l_event_name);

    events_json_api.update_ticket_assignments_series(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_clob(l_json_doc));


end;

--reply for successful update/creation
/*

{
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
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

