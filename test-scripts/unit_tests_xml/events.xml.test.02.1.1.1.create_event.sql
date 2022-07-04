set serveroutput on;
declare
  p_xml_doc xmltype;
  l_xml varchar2(4000);
begin

l_xml := 
'
<create_event>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Review</venue_name>
  </venue>
  <event_name>Evangeline Thorpe</event_name>
  <event_date>2023-05-01</event_date>
  <tickets_available>200</tickets_available>
</create_event>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.create_event(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<create_event>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Review</venue_name>
  </venue>
  <event_name>Evangeline Thorpe</event_name>
  <event_date>2023-05-01</event_date>
  <tickets_available>200</tickets_available>
  <event_id>561</event_id>
  <status_code>SUCCESS</status_code>
  <status_message>Created event</status_message>
</create_event>
*/
