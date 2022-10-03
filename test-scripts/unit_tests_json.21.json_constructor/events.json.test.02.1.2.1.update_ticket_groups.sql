set serveroutput on;
declare
    l_json_doc clob;
    l_json json;
    
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
      "tickets_available" : 100
    },
    {
      "price_category" : "VIP",
      "price" : 80,
      "tickets_available" : 100
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 200
    }
  ]
}
';

    l_json_doc := replace(l_json_doc, '$$EVENT$$', l_event_id);

    l_json := json(l_json_doc);    
    events_json_api.update_ticket_groups(p_json_doc => l_json);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

end;

--reply for successful update/creation
/*

{
  "event_id" : 621,
  "ticket_groups" :
  [
    {
      "price_category" : "SPONSOR",
      "price" : 150,
      "tickets_available" : 100,
      "ticket_group_id" : 2441,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "VIP",
      "price" : 80,
      "tickets_available" : 100,
      "ticket_group_id" : 2442,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 200,
      "ticket_group_id" : 2443,
      "status_code" : "SUCCESS",
      "status_message" : "Created/updated ticket group"
    }
  ],
  "request_status" : "SUCCESS",
  "request_errors" : 0
}
*/
