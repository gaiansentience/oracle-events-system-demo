set serveroutput on;
declare
    l_xml_doc xmltype;
    l_xml varchar2(4000);    
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_event_name events.event_name%type := 'Cool Jazz Evening';
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);

l_xml := 
'
<create_event_series>
  <event_series>
    <venue>
      <venue_id>$$VENUE_ID$$</venue_id>
      <venue_name>$$VENUE_NAME$$</venue_name>
    </venue>
    <event_name>$$EVENT_NAME$$</event_name>
    <event_start_date>2023-05-01</event_start_date>
    <event_end_date>2023-08-31</event_end_date>
    <event_day>Thursday</event_day>
    <tickets_available>200</tickets_available>
  </event_series>
</create_event_series>
';
    l_xml := replace(l_xml, '$$VENUE_ID$$', l_venue_id);
    l_xml := replace(l_xml, '$$VENUE_NAME$$', l_venue_name);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    
    l_xml_doc := xmltype(l_xml);

    events_xml_api.create_weekly_event(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;

/*
<create_event_series>
  <event_series>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_name>Cool Jazz Evening</event_name>
    <event_start_date>2023-05-01</event_start_date>
    <event_end_date>2023-08-31</event_end_date>
    <event_day>Thursday</event_day>
    <tickets_available>200</tickets_available>
    <event_series_id>82</event_series_id>
    <request_status_code>SUCCESS</request_status_code>
    <request_status_message>17 events for (Cool Jazz Evening) created successfully. 0 events could not be created because of conflicts with existing events.</request_status_message>
  </event_series>
  <event_series_details>
    <event>
      <event_id>637</event_id>
      <event_date>04-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>638</event_id>
      <event_date>11-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>639</event_id>
      <event_date>18-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>640</event_id>
      <event_date>25-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>641</event_id>
      <event_date>01-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>642</event_id>
      <event_date>08-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>643</event_id>
      <event_date>15-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>644</event_id>
      <event_date>22-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>645</event_id>
      <event_date>29-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>646</event_id>
      <event_date>06-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>647</event_id>
      <event_date>13-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>648</event_id>
      <event_date>20-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>649</event_id>
      <event_date>27-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>650</event_id>
      <event_date>03-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>651</event_id>
      <event_date>10-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>652</event_id>
      <event_date>17-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>653</event_id>
      <event_date>24-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
  </event_series_details>
</create_event_series>



PL/SQL procedure successfully completed.


*/
