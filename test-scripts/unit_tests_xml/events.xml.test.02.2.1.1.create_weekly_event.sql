set serveroutput on;
declare
    p_xml_doc xmltype;
    l_xml varchar2(4000);
begin

l_xml := 
'
<create_event_series>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_name>Cool Jazz Evening</event_name>
    <event_start_date>2023-05-01</event_start_date>
    <event_end_date>2023-08-31</event_end_date>
    <event_day>Thursday</event_day>
    <tickets_available>200</tickets_available>
  </event_series>
</create_event_series>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.create_weekly_event(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*

*/
