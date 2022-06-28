set serveroutput on;
declare
l_xml varchar2(4000);
  p_xml_doc xmltype;
begin

l_xml := 
'
<event_series_ticket_groups>
  <event_series>
    <venue>
      <venue_id>2</venue_id>
      <venue_name>Club 11</venue_name>
    </venue>
    <event_series_id>15</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>13</events_in_series>
    <first_event_date>2023-04-06</first_event_date>
    <last_event_date>2023-06-29</last_event_date>
    <event_tickets_available>500</event_tickets_available>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>100</tickets_available>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available>400</tickets_available>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_groups>
';
p_xml_doc := xmltype(l_xml);

  events_xml_api.update_ticket_groups_series(p_xml_doc => p_xml_doc);

dbms_output.put_line(p_xml_doc.getclobval);

end;

/*
<event_series_ticket_groups>
  <event_series>
    <venue>
      <venue_id>2</venue_id>
      <venue_name>Club 11</venue_name>
    </venue>
    <event_series_id>15</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>13</events_in_series>
    <first_event_date>2023-04-06</first_event_date>
    <last_event_date>2023-06-29</last_event_date>
    <event_tickets_available>500</event_tickets_available>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>100</tickets_available>
      <status_code>SUCCESS</status_code>
      <status_message>Ticket group (VIP) created for 13 events in series</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available>400</tickets_available>
      <status_code>SUCCESS</status_code>
      <status_message>Ticket group (GENERAL ADMISSION) created for 13 events in series</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_series_ticket_groups>
*/
