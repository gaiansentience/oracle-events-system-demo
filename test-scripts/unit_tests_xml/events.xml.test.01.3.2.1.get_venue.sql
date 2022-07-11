set serveroutput on;
declare
    l_venue_id number;
    l_xml xmltype;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_xml := events_xml_api.get_venue(p_venue_id => l_venue_id, p_formatted => true);
    dbms_output.put_line(l_xml.getstringval);

end;

/*
<venue>
  <venue_id>21</venue_id>
  <venue_name>The Pink Pony Revue</venue_name>
  <organizer_name>Julia Stone</organizer_name>
  <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
  <max_event_capacity>400</max_event_capacity>
  <events_scheduled>18</events_scheduled>
</venue>
*/