--update event series after creating ticket groups or assignments
set serveroutput on;
declare
    l_xml_doc xmltype;
    l_xml varchar2(4000);
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_event_series_id number;
    l_tickets number := 400;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);    

l_xml := 
'
<update_event_series>
  <event_series>
    <event_series_id>$$EVENT_SERIES_ID$$</event_series_id>
    <event_name>$$EVENT_NAME$$</event_name>
    <tickets_available>$$TICKETS$$</tickets_available>
  </event_series>
</update_event_series>
';

    dbms_output.put_line('after creating ticket groups for event with 200 capacity attempt update to 100 tickets available');
    l_event_name := 'Cool Jazz Evening';
    l_tickets := 100;
    l_xml := replace(l_xml, '$$EVENT_SERIES_ID$$', l_event_series_id);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$TICKETS$$', l_tickets);
    
    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_event_series(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

l_xml := 
'
<update_event_series>
  <event_series>
    <event_series_id>$$EVENT_SERIES_ID$$</event_series_id>
    <event_name>$$EVENT_NAME$$</event_name>
    <tickets_available>$$TICKETS$$</tickets_available>
  </event_series>
</update_event_series>
';

    dbms_output.put_line('update to 400 tickets available per event');
    l_event_name := 'Cool Jazz Evening';
    l_tickets := 400;
    l_xml := replace(l_xml, '$$EVENT_SERIES_ID$$', l_event_series_id);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$TICKETS$$', l_tickets);
    
    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_event_series(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;

/*
after creating ticket groups for event with 200 capacity attempt update to 100 tickets available
<update_event_series>
  <event_series>
    <event_series_id>82</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <tickets_available>100</tickets_available>
    <status_code>ERROR</status_code>
    <status_message>ORA-20100: Cannot downsize events in series to 100.  Modify events individually or change assignments and groups.  Some events have ticket groups defined as 200.  Modify ticket groups first.</status_message>
  </event_series>
</update_event_series>

update to 400 tickets available per event
<update_event_series>
  <event_series>
    <event_series_id>82</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <tickets_available>400</tickets_available>
    <status_code>SUCCESS</status_code>
    <status_message>All events in series that have not occurred have been updated.</status_message>
  </event_series>
</update_event_series>



PL/SQL procedure successfully completed.


*/
