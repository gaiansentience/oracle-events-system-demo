set serveroutput on;
declare
  p_event_series_id number := 13;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_event_series_ticket_prices(p_event_series_id => p_event_series_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_series_ticket_prices>
  <event_series>
    <venue>
      <venue_id>1</venue_id>
      <venue_name>City Stadium</venue_name>
    </venue>
    <event_series_id>13</event_series_id>
    <event_name>Monster Truck Smashup</event_name>
    <events_in_series>13</events_in_series>
    <first_event_date>2023-06-07</first_event_date>
    <last_event_date>2023-08-30</last_event_date>
    <event_tickets_available>10000</event_tickets_available>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>RESERVED SEATING</price_category>
      <price>350</price>
      <tickets_available_all_events>58500</tickets_available_all_events>
      <tickets_sold_all_events>1567</tickets_sold_all_events>
      <tickets_remaining_all_events>56933</tickets_remaining_all_events>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>200</price>
      <tickets_available_all_events>65000</tickets_available_all_events>
      <tickets_sold_all_events>1641</tickets_sold_all_events>
      <tickets_remaining_all_events>63359</tickets_remaining_all_events>
    </ticket_group>
    <ticket_group>
      <price_category>VIP PIT ACCESS</price_category>
      <price>500</price>
      <tickets_available_all_events>6500</tickets_available_all_events>
      <tickets_sold_all_events>746</tickets_sold_all_events>
      <tickets_remaining_all_events>5754</tickets_remaining_all_events>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_prices>
*/