set serveroutput on;
declare
  p_event_series_id number := 15;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_ticket_groups_series(p_event_series_id => p_event_series_id, p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

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
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available>400</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>100</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_groups>



PL/SQL procedure successfully completed.


*/