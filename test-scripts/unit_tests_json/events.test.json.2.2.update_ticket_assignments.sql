set serveroutput on;
declare
   v_json_doc clob;
   v_event_id number := 10;
begin
v_json_doc := 
'{
  "event_id" : 10,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 2,
      "reseller_name" : "MaxTix",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000
        }
      ]
    },
    {
      "reseller_id" : 3,
      "reseller_name" : "Old School",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 100
        }
      ]
    },
    {
      "reseller_id" : 5,
      "reseller_name" : "The Source",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 100
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "tickets_assigned" : 100
        }
      ]
    },
    {
      "reseller_id" : 7,
      "reseller_name" : "Ticket Time",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "tickets_assigned" : 250
        }
      ]
    },
    {
      "reseller_id" : 10,
      "reseller_name" : "Tickets R Us",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 100
        }
      ]
    }
  ]
}';


events_json_api.update_event_ticket_assignments(p_json_doc => v_json_doc);
--dbms_output.put_line(v_json_doc);

--output result in readable format
dbms_output.put_line(events_json_api.format_json_clob(v_json_doc));


end;

--reply for successful update/creation
/*


{
  "event_id" : 10,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 2,
      "reseller_name" : "MaxTix",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000,
          "ticket_assignment_id" : 266,
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
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 1000,
          "ticket_assignment_id" : 267,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        },
        {
          "ticket_group_id" : 941,
          "price_category" : "RESERVED SEATING",
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 256,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    },
    {
      "reseller_id" : 5,
      "reseller_name" : "The Source",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 269,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        },
        {
          "ticket_group_id" : 939,
          "price_category" : "VIP",
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 236,
          "status_code" : "SUCCESS",
          "status_message" : "created/updated ticket group assignment"
        }
      ],
      "reseller_status" : "SUCCESS",
      "reseller_errors" : 0
    },
    {
      "reseller_id" : 7,
      "reseller_name" : "Ticket Time",
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 940,
          "price_category" : "EARLYBIRD DISCOUNT",
          "tickets_assigned" : 250,
          "ticket_assignment_id" : 249,
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
          "ticket_group_id" : 942,
          "price_category" : "GENERAL ADMISSION",
          "tickets_assigned" : 100,
          "ticket_assignment_id" : 274,
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

*/

