set serveroutput on;
declare
  p_xml_doc xmltype;
  l_xml varchar2(1000);
begin

l_xml :=
'
<venue>
  <venue_name>The Pink Pony Revue</venue_name>
  <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
  <organizer_name>Julia Stein</organizer_name>
  <max_event_capacity>200</max_event_capacity>
</venue>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.create_venue(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<venue>
  <venue_name>The Pink Pony Revue</venue_name>
  <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
  <organizer_name>Julia Stein</organizer_name>
  <max_event_capacity>200</max_event_capacity>
  <venue_id>21</venue_id>
  <status_code>SUCCESS</status_code>
  <status_message>Created venue</status_message>
</venue>

*/
