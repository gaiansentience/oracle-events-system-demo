set serveroutput on;
declare
    l_xml xmltype;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
    l_event_id number;
    l_event_name events.event_name%type := 'Evangeline Thorpe';
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_xml := events_xml_api.get_event(p_event_id => l_event_id, p_formatted => true);

    dbms_output.put_line(l_xml.getstringval);

end;

/*
<event>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stone</organizer_name>
  </venue>
  <event_id>636</event_id>
  <event_name>Evangeline Thorpe</event_name>
  <event_date>2023-05-01</event_date>
  <tickets_available>300</tickets_available>
  <tickets_remaining>300</tickets_remaining>
</event>

*/