set serveroutput on;
declare
    l_venue_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');    
    l_xml := events_xml_api.get_venue_summary(p_venue_id => l_venue_id, p_formatted => true);
    dbms_output.put_line(l_xml.getclobval);

end;

/*
<venue_summary>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
  </venue>
  <event_summary>
    <events_scheduled>0</events_scheduled>
    <min_event_tickets>0</min_event_tickets>
    <max_event_tickets>0</max_event_tickets>
  </event_summary>
</venue_summary>



PL/SQL procedure successfully completed.


*/