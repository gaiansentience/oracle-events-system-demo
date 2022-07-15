--create event using a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';
    l_tickets number;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    
l_json_doc := 
'
{
  "event_series_id" : $$EVENT_SERIES$$,
  "event_name" : "$$NAME$$",
  "tickets_available" : $$TICKETS$$
}
';

    l_event_name := 'Monster Truck Festival';
    l_tickets := 15000;
    l_json_doc := replace(l_json_doc, '$$EVENT_SERIES$$', l_event_series_id);
    l_json_doc := replace(l_json_doc, '$$NAME$$', l_event_name);
    l_json_doc := replace(l_json_doc, '$$TICKETS$$', l_tickets);

   events_json_api.update_event_series(p_json_doc => l_json_doc);
   dbms_output.put_line(events_json_api.format_json_clob(l_json_doc));


l_json_doc := 
'
{
  "event_series_id" : $$EVENT_SERIES$$,
  "event_name" : "$$NAME$$",
  "tickets_available" : $$TICKETS$$
}
';

    l_event_name := 'Monster Truck Smashup';
    l_tickets := 10000;
    l_json_doc := replace(l_json_doc, '$$EVENT_SERIES$$', l_event_series_id);
    l_json_doc := replace(l_json_doc, '$$NAME$$', l_event_name);
    l_json_doc := replace(l_json_doc, '$$TICKETS$$', l_tickets);

   events_json_api.update_event_series(p_json_doc => l_json_doc);
   dbms_output.put_line(events_json_api.format_json_clob(l_json_doc));


end;

/*  reply document for success
{
  "event_series_id" : 81,
  "event_name" : "Monster Truck Festival",
  "tickets_available" : 15000,
  "status_code" : "SUCCESS",
  "status_message" : "All events in series that have not occurred have been updated."
}



{
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "tickets_available" : 10000,
  "status_code" : "SUCCESS",
  "status_message" : "All events in series that have not occurred have been updated."
}

*/
