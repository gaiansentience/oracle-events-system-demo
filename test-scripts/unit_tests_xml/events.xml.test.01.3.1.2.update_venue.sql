set serveroutput on;
declare
  p_xml_doc xmltype;
  l_xml varchar2(1000);
begin

l_xml :=
'
<update_venue>
  <venue_id>21</venue_id>
  <venue_name>The Pink Pony Revue</venue_name>
  <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
  <organizer_name>Julia Stein</organizer_name>
  <max_event_capacity>350</max_event_capacity>
</update_venue>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.update_venue(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<update_venue>
  <venue_id>21</venue_id>
  <venue_name>xxxThe Pink Pony Revue</venue_name>
  <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
  <organizer_name>Julia Stein</organizer_name>
  <max_event_capacity>350</max_event_capacity>
  <status_code>SUCCESS</status_code>
  <status_message>Updated venue</status_message>
</update_venue>

*/
