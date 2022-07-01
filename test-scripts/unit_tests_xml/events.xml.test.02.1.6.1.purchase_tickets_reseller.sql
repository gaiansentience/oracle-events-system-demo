set serveroutput on;
DECLARE
  P_XML_DOC XMLTYPE;
  l_xml varchar2(4000);
BEGIN

l_xml := 
'
<create_event_series>
  <venue>
    <venue_id>2</venue_id>
    <venue_name>Club 11</venue_name>
  </venue>
  <event_name>Cool Jazz Evening</event_name>
  <event_start_date>2023-04-01</event_start_date>
  <event_end_date>2023-07-01</event_end_date>
  <event_day>Thursday</event_day>
  <tickets_available>500</tickets_available>
</create_event_series>
';
p_xml_doc := xmltype(l_xml);

  EVENTS_XML_API.CREATE_weekly_EVENT(
    P_XML_DOC => P_XML_DOC
  );

DBMS_OUTPUT.PUT_LINE(P_XML_DOC.getstringval);

END;

/*
<create_event_series>
  <venue>
    <venue_id>2</venue_id>
    <venue_name>Club 11</venue_name>
  </venue>
  <event_name>Cool Jazz Evening</event_name>
  <event_start_date>2023-04-01</event_start_date>
  <event_end_date>2023-07-01</event_end_date>
  <event_day>Thursday</event_day>
  <tickets_available>500</tickets_available>
  <event_series_id>15</event_series_id>
  <request_status_code>SUCCESS</request_status_code>
  <request_status_message>13 events for (Cool Jazz Evening) created successfully. 0 events could not be created because of conflicts with existing events.</request_status_message>
  <event_series_details>
    <event>
      <event_id>443</event_id>
      <event_date>06-APR-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>444</event_id>
      <event_date>13-APR-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>445</event_id>
      <event_date>20-APR-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>446</event_id>
      <event_date>27-APR-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>447</event_id>
      <event_date>04-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>448</event_id>
      <event_date>11-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>449</event_id>
      <event_date>18-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>450</event_id>
      <event_date>25-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>451</event_id>
      <event_date>01-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>452</event_id>
      <event_date>08-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>453</event_id>
      <event_date>15-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>454</event_id>
      <event_date>22-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>455</event_id>
      <event_date>29-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
  </event_series_details>
</create_event_series>
*/
