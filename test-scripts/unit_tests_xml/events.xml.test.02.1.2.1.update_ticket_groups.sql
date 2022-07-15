set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
    l_event_id number;
    l_event_name events.event_name%type := 'Evangeline Thorpe';
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

l_xml := 
'
<event_ticket_groups>
  <event>
    <event_id>$$EVENT_ID$$</event_id>
  </event>
  <ticket_groups>
    <ticket_group>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>50</tickets_available>
    </ticket_group>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>50</tickets_available>
    </ticket_group>
    <ticket_group>
      <price_category>general admission</price_category>
      <price>42</price>
      <tickets_available>200</tickets_available>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>
';
    l_xml := replace(l_xml, '$$EVENT_ID$$', l_event_id);

    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_ticket_groups(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;

/*

<event_ticket_groups>
  <event>
    <event_id>636</event_id>
  </event>
  <ticket_groups>
    <ticket_group>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>50</tickets_available>
      <ticket_group_id>2483</ticket_group_id>
      <status_code>SUCCESS</status_code>
      <status_message>Created or updated ticket group</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>50</tickets_available>
      <ticket_group_id>2484</ticket_group_id>
      <status_code>SUCCESS</status_code>
      <status_message>Created or updated ticket group</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>general admission</price_category>
      <price>42</price>
      <tickets_available>200</tickets_available>
      <ticket_group_id>2485</ticket_group_id>
      <status_code>SUCCESS</status_code>
      <status_message>Created or updated ticket group</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_ticket_groups>



PL/SQL procedure successfully completed.



*/
