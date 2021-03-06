set serveroutput on;
declare
    l_event_series_id number;
    l_venue_id number;    
    l_reseller_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_series_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Cool Jazz Evening');
    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => 'Old School');
    
    l_xml := events_xml_api.get_event_series_tickets_available_reseller(p_event_series_id => l_event_series_id, p_reseller_id => l_reseller_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;


/*
<event_ticket_availability>
  <ticket_sources>Old School</ticket_sources>
  <event>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>561</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets_available>200</event_tickets_available>
  </event>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>2281</ticket_group_id>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <group_tickets_available>30</group_tickets_available>
      <group_tickets_sold>0</group_tickets_sold>
      <group_tickets_remaining>30</group_tickets_remaining>
      <ticket_resellers>
        <reseller>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
          <tickets_available>20</tickets_available>
          <ticket_status>20 AVAILABLE</ticket_status>
        </reseller>
      </ticket_resellers>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2282</ticket_group_id>
      <price_category>VIP</price_category>
      <price>85</price>
      <group_tickets_available>70</group_tickets_available>
      <group_tickets_sold>10</group_tickets_sold>
      <group_tickets_remaining>60</group_tickets_remaining>
      <ticket_resellers>
        <reseller>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
          <tickets_available>4</tickets_available>
          <ticket_status>4 AVAILABLE</ticket_status>
        </reseller>
      </ticket_resellers>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2283</ticket_group_id>
      <price_category>GENERAL ADMISSION</price_category>
      <price>42</price>
      <group_tickets_available>100</group_tickets_available>
      <group_tickets_sold>4</group_tickets_sold>
      <group_tickets_remaining>96</group_tickets_remaining>
      <ticket_resellers>
        <reseller>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
          <tickets_available>38</tickets_available>
          <ticket_status>38 AVAILABLE</ticket_status>
        </reseller>
      </ticket_resellers>
    </ticket_group>
  </ticket_groups>
</event_ticket_availability>



PL/SQL procedure successfully completed.



*/