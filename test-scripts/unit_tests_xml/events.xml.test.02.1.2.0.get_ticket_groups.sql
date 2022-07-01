set serveroutput on;
declare
  p_event_id number := 281;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_ticket_groups(p_event_id => p_event_id, p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_ticket_groups>
  <event>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>281</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-02-15</event_date>
    <event_tickets_available>200</event_tickets_available>
  </event>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>0</ticket_group_id>
      <price_category>UNDEFINED</price_category>
      <price>0</price>
      <tickets_available>200</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>
*/
/*
--after defining ticket groups
<event_ticket_groups>
  <event>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>281</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-02-15</event_date>
    <event_tickets_available>200</event_tickets_available>
  </event>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>1144</ticket_group_id>
      <price_category>GENERAL ADMISSION</price_category>
      <price>42</price>
      <tickets_available>100</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>1142</ticket_group_id>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>30</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>1143</ticket_group_id>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>70</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>0</ticket_group_id>
      <price_category>UNDEFINED</price_category>
      <price>0</price>
      <tickets_available>0</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>

*/