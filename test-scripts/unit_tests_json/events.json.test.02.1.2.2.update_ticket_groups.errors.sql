--total of all ticket groups cannot exceed event capacity
--if tickets in a group are assigned, group cannot be set below level of current assignments
--if tickets in a group have been sold by venue, group cannot be set below venue_sales + reseller assignments
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_name events.event_name%type := 'New Years Mischief';
    l_event_id number;   
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

l_json_doc := 
'
{
  "event_id" : $$EVENT$$,
  "ticket_groups" :
  [
    {
      "price_category" : "SPONSOR",
      "price" : 150,
      "tickets_available" : 250
    },
    {
      "price_category" : "VIP",
      "price" : 80,
      "tickets_available" : 100
    },
    {
      "price_category" : "RESERVED",
      "price" : 65,
      "tickets_available" : 100
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 300
    }
  ]
}
';

    l_json_doc := replace(l_json_doc, '$$EVENT$$', l_event_id);

    events_json_api.update_ticket_groups(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_clob(l_json_doc));


end;

--reply for update with errors
/*

{
  "event_id" : 621,
  "ticket_groups" :
  [
    {
      "price_category" : "SPONSOR",
      "price" : 150,
      "tickets_available" : 250,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot create SPONSOR  with 250 tickets.  Only 50 are available."
    },
    {
      "price_category" : "VIP",
      "price" : 80,
      "tickets_available" : 100,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot create VIP  with 100 tickets.  Only 50 are available."
    },
    {
      "price_category" : "RESERVED",
      "price" : 65,
      "tickets_available" : 100,
      "ticket_group_id" : 0,
      "status_code" : "ERROR",
      "status_message" : "ORA-20100: Cannot create RESERVED  with 100 tickets.  Only 0 are available."
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 300,
      "ticket_group_id" : 2443,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    }
  ],
  "request_status" : "ERRORS",
  "request_errors" : 3
}

*/
