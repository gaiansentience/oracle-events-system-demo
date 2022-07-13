set serveroutput on;
declare
   l_json_doc clob;
begin

l_json_doc := 
'
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
          "tickets_assigned" : 10
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 50
        }
      ]
    },
    {
      "reseller_id" : 3,
      "reseller_name" : "Old School",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2441,
          "price_category" : "SPONSOR",
          "tickets_assigned" : 10
        },
        {
          "ticket_group_id" : 2442,
          "price_category" : "VIP",
          "tickets_assigned" : 10
        },
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 50
        }
      ]
    },
    {
      "reseller_id" : 10,
      "reseller_name" : "Tickets R Us",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 50
        }
      ]
    }
  ]
}
';


    events_json_api.update_ticket_assignments(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_clob(l_json_doc));


end;

--reply for successful update/creation
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
          "tickets_assigned" : 50,
          "ticket_assignment_id" : 10162,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
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
          "tickets_assigned" : 10,
          "ticket_assignment_id" : 10164,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
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
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    },
    {
      "reseller_id" : 10,
      "reseller_name" : "Tickets R Us",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2443,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 50,
          "ticket_assignment_id" : 10166,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
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

