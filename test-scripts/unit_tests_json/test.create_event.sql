set serveroutput on;
DECLARE
  P_JSON_DOC VARCHAR2(0400);
BEGIN
  P_JSON_DOC := 
'
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "event_id" : 1,
  "event_name" : "Rudy and the Trees",
  "event_date" : "2023-05-03T19:00:00",
  "tickets_available" : 11000
}
';

  EVENTS_JSON_API.CREATE_EVENT(
    P_JSON_DOC => P_JSON_DOC
  );
  p_json_doc := events_json_api.format_json_string(p_json_doc);
  
DBMS_OUTPUT.PUT_LINE(P_JSON_DOC);

END;

/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "event_name" : "Rudy and the Trees",
  "event_date" : "2023-05-03T19:00:00",
  "tickets_available" : 11000,
  "event_id" : 284,
  "status_code" : "SUCCESS",
  "status_message" : "Created event"
}
*/
