set serveroutput on;
declare
    l_venue_id number;
    l_event_series_id number;
    l_xml xmltype;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Cool Jazz Evening');

    l_xml := events_xml_api.get_event_series_ticket_prices(p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*

<event_series_ticket_prices>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>17</events_in_series>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <event_tickets_available>200</event_tickets_available>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available_all_events>850</tickets_available_all_events>
      <tickets_sold_all_events>102</tickets_sold_all_events>
      <tickets_remaining_all_events>748</tickets_remaining_all_events>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available_all_events>2550</tickets_available_all_events>
      <tickets_sold_all_events>187</tickets_sold_all_events>
      <tickets_remaining_all_events>2363</tickets_remaining_all_events>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_prices>



PL/SQL procedure successfully completed.


*/