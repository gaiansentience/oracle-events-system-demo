set serveroutput on;
DECLARE
  P_EVENT_ID NUMBER;
  P_FORMATTED BOOLEAN;
  v_Return XMLTYPE;
BEGIN
  P_EVENT_ID := 1;
  P_FORMATTED := true;

  v_Return := EVENTS_XML_API.GET_EVENT(
    P_EVENT_ID => P_EVENT_ID,
    P_FORMATTED => P_FORMATTED
  );

DBMS_OUTPUT.PUT_LINE(v_Return.getstringval);

END;

/*

<event>
  <venue>
    <venue_id>1</venue_id>
    <venue_name>City Stadium</venue_name>
    <organizer_email>Erin.Johanson@CityStadium.com</organizer_email>
    <organizer_name>Erin Johanson</organizer_name>
  </venue>
  <event_id>1</event_id>
  <event_name>Rudy and the Trees</event_name>
  <event_date>2022-05-27</event_date>
  <tickets_available>20000</tickets_available>
  <tickets_remaining>7808</tickets_remaining>
</event>

*/