set serveroutput on;
declare
   v_json_doc clob;
   v_event_id number := 10;
begin
v_json_doc := 
'
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "ticket_resellers" :
  [
    {
      "reseller_id" : 21,
      "reseller_name" : "New Wave Tickets",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2322,
          "price_category" : "VIP",
          "tickets_assigned" : 10
        },
        {
          "ticket_group_id" : 2323,
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
          "ticket_group_id" : 2321,
          "price_category" : "SPONSOR",
          "tickets_assigned" : 10
        },
        {
          "ticket_group_id" : 2322,
          "price_category" : "VIP",
          "tickets_assigned" : 150
        },
        {
          "ticket_group_id" : 2323,
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
          "ticket_group_id" : 2323,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 5000
        }
      ]
    }
  ]
}

';


events_json_api.update_ticket_assignments(p_json_doc => v_json_doc);
--dbms_output.put_line(v_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_clob(v_json_doc));


end;

--reply for update with errors
/*
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "ticket_resellers" :
  [
    {
      "reseller_id" : 21,
      "reseller_name" : "New Wave Tickets",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 2322,
          "price_category" : "VIP",
          "tickets_assigned" : 10,
          "ticket_assignment_id" : 9901,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        },
        {
          "ticket_group_id" : 2323,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 500,
          "ticket_assignment_id" : 0,
          "status_code" : "ERROR",
          "status_message" : "ORA-20100: Cannot assign 500 tickets for  GENERAL ADMISSION to reseller, maximum available are 200"
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
          "ticket_group_id" : 2321,
          "price_category" : "SPONSOR",
          "tickets_assigned" : 10,
          "ticket_assignment_id" : 9903,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        },
        {
          "ticket_group_id" : 2322,
          "price_category" : "VIP",
          "tickets_assigned" : 150,
          "ticket_assignment_id" : 0,
          "status_code" : "ERROR",
          "status_message" : "ORA-20100: Cannot assign 150 tickets for  VIP to reseller, maximum available are 40"
        },
        {
          "ticket_group_id" : 2323,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 50,
          "ticket_assignment_id" : 9905,
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
          "ticket_group_id" : 2323,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 5000,
          "ticket_assignment_id" : 0,
          "status_code" : "ERROR",
          "status_message" : "ORA-20100: Cannot assign 5000 tickets for  GENERAL ADMISSION to reseller, maximum available are 200"
        }
      ],
      "reseller_status" : "ERRORS",
      "reseller_errors" : 1
    }
  ],
  "request_status" : "ERRORS",
  "request_errors" : 3
}


PL/SQL procedure successfully completed.


*/
