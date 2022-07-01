set serveroutput on;
declare
l_xml varchar2(4000);
  p_xml_doc xmltype;
begin

l_xml := 
'
<event_ticket_groups>
  <event>
    <event_id>281</event_id>
  </event>
  <ticket_groups>
    <ticket_group>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>30</tickets_available>
    </ticket_group>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>70</tickets_available>
    </ticket_group>
    <ticket_group>
      <price_category>general admission</price_category>
      <price>42</price>
      <tickets_available>100</tickets_available>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>
';
p_xml_doc := xmltype(l_xml);

  events_xml_api.update_ticket_groups(p_xml_doc => p_xml_doc);

dbms_output.put_line(p_xml_doc.getclobval);

end;

/*
<event_ticket_groups>
  <event>
    <event_id>281</event_id>
  </event>
  <ticket_groups>
    <ticket_group>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>30</tickets_available>
      <ticket_group_id>1142</ticket_group_id>
      <status_code>SUCCESS</status_code>
      <status_message>Created or updated ticket group</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>70</tickets_available>
      <ticket_group_id>1143</ticket_group_id>
      <status_code>SUCCESS</status_code>
      <status_message>Created or updated ticket group</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>general admission</price_category>
      <price>42</price>
      <tickets_available>100</tickets_available>
      <ticket_group_id>1144</ticket_group_id>
      <status_code>SUCCESS</status_code>
      <status_message>Created or updated ticket group</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_ticket_groups>
*/
