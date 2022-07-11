--create venue using a json document
set serveroutput on;
declare
    l_json_doc varchar2(4000);
begin

    l_json_doc := 
'
{
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susie Brewer",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 400
}
';

    events_json_api.create_venue(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

 end;

/*  reply document for success
{
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susie Brewer",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 400,
  "venue_id" : 41,
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