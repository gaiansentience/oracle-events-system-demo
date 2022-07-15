set serveroutput on;
declare
    l_xml_doc xmltype;
    l_xml varchar2(4000);
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
--    l_event_id number;
    l_event_name events.event_name%type := 'Evangeline Thorpe';
    l_event_date varchar2(50) := '2023-05-01';
    l_tickets number := 200;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);

l_xml := 
'
<create_event>
  <event>
    <venue>
      <venue_id>$$VENUE_ID$$</venue_id>
      <venue_name>$$VENUE_NAME$$</venue_name>
    </venue>
    <event_name>$$EVENT_NAME$$</event_name>
    <event_date>$$EVENT_DATE$$</event_date>
    <tickets_available>$$TICKETS$$</tickets_available>
  </event>
</create_event>
';

    l_xml := replace(l_xml, '$$VENUE_ID$$', l_venue_id);
    l_xml := replace(l_xml, '$$VENUE_NAME$$', l_venue_name);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$EVENT_DATE$$', l_event_date);
    l_xml := replace(l_xml, '$$TICKETS$$', l_tickets);

    l_xml_doc := xmltype(l_xml);

    events_xml_api.create_event(p_xml_doc => l_xml_doc);

    dbms_output.put_line(l_xml_doc.getstringval);

end;

/*
<create_event>
  <event>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <tickets_available>200</tickets_available>
    <event_id>636</event_id>
    <status_code>SUCCESS</status_code>
    <status_message>Created event</status_message>
  </event>
</create_event>

*/
