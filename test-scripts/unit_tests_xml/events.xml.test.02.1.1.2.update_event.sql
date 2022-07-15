set serveroutput on;
declare
  l_xml_doc xmltype;
  l_xml varchar2(4000);
  
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
    l_event_id number;
    l_event_name events.event_name%type := 'Evangeline Thorpe';
    l_event_date varchar2(50) := '2023-05-01';
    l_tickets number := 300;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    
l_xml := 
'
<update_event>
  <event>
    <event_id>$$EVENT_ID$$</event_id>
    <event_name>$$EVENT_NAME$$</event_name>
    <event_date>$$EVENT_DATE$$</event_date>
    <tickets_available>$$TICKETS$$</tickets_available>
  </event>
</update_event>
';


    l_xml := replace(l_xml, '$$EVENT_ID$$', l_event_id);
    l_event_name := 'Evangeline Thorpe and the Rebel Choir';
    l_event_date := '2023-07-04';
    l_tickets := 200;

    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$EVENT_DATE$$', l_event_date);
    l_xml := replace(l_xml, '$$TICKETS$$', l_tickets);

    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_event(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);


l_xml := 
'
<update_event>
  <event>
    <event_id>$$EVENT_ID$$</event_id>
    <event_name>$$EVENT_NAME$$</event_name>
    <event_date>$$EVENT_DATE$$</event_date>
    <tickets_available>$$TICKETS$$</tickets_available>
  </event>
</update_event>
';


    l_xml := replace(l_xml, '$$EVENT_ID$$', l_event_id);
    l_event_name := 'Evangeline Thorpe';
    l_event_date := '2021-05-01';
    l_tickets := 100;

    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$EVENT_DATE$$', l_event_date);
    l_xml := replace(l_xml, '$$TICKETS$$', l_tickets);

    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_event(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);

l_xml := 
'
<update_event>
  <event>
    <event_id>$$EVENT_ID$$</event_id>
    <event_name>$$EVENT_NAME$$</event_name>
    <event_date>$$EVENT_DATE$$</event_date>
    <tickets_available>$$TICKETS$$</tickets_available>
  </event>
</update_event>
';


    l_xml := replace(l_xml, '$$EVENT_ID$$', l_event_id);
    l_event_name := 'Evangeline Thorpe';
    l_event_date := '2023-05-01';
    l_tickets := 300;

    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$EVENT_DATE$$', l_event_date);
    l_xml := replace(l_xml, '$$TICKETS$$', l_tickets);

    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_event(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);


end;

/*
<update_event>
  <event>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe and the Rebel Choir</event_name>
    <event_date>2023-07-04</event_date>
    <tickets_available>200</tickets_available>
    <status_code>SUCCESS</status_code>
    <status_message>Event information updated</status_message>
  </event>
</update_event>

<update_event>
  <event>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2021-05-01</event_date>
    <tickets_available>100</tickets_available>
    <status_code>ERROR</status_code>
    <status_message>ORA-20100: Cannot schedule event for current date or past dates</status_message>
  </event>
</update_event>

<update_event>
  <event>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <tickets_available>300</tickets_available>
    <status_code>SUCCESS</status_code>
    <status_message>Event information updated</status_message>
  </event>
</update_event>



PL/SQL procedure successfully completed.


*/
