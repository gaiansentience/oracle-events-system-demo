set serveroutput on;
declare
    l_event_id number;
    l_venue_id number;
    l_xml xmltype;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');

    l_xml := events_xml_api.get_event(p_event_id => l_event_id, p_formatted => true);

    dbms_output.put_line(l_xml.getstringval);

end;

/*
<event>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
  </venue>
  <event_id>561</event_id>
  <event_name>Evangeline Thorpe</event_name>
  <event_date>2023-05-01</event_date>
  <tickets_available>200</tickets_available>
  <tickets_remaining>186</tickets_remaining>
</event>
*/