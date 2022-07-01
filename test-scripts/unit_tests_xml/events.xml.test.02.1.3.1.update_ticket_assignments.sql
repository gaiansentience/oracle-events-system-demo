set serveroutput on;
declare
p_xml_doc xmltype;
l_xml varchar2(32000);
begin

l_xml :=
'
<event_ticket_assignment>
  <event>
    <event_id>281</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-02-15</event_date>
    <event_tickets_available>200</event_tickets_available>
  </event>
  <ticket_resellers>
    <reseller>
      <reseller_id>21</reseller_id>
      <reseller_name>New Wave Tickets</reseller_name>
      <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>1144</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <price>42</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>40</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>1143</ticket_group_id>
          <price_category>VIP</price_category>
          <price>85</price>
          <tickets_in_group>70</tickets_in_group>
          <tickets_assigned>30</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>3</reseller_id>
      <reseller_name>Old School</reseller_name>
      <reseller_email>ticket.sales@OldSchool.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>1144</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <price>42</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>40</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>1142</ticket_group_id>
          <price_category>SPONSOR</price_category>
          <price>120</price>
          <tickets_in_group>30</tickets_in_group>
          <tickets_assigned>20</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>1143</ticket_group_id>
          <price_category>VIP</price_category>
          <price>85</price>
          <tickets_in_group>70</tickets_in_group>
          <tickets_assigned>10</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
  </ticket_resellers>
</event_ticket_assignment>
';

p_xml_doc := xmltype(l_xml);

  events_xml_api.update_ticket_assignments(
    p_xml_doc => p_xml_doc
  );

dbms_output.put_line(p_xml_doc.getclobval);

end;


/*

<event_ticket_assignment>
  <event>
    <event_id>281</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-02-15</event_date>
    <event_tickets_available>200</event_tickets_available>
  </event>
  <ticket_resellers>
    <reseller>
      <reseller_id>21</reseller_id>
      <reseller_name>New Wave Tickets</reseller_name>
      <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>1144</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <price>42</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>40</tickets_assigned>
          <ticket_assignment_id>3961</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>1143</ticket_group_id>
          <price_category>VIP</price_category>
          <price>85</price>
          <tickets_in_group>70</tickets_in_group>
          <tickets_assigned>30</tickets_assigned>
          <ticket_assignment_id>3962</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
    <reseller>
      <reseller_id>3</reseller_id>
      <reseller_name>Old School</reseller_name>
      <reseller_email>ticket.sales@OldSchool.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>1144</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <price>42</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>40</tickets_assigned>
          <ticket_assignment_id>3963</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>1142</ticket_group_id>
          <price_category>SPONSOR</price_category>
          <price>120</price>
          <tickets_in_group>30</tickets_in_group>
          <tickets_assigned>20</tickets_assigned>
          <ticket_assignment_id>3964</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>1143</ticket_group_id>
          <price_category>VIP</price_category>
          <price>85</price>
          <tickets_in_group>70</tickets_in_group>
          <tickets_assigned>10</tickets_assigned>
          <ticket_assignment_id>3965</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
  </ticket_resellers>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_ticket_assignment>

*/