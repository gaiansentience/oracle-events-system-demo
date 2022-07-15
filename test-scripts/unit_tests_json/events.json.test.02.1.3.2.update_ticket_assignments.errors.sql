--use get_ticket_assignments to get event/reseller/ticket group information for request
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
          "tickets_assigned" : 500
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
          "tickets_assigned" : 150
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
          "tickets_assigned" : 500
        }
      ]
    }
  ]
}
';


    events_json_api.update_ticket_assignments(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_clob(l_json_doc));


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
