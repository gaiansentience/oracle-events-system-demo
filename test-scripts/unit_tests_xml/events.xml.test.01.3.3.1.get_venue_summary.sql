set serveroutput on;
declare
    l_venue_id number;
    l_xml xmltype;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');    
    l_xml := events_xml_api.get_venue_summary(p_venue_id => l_venue_id, p_formatted => true);
    dbms_output.put_line(l_xml.getclobval);

end;

/*
<venue_summary>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stein</organizer_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>350</max_event_capacity>
  </venue>
  <event_summary>
    <events_scheduled>18</events_scheduled>
    <first_event_date>2023-05-01</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <min_event_tickets>200</min_event_tickets>
    <max_event_tickets>200</max_event_tickets>
  </event_summary>
</venue_summary>

*/