set serveroutput on;
declare
    l_xml xmltype;
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_xml := events_xml_api.get_event_series_ticket_prices(p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_series_ticket_prices>
  <event_series>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>82</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>17</events_in_series>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <event_tickets_available>400</event_tickets_available>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available_all_events>850</tickets_available_all_events>
      <tickets_sold_all_events>0</tickets_sold_all_events>
      <tickets_remaining_all_events>850</tickets_remaining_all_events>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available_all_events>5100</tickets_available_all_events>
      <tickets_sold_all_events>0</tickets_sold_all_events>
      <tickets_remaining_all_events>5100</tickets_remaining_all_events>
    </ticket_group>
    <ticket_group>
      <price_category>SPONSOR</price_category>
      <price>150</price>
      <tickets_available_all_events>850</tickets_available_all_events>
      <tickets_sold_all_events>0</tickets_sold_all_events>
      <tickets_remaining_all_events>850</tickets_remaining_all_events>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_prices>



PL/SQL procedure successfully completed.



*/