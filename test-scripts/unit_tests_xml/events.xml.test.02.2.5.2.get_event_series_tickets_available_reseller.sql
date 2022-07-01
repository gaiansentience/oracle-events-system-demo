set serveroutput on;
declare
  p_event_series_id number := 15;
  v_reseller_id number := 3;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_event_series_tickets_available_reseller(p_event_series_id => p_event_series_id,p_reseller_id => v_reseller_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*

<event_series_ticket_availability>
  <ticket_sources>Old School</ticket_sources>
  <event_series>
    <venue>
      <venue_id>2</venue_id>
      <venue_name>Club 11</venue_name>
    </venue>
    <event_series_id>15</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-04-06</first_event_date>
    <last_event_date>2023-06-29</last_event_date>
    <events_in_series>13</events_in_series>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <ticket_resellers>
        <reseller>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
          <tickets_available>390</tickets_available>
          <events_available>13</events_available>
          <events_sold_out>0</events_sold_out>
        </reseller>
      </ticket_resellers>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <ticket_resellers>
        <reseller>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
          <tickets_available>2600</tickets_available>
          <events_available>13</events_available>
          <events_sold_out>0</events_sold_out>
        </reseller>
      </ticket_resellers>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_availability>

*/