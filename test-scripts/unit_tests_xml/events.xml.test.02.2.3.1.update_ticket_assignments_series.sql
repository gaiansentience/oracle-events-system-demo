set serveroutput on;
declare
    l_xml_doc xmltype;
    l_xml clob;
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_reseller_id_1 number;
    l_reseller_name_1 resellers.reseller_name%type := 'New Wave Tickets';
    l_reseller_id_2 number;
    l_reseller_name_2 resellers.reseller_name%type := 'Old School';
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_reseller_id_1 := reseller_api.get_reseller_id(p_reseller_name => l_reseller_name_1);
    l_reseller_id_2 := reseller_api.get_reseller_id(p_reseller_name => l_reseller_name_2);
    
    l_xml := replace(l_xml, '$$VENUE_ID$$', l_venue_id);
    l_xml := replace(l_xml, '$$VENUE_NAME$$', l_venue_name);
    l_xml := replace(l_xml, '$$EVENT_SERIES_ID$$', l_event_series_id);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$RESELLER_ID_1$$', l_reseller_id_1);
    l_xml := replace(l_xml, '$$RESELLER_NAME_1$$', l_reseller_name_1);
    l_xml := replace(l_xml, '$$RESELLER_ID_2$$', l_reseller_id_2);
    l_xml := replace(l_xml, '$$RESELLER_NAME_2$$', l_reseller_name_2);

    
l_xml :=
'
<event_series_ticket_assignment>
  <event_series>
    <venue note="optional-not parsed, only included for testing clarity">
      <venue_id note="optional-not parsed, only included for testing clarity">$$VENUE_ID$$</venue_id>
      <venue_name note="optional-not parsed, only included for testing clarity">$$VENUE_NAME$$</venue_name>
    </venue>
    <event_series_id>$$EVENT_SERIES_ID$$</event_series_id>
    <event_name note="optional-not parsed, only included for testing clarity">$$EVENT_NAME$$</event_name>
  </event_series>
  <ticket_resellers>
    <reseller>
      <reseller_id>$$RESELLER_ID_1$$</reseller_id>
      <reseller_name note="optional-not parsed, only included for testing clarity">$$RESELLER_NAME_1$$</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>10</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>100</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>$$RESELLER_ID_2$$</reseller_id>
      <reseller_name note="optional-not parsed, only included for testing clarity">$$RESELLER_NAME_2$$</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>20</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>75</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
  </ticket_resellers>
</event_series_ticket_assignment>
';

    l_xml := replace(l_xml, '$$VENUE_ID$$', l_venue_id);
    l_xml := replace(l_xml, '$$VENUE_NAME$$', l_venue_name);
    l_xml := replace(l_xml, '$$EVENT_SERIES_ID$$', l_event_series_id);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$RESELLER_ID_1$$', l_reseller_id_1);
    l_xml := replace(l_xml, '$$RESELLER_NAME_1$$', l_reseller_name_1);
    l_xml := replace(l_xml, '$$RESELLER_ID_2$$', l_reseller_id_2);
    l_xml := replace(l_xml, '$$RESELLER_NAME_2$$', l_reseller_name_2);


    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_ticket_assignments_series(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;


/*

<event_series_ticket_assignment>
  <event_series>
    <venue note="optional-not parsed, only included for testing clarity">
      <venue_id note="optional-not parsed, only included for testing clarity">82</venue_id>
      <venue_name note="optional-not parsed, only included for testing clarity">The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>82</event_series_id>
    <event_name note="optional-not parsed, only included for testing clarity">Cool Jazz Evening</event_name>
  </event_series>
  <ticket_resellers>
    <reseller>
      <reseller_id>82</reseller_id>
      <reseller_name note="optional-not parsed, only included for testing clarity">New Wave Tickets</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>10</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (VIP) assigned to reseller for 17 events in series</status_message>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>100</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (GENERAL ADMISSION) assigned to reseller for 17 events in series</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
    <reseller>
      <reseller_id>3</reseller_id>
      <reseller_name note="optional-not parsed, only included for testing clarity">Old School</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>20</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (VIP) assigned to reseller for 17 events in series</status_message>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>75</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (GENERAL ADMISSION) assigned to reseller for 17 events in series</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
  </ticket_resellers>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_series_ticket_assignment>

*/