set serveroutput on;
declare
    l_xml_doc xmltype;
    l_xml varchar2(1000);
begin

l_xml :=
'
<update_venue>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
  </venue>
</update_venue>
';
    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_venue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);

end;

/*
<update_venue>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
    <status_code>SUCCESS</status_code>
    <status_message>Updated venue</status_message>
  </venue>
</update_venue>

*/
