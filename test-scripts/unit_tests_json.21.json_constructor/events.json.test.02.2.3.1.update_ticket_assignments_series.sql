set serveroutput on;
declare
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_name events.event_name%type := 'Monster Truck Smashup';  
    l_venue_id number;
    l_event_series_id number;
    type t_names is table of number index by varchar2(100);
    l_resellers t_names;
    l_groups t_names;
    l_json_doc clob;
    l_json json;
    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_resellers('MaxTix') := reseller_api.get_reseller_id(p_reseller_name => 'MaxTix');
    l_resellers('Source Tix') := reseller_api.get_reseller_id(p_reseller_name => 'Source Tix');
    l_resellers('Ticketron') := reseller_api.get_reseller_id(p_reseller_name => 'Ticketron');


l_json_doc := 
'
{
  "event_series_id" : $$SERIES$$,
  "event_name" : "$$NAME$$",
  "ticket_resellers" :
  [
    {
      "reseller_id" : $$R_ID_MAXTIX$$,
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
      "reseller_id" : $$R_ID_SOURCE_TIX$$,
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
      "reseller_id" : $$R_ID_TICKETRON$$,
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
    l_json_doc := replace(l_json_doc, '$$R_ID_MAXTIX$$', l_resellers('MaxTix'));
    l_json_doc := replace(l_json_doc, '$$R_ID_TICKETRON$$', l_resellers('Ticketron'));
    l_json_doc := replace(l_json_doc, '$$R_ID_SOURCE_TIX$$', l_resellers('Source Tix'));

    l_json := json(l_json_doc);
    events_json_api.update_ticket_assignments_series(p_json_doc => l_json);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));


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

