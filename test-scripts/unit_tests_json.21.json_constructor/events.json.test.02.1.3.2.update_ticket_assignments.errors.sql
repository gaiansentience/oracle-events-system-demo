--use get_ticket_assignments to get event/reseller/ticket group information for request
set serveroutput on;
declare
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_name events.event_name%type := 'New Years Mischief';
    l_event_id number;
    l_venue_id number;
    type t_names is table of number index by varchar2(100);
    l_resellers t_names;
    l_groups t_names;
    l_json_doc clob;
    l_json json;
    
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_resellers('New Wave Tickets') := reseller_api.get_reseller_id(p_reseller_name => 'New Wave Tickets');
    l_resellers('Old School') := reseller_api.get_reseller_id(p_reseller_name => 'Old School');
    l_resellers('Tickets R Us') := reseller_api.get_reseller_id(p_reseller_name => 'Tickets R Us');
    l_groups('VIP') := event_setup_api.get_ticket_group_id(p_event_id => l_event_id, p_price_category => 'VIP');
    l_groups('GENERAL ADMISSION') := event_setup_api.get_ticket_group_id(p_event_id => l_event_id, p_price_category => 'GENERAL ADMISSION');
    l_groups('SPONSOR') := event_setup_api.get_ticket_group_id(p_event_id => l_event_id, p_price_category => 'SPONSOR');


l_json_doc := 
'
{
  "event_id" : $$EVENT$$,
  "event_name" : "New Years Mischief",
  "ticket_resellers" :
  [
    {
      "reseller_id" : $$R_ID_NEW_WAVE_TICKETS$$,
      "reseller_name" : "New Wave Tickets",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : $$ID_VIP$$,
          "price_category" : "VIP",
          "tickets_assigned" : 10
        },
        {
          "ticket_group_id" : $$ID_GA$$,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 500
        }
      ]
    },
    {
      "reseller_id" : $$R_ID_OLD_SCHOOL$$,
      "reseller_name" : "Old School",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : $$ID_SPONSOR$$,
          "price_category" : "SPONSOR",
          "tickets_assigned" : 10
        },
        {
          "ticket_group_id" : $$ID_VIP$$,
          "price_category" : "VIP",
          "tickets_assigned" : 150
        },
        {
          "ticket_group_id" : $$ID_GA$$,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 50
        }
      ]
    },
    {
      "reseller_id" : $$R_ID_TICKETS_R_US$$,
      "reseller_name" : "Tickets R Us",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : $$ID_GA$$,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 500
        }
      ]
    }
  ]
}
';

    l_json_doc := replace(l_json_doc, '$$EVENT$$', l_event_id);

    l_json_doc := replace(l_json_doc, '$$R_ID_NEW_WAVE_TICKETS$$', l_resellers('New Wave Tickets'));
    l_json_doc := replace(l_json_doc, '$$R_ID_OLD_SCHOOL$$', l_resellers('Old School'));
    l_json_doc := replace(l_json_doc, '$$R_ID_TICKETS_R_US$$', l_resellers('Tickets R Us'));

    l_json_doc := replace(l_json_doc, '$$ID_VIP$$', l_groups('VIP'));
    l_json_doc := replace(l_json_doc, '$$ID_GA$$', l_groups('GENERAL ADMISSION'));
    l_json_doc := replace(l_json_doc, '$$ID_SPONSOR$$', l_groups('SPONSOR'));

    l_json := json(l_json_doc);
    events_json_api.update_ticket_assignments(p_json_doc => l_json);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

end;

--reply for update with errors
/*

{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 621,
  "event_name" : "New Years Mischief",
  "ticket_resellers" :
  [
    {
      "reseller_id" : 21,
      "reseller_name" : "New Wave Tickets",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "tickets_assigned" : 10,
          "ticket_assignment_id" : 10161,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 0,
          "status_code" : "ERROR",
          "status_message" : "ORA-20100: Cannot assign 500 tickets for  GENERAL ADMISSION to reseller, maximum available are 100"
        }
      ],
      "reseller_status" : "ERRORS",
      "reseller_errors" : 1
    },
    {
      "reseller_id" : 3,
      "reseller_name" : "Old School",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "tickets_assigned" : 10,
          "ticket_assignment_id" : 10163,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "tickets_assigned" : 150,
          "ticket_assignment_id" : 0,
          "status_code" : "ERROR",
          "status_message" : "ORA-20100: Cannot assign 150 tickets for  VIP to reseller, maximum available are 90"
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 50,
          "ticket_assignment_id" : 10165,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        }
      ],
      "reseller_status" : "ERRORS",
      "reseller_errors" : 1
    },
    {
      "reseller_id" : 10,
      "reseller_name" : "Tickets R Us",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 0,
          "status_code" : "ERROR",
          "status_message" : "ORA-20100: Cannot assign 500 tickets for  GENERAL ADMISSION to reseller, maximum available are 100"
        }
      ],
      "reseller_status" : "ERRORS",
      "reseller_errors" : 1
    }
  ],
  "request_status" : "ERRORS",
  "request_errors" : 3
}


*/
