set serveroutput on;
declare
    l_xml_template varchar2(1000);
    l_xml varchar2(1000);
    l_xml_doc xmltype;
    l_venue venues%rowtype;
begin

    l_venue.venue_name := 'The Pink Pony Revue';
    l_venue.organizer_name := 'Julia Stone';
    l_venue.organizer_email := 'Julia.Stone@ThePinkPonyRevue.com';
    l_venue.max_event_capacity := 400;
    l_venue.venue_id := venue_api.get_venue_id(p_venue_name => l_venue.venue_name);

l_xml_template :=
'
<update_venue>
  <venue>
    <venue_id>$$VENUE_ID$$</venue_id>
    <venue_name>$$VENUE_NAME$$</venue_name>
    <organizer_name>$$ORGANIZER_NAME$$</organizer_name>
    <organizer_email>$$ORGANIZER_EMAIL$$</organizer_email>
    <max_event_capacity>$$CAPACITY$$</max_event_capacity>
  </venue>
</update_venue>
';
    l_venue.venue_name := 'The Pink Pony Jazz House';
    l_venue.organizer_name := 'George Hill';
    l_venue.organizer_email := 'George.Hill@ThePinkPonyJazzHouse.com';
    l_venue.max_event_capacity := 300;
    
    l_xml := replace(l_xml_template, '$$VENUE_ID$$', l_venue.venue_id);
    l_xml := replace(l_xml, '$$VENUE_NAME$$', l_venue.venue_name);
    l_xml := replace(l_xml, '$$ORGANIZER_NAME$$', l_venue.organizer_name);
    l_xml := replace(l_xml, '$$ORGANIZER_EMAIL$$', l_venue.organizer_email);
    l_xml := replace(l_xml, '$$CAPACITY$$', l_venue.max_event_capacity);
    l_xml_doc := xmltype(l_xml);
    events_xml_api.update_venue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);

    --update to original venue name
    l_venue.venue_name := 'The Pink Pony Revue';
    l_venue.organizer_name := 'Julia Stone';
    l_venue.organizer_email := 'Julia.Stone@ThePinkPonyRevue.com';
    l_venue.max_event_capacity := 400;
    
    l_xml := replace(l_xml_template, '$$VENUE_ID$$', l_venue.venue_id);
    l_xml := replace(l_xml, '$$VENUE_NAME$$', l_venue.venue_name);
    l_xml := replace(l_xml, '$$ORGANIZER_NAME$$', l_venue.organizer_name);
    l_xml := replace(l_xml, '$$ORGANIZER_EMAIL$$', l_venue.organizer_email);
    l_xml := replace(l_xml, '$$CAPACITY$$', l_venue.max_event_capacity);
    l_xml_doc := xmltype(l_xml);
    events_xml_api.update_venue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);


end;

/*

<update_venue>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Jazz House</venue_name>
    <organizer_name>George Hill</organizer_name>
    <organizer_email>George.Hill@ThePinkPonyJazzHouse.com</organizer_email>
    <max_event_capacity>300</max_event_capacity>
    <status_code>SUCCESS</status_code>
    <status_message>Updated venue</status_message>
  </venue>
</update_venue>

<update_venue>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
    <status_code>SUCCESS</status_code>
    <status_message>Updated venue</status_message>
  </venue>
</update_venue>

*/
