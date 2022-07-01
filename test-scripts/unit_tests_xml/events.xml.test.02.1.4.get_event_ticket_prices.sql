set serveroutput on;
declare
  p_event_id number := 281;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_event_ticket_prices(p_event_id => p_event_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_ticket_prices>
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
      <ticket_group_id>1142</ticket_group_id>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>30</tickets_available>
      <tickets_sold>22</tickets_sold>
      <tickets_remaining>8</tickets_remaining>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>1143</ticket_group_id>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>70</tickets_available>
      <tickets_sold>55</tickets_sold>
      <tickets_remaining>15</tickets_remaining>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>1144</ticket_group_id>
      <price_category>GENERAL ADMISSION</price_category>
      <price>42</price>
      <tickets_available>100</tickets_available>
      <tickets_sold>71</tickets_sold>
      <tickets_remaining>29</tickets_remaining>
    </ticket_group>
  </ticket_groups>
</event_ticket_prices>



PL/SQL procedure successfully completed.


*/