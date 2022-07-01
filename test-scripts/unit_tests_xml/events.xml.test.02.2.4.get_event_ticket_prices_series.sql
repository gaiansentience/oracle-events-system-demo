set serveroutput on;
declare
  p_event_series_id number := 15;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_event_series_ticket_prices(p_event_series_id => p_event_series_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_series_ticket_prices>
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
      <tickets_available_all_events>5200</tickets_available_all_events>
      <tickets_sold_all_events>0</tickets_sold_all_events>
      <tickets_remaining_all_events>5200</tickets_remaining_all_events>
    </ticket_group>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available_all_events>1300</tickets_available_all_events>
      <tickets_sold_all_events>0</tickets_sold_all_events>
      <tickets_remaining_all_events>1300</tickets_remaining_all_events>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_prices>



PL/SQL procedure successfully completed.



*/