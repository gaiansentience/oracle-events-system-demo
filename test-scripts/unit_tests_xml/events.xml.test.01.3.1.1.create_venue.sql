set serveroutput on;
declare
    l_xml_template varchar2(1000);    
    l_xml varchar2(1000);    
    l_xml_doc xmltype;
    l_venue venues%rowtype;
begin

    l_venue.venue_name := 'The Pink Pony Revue';
    l_venue.organizer_name := 'Julie Stone';
    l_venue.organizer_email := 'Julie.Stone@ThePinkPonyRevue.com';
    l_venue.max_event_capacity := 200;
    l_venue.venue_id := venue_api.get_venue_id(p_venue_name => l_venue.venue_name);

l_xml_template :=
'
<create_venue>
  <venue>
    <venue_name>$$VENUE_NAME$$</venue_name>
    <organizer_name>$$ORGANIZER_NAME$$</organizer_name>
    <organizer_email>$$ORGANIZER_EMAIL$$</organizer_email>
    <max_event_capacity>$$CAPACITY$$</max_event_capacity>
  </venue>
</create_venue>
';

    l_xml := replace(l_xml_template, '$$VENUE_NAME$$', l_venue.venue_name);
    l_xml := replace(l_xml, '$$ORGANIZER_NAME$$', l_venue.organizer_name);
    l_xml := replace(l_xml, '$$ORGANIZER_EMAIL$$', l_venue.organizer_email);
    l_xml := replace(l_xml, '$$CAPACITY$$', l_venue.max_event_capacity);
    l_xml_doc := xmltype(l_xml);
    events_xml_api.create_venue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);

    --try to create the same venue again
    l_xml := replace(l_xml_template, '$$VENUE_NAME$$', l_venue.venue_name);
    l_xml := replace(l_xml, '$$ORGANIZER_NAME$$', l_venue.organizer_name);
    l_xml := replace(l_xml, '$$ORGANIZER_EMAIL$$', l_venue.organizer_email);
    l_xml := replace(l_xml, '$$CAPACITY$$', l_venue.max_event_capacity);
    l_xml_doc := xmltype(l_xml);
    events_xml_api.create_venue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);


end;

/*
<create_venue>
  <venue>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julie Stein</organizer_name>
    <organizer_email>Julie.Stein@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>200</max_event_capacity>
    <venue_id>82</venue_id>
    <status_code>SUCCESS</status_code>
    <status_message>Created venue</status_message>
  </venue>
</create_venue>

<create_venue>
  <venue>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julie Stone</organizer_name>
    <organizer_email>Julie.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>200</max_event_capacity>
    <venue_id>0</venue_id>
    <status_code>ERROR</status_code>
    <status_message>ORA-00001: unique constraint (EVENT_SYSTEM.VENUES_U_NAME) violated</status_message>
  </venue>
</create_venue>


*/
