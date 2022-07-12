set serveroutput on;
declare
  p_xml_doc xmltype;
  l_xml varchar2(4000);
begin

l_xml := 
'
<update_event>
  <event>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <tickets_available>200</tickets_available>
  </event>
</update_event>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.create_event(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*

*/
