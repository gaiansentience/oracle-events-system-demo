set serveroutput on;
declare
    l_xml xmltype;
    l_venue_id number := 82;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);

    l_xml := events_xml_api.get_venue_events(p_venue_id => l_venue_id, p_formatted => true);
    dbms_output.put_line(l_xml.getclobval());

end;

/*
--BEFORE CREATING EVENTS FOR THE NEW VENUE
<venue_events>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
    <events_scheduled>0</events_scheduled>
  </venue>
  <venue_event_listing/>
</venue_events>

--AFTER CREATING TEST EVENT
<venue_events>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
    <events_scheduled>1</events_scheduled>
  </venue>
  <venue_event_listing>
    <event>
      <event_id>636</event_id>
      <event_name>Evangeline Thorpe</event_name>
      <event_date>2023-05-01</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
  </venue_event_listing>
</venue_events>



PL/SQL procedure successfully completed.



*/