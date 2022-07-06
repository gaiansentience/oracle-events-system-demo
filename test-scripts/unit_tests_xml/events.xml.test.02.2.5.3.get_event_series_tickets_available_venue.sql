set serveroutput on;
declare
    l_venue_id number;
    l_event_series_id number := 15;
    l_xml xmltype;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Cool Jazz Evening');

    l_xml := events_xml_api.get_event_series_tickets_available_venue(p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_series_ticket_availability>
  <ticket_sources>VENUE DIRECT SALES</ticket_sources>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <events_in_series>17</events_in_series>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <ticket_resellers>
        <reseller>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
          <tickets_available>340</tickets_available>
          <events_available>17</events_available>
          <events_sold_out>0</events_sold_out>
        </reseller>
      </ticket_resellers>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <ticket_resellers>
        <reseller>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
          <tickets_available>850</tickets_available>
          <events_available>17</events_available>
          <events_sold_out>0</events_sold_out>
        </reseller>
      </ticket_resellers>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_availability>

*/