set serveroutput on;
declare
    p_xml_doc xmltype;
    l_xml varchar2(4000);
begin

l_xml := 
'
<create_event_series>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
  </venue>
  <event_name>Cool Jazz Evening</event_name>
  <event_start_date>2023-05-01</event_start_date>
  <event_end_date>2023-08-31</event_end_date>
  <event_day>Thursday</event_day>
  <tickets_available>200</tickets_available>
</create_event_series>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.create_weekly_event(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<create_event_series>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
  </venue>
  <event_name>Cool Jazz Evening</event_name>
  <event_start_date>2023-05-01</event_start_date>
  <event_end_date>2023-08-31</event_end_date>
  <event_day>Thursday</event_day>
  <tickets_available>200</tickets_available>
  <event_series_id>21</event_series_id>
  <request_status_code>SUCCESS</request_status_code>
  <request_status_message>17 events for (Cool Jazz Evening) created successfully. 0 events could not be created because of conflicts with existing events.</request_status_message>
  <event_series_details>
    <event>
      <event_id>562</event_id>
      <event_date>04-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>563</event_id>
      <event_date>11-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>564</event_id>
      <event_date>18-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>565</event_id>
      <event_date>25-MAY-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>566</event_id>
      <event_date>01-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>567</event_id>
      <event_date>08-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>568</event_id>
      <event_date>15-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>569</event_id>
      <event_date>22-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>570</event_id>
      <event_date>29-JUN-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>571</event_id>
      <event_date>06-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>572</event_id>
      <event_date>13-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>573</event_id>
      <event_date>20-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>574</event_id>
      <event_date>27-JUL-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>575</event_id>
      <event_date>03-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>576</event_id>
      <event_date>10-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>577</event_id>
      <event_date>17-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
    <event>
      <event_id>578</event_id>
      <event_date>24-AUG-23</event_date>
      <status_code>SUCCESS</status_code>
      <status_message>Event Created</status_message>
    </event>
  </event_series_details>
</create_event_series>

*/
