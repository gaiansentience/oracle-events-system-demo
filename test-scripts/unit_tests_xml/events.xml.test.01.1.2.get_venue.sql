set serveroutput on;
DECLARE
  P_VENUE_ID NUMBER;
  P_FORMATTED BOOLEAN;
  v_Return XMLTYPE;
BEGIN
  P_VENUE_ID := 1;
  P_FORMATTED := true;

  v_Return := EVENTS_XML_API.GET_VENUE(
    P_VENUE_ID => P_VENUE_ID,
    P_FORMATTED => P_FORMATTED
  );

DBMS_OUTPUT.PUT_LINE(v_Return.getstringval);

END;

/*
<venue>
  <venue_id>1</venue_id>
  <venue_name>City Stadium</venue_name>
  <organizer_email>Erin.Johanson@CityStadium.com</organizer_email>
  <organizer_name>Erin Johanson</organizer_name>
  <max_event_capacity>20000</max_event_capacity>
  <venue_scheduled_events>5</venue_scheduled_events>
</venue>

*/