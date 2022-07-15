set serveroutput on;
declare
    l_xml xmltype;
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_reseller_id number;
    l_reseller_name resellers.reseller_name%type := 'Old School';    
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => l_reseller_name);

    l_xml := events_xml_api.get_event_series_tickets_available_reseller(p_event_series_id => l_event_series_id, p_reseller_id => l_reseller_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_series_ticket_availability>
  <ticket_sources>Old School</ticket_sources>
  <event_series>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>82</event_series_id>
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
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
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
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
          <tickets_available>1275</tickets_available>
          <events_available>17</events_available>
          <events_sold_out>0</events_sold_out>
        </reseller>
      </ticket_resellers>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_availability>



PL/SQL procedure successfully completed.



*/