--create event using a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_name events.event_name%type := 'New Years Mischief 2022';
    l_event_date varchar2(50) := '2022-12-31T20:00:00';
    l_tickets number := 400;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);

l_json_doc := 
'
{
  "venue_id" : $$VENUE_ID$$,
  "venue_name" : "$$VENUE$$",
  "event_name" : "$$EVENT$$",
  "event_date" : "$$DATE$$",
  "tickets_available" : $$TICKETS$$
}
';

    l_json_doc := replace(l_json_doc, '$$VENUE_ID$$', l_venue_id);
    l_json_doc := replace(l_json_doc, '$$VENUE$$', l_venue_name);
    l_json_doc := replace(l_json_doc, '$$EVENT$$', l_event_name);
    l_json_doc := replace(l_json_doc, '$$DATE$$', l_event_date);
    l_json_doc := replace(l_json_doc, '$$TICKETS$$', l_tickets);
    
    events_json_api.create_event(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json(l_json_doc));

 end;

/*  reply document for success
{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "event_name" : "New Years Mischief 2022",
  "event_date" : "2022-12-31T20:00:00",
  "tickets_available" : 400,
  "event_id" : 622,
  "status_code" : "SUCCESS",
  "status_message" : "Created event"
}

reply for scheduling conflict
{
  "venue_id" : 81,
  "venue_name" : "Another Roadside Attraction",
  "event_name" : "New Years Mischief 2022",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400,
  "event_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Cannot schedule event.  Venue already has event for 12/31/2023"
}




*/