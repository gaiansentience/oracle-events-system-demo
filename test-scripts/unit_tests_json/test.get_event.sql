set serveroutput on;
DECLARE
  P_EVENT_ID NUMBER;
  P_FORMATTED BOOLEAN;
  v_Return VARCHAR2(4000);
BEGIN
  P_EVENT_ID := 1;
  P_FORMATTED := true;

  v_Return := EVENTS_JSON_API.GET_EVENT(
    P_EVENT_ID => P_EVENT_ID,
    P_FORMATTED => P_FORMATTED
  );

DBMS_OUTPUT.PUT_LINE(v_Return);

END;
/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "organizer_email" : "Erin.Johanson@CityStadium.com",
  "organizer_name" : "Erin Johanson",
  "event_id" : 1,
  "event_name" : "Rudy and the Trees",
  "event_date" : "2022-05-27T16:07:19",
  "tickets_available" : 20000,
  "tickets_remaining" : 7808
}
*/