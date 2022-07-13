--create venue using a json document
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_organizer_name venues.organizer_name%type := 'Susie Brewer';
    l_organizer_email venues.organizer_email%type := 'Susie.Brewer@AnotherRoadsideAttraction.com';
    l_max_capacity venues.max_event_capacity%type := 400;
begin

l_json_doc := 
'
{
  "venue_name" : "$$VENUE_NAME$$",
  "organizer_name" : "$$ORGANIZER_NAME$$",
  "organizer_email" : "$$ORGANIZER_EMAIL$$",
  "max_event_capacity" : $$CAPACITY$$
}
';

    l_json_doc := replace(l_json_doc,'$$VENUE_NAME$$', l_venue_name);
    l_json_doc := replace(l_json_doc,'$$ORGANIZER_NAME$$', l_organizer_name);
    l_json_doc := replace(l_json_doc,'$$ORGANIZER_EMAIL$$', l_organizer_email);
    l_json_doc := replace(l_json_doc,'$$CAPACITY$$', l_max_capacity);

    events_json_api.create_venue(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

 end;

/*  reply document for success
{
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susie Brewer",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 400,
  "venue_id" : 81,
  "status_code" : "SUCCESS",
  "status_message" : "Created venue"
}

  reply document for duplicate venue name
{
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susie Brewer",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 400,
  "venue_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-00001: unique constraint (EVENT_SYSTEM.VENUES_U_NAME) violated"
}


  reply documents for missing elements
{
  "organizer_name" : "Susie Brewer",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 400,
  "venue_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "Missing venue name, cannot create venue"
}

{
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susie Brewer",
  "max_event_capacity" : 400,
  "venue_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "Missing organizer email, cannot create venue"
}

{
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susie Brewer",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "venue_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "Missing event capacity, cannot create venue"
}

*/