set serveroutput on;
declare
  p_venue_id number := 21;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_venue_events(p_venue_id => p_venue_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
<venue_events>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
    <max_event_capacity>200</max_event_capacity>
    <venue_scheduled_events>2</venue_scheduled_events>
  </venue>
  <venue_event_listing>
    <event>
      <event_id>281</event_id>
      <event_name>Evangeline Thorpe</event_name>
      <event_date>2023-02-15</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>282</event_id>
      <event_name>Evangeline Thorpe</event_name>
      <event_date>2023-03-22</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
  </venue_event_listing>
</venue_events>



PL/SQL procedure successfully completed.


*/