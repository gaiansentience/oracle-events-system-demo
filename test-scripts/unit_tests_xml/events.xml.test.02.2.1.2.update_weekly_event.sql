set serveroutput on;
declare
    p_xml_doc xmltype;
    l_xml varchar2(4000);
begin

l_xml := 
'
<update_event_series>
  <event_series>
    <event_series_id>13</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <tickets_available>200</tickets_available>
  </event_series>
</update_event_series>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.create_weekly_event(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*

*/
