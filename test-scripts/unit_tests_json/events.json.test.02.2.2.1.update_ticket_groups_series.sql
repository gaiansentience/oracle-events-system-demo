set serveroutput on;
declare
    l_json_doc varchar2(32000);
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

l_json_doc := 
'
{
  "event_series_id" : $$SERIES$$,
  "event_name" : "$$NAME$$",
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 4500
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500
    }
  ]
}
';

    l_json_doc := replace(l_json_doc, '$$SERIES$$', l_event_series_id);
    l_json_doc := replace(l_json_doc, '$$NAME$$', l_event_name);
    
    events_json_api.update_ticket_groups_series(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

end;

--reply for successful update/creation
/*
{
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 4500,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (RESERVED SEATING) created for 13 events in series"
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (GENERAL ADMISSION) created for 13 events in series"
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500,
      "status_code" : "SUCCESS",
      "status_message" : "Ticket group (VIP PIT ACCESS) created for 13 events in series"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}


PL/SQL procedure successfully completed.

*/
