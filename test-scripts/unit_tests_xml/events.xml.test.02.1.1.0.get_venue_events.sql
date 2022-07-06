set serveroutput on;
declare
    l_venue_id number;
    l_xml xmltype;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');

    l_xml := events_xml_api.get_venue_events(p_venue_id => l_venue_id,p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
--BEFORE CREATING EVENTS FOR THE NEW VENUE

<venue_events>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
    <max_event_capacity>200</max_event_capacity>
    <venue_scheduled_events>0</venue_scheduled_events>
  </venue>
  <venue_event_listing/>
</venue_events>

--AFTER CREATING TEST EVENT

<venue_events>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
    <max_event_capacity>200</max_event_capacity>
    <venue_scheduled_events>1</venue_scheduled_events>
  </venue>
  <venue_event_listing>
    <event>
      <event_id>561</event_id>
      <event_name>Evangeline Thorpe</event_name>
      <event_date>2023-05-01</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
  </venue_event_listing>
</venue_events>
*/