--after updating events in series to a capacity of 400 tickets
--create a new ticket group for sponsors and adjust general admission
set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

l_xml := 
'
<event_series_ticket_groups>
  <event_series>
    <venue note="optional-not parsed, only included for testing clarity">
      <venue_id note="optional-not parsed, only included for testing clarity">$$VENUE_ID$$</venue_id>
      <venue_name note="optional-not parsed, only included for testing clarity">$$VENUE_NAME$$</venue_name>
    </venue>
    <event_series_id>$$EVENT_SERIES_ID$$</event_series_id>
    <event_name note="optional-not parsed, only included for testing clarity">$$EVENT_NAME$$</event_name>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>50</tickets_available>
    </ticket_group>
    <ticket_group>
      <price_category>SPONSOR</price_category>
      <price>150</price>
      <tickets_available>50</tickets_available>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available>300</tickets_available>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_groups>
';

    l_xml := replace(l_xml, '$$VENUE_ID$$', l_venue_id);
    l_xml := replace(l_xml, '$$VENUE_NAME$$', l_venue_name);
    l_xml := replace(l_xml, '$$EVENT_SERIES_ID$$', l_event_series_id);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    
    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_ticket_groups_series(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;

/*
<event_series_ticket_groups>
  <event_series>
    <venue note="optional-not parsed, only included for testing clarity">
      <venue_id note="optional-not parsed, only included for testing clarity">82</venue_id>
      <venue_name note="optional-not parsed, only included for testing clarity">The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>82</event_series_id>
    <event_name note="optional-not parsed, only included for testing clarity">Cool Jazz Evening</event_name>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>50</tickets_available>
      <status_code>SUCCESS</status_code>
      <status_message>Ticket group (VIP) created for 17 events in series</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>SPONSOR</price_category>
      <price>150</price>
      <tickets_available>50</tickets_available>
      <status_code>SUCCESS</status_code>
      <status_message>Ticket group (SPONSOR) created for 17 events in series</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available>300</tickets_available>
      <status_code>SUCCESS</status_code>
      <status_message>Ticket group (GENERAL ADMISSION) created for 17 events in series</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_series_ticket_groups>


*/
