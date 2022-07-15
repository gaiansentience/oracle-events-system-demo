--update event using a json document
set serveroutput on;
declare
    l_json_template varchar2(4000);
    l_json_doc varchar2(4000);
    l_venue_id number;
    l_event_id number;
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_name events.event_name%type := 'New Years Mischief';
    l_event_date varchar2(50) := '2023-12-31T20:00:00';
    l_conflicting_date date;
    l_tickets number := 400;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    
l_json_template := 
'
{
  "event_id" : $$EVENT_ID$$,
  "event_name" : "$$EVENT$$",
  "event_date" : "$$DATE$$",
  "tickets_available" : $$TICKETS$$
}
';

    l_json_doc := replace(l_json_template, '$$EVENT_ID$$', l_event_id);
    l_json_doc := replace(l_json_doc, '$$EVENT$$', l_event_name);
    l_json_doc := replace(l_json_doc, '$$DATE$$', l_event_date);
    l_json_doc := replace(l_json_doc, '$$TICKETS$$', l_tickets);
    
    events_json_api.update_event(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));


    select e.event_date into l_conflicting_date from events e where e.venue_id = l_venue_id and e.event_id <> l_event_id fetch first 1 row only;
    
    l_event_date := to_char(l_conflicting_date, 'YYYY-MM-DD"T"HH24:MI:SS');

    l_json_doc := replace(l_json_template, '$$EVENT_ID$$', l_event_id);
    l_json_doc := replace(l_json_doc, '$$EVENT$$', l_event_name);
    l_json_doc := replace(l_json_doc, '$$DATE$$', l_event_date);
    l_json_doc := replace(l_json_doc, '$$TICKETS$$', l_tickets);
    
    events_json_api.update_event(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));



 end;

/*  reply document for success
{
  "event_id" : 621,
  "event_name" : "New Years Mischief",
  "event_date" : "2024-12-31T20:00:00",
  "tickets_available" : 400,
  "status_code" : "SUCCESS",
  "status_message" : "Event information updated"
}


  reply document for scheduling conflict

reply document for event date in past
{
  "event_id" : 621,
  "event_name" : "New Years Mischief",
  "event_date" : "2021-12-31T20:00:00",
  "tickets_available" : 400,
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Cannot schedule event for current date or past dates"
}

reply document for exceeding venue capacity
{
  "event_id" : 621,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 4000,
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: 4000 exceeds venue capacity of 500"
}

{
  "event_id" : 621,
  "event_name" : "New Years Mischief",
  "event_date" : "2022-12-31T20:00:00",
  "tickets_available" : 400,
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Cannot schedule event.  Venue already has event for 12/31/2022"
}

*/