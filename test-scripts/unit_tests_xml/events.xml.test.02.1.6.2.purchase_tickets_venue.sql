set serveroutput on;
declare
  p_xml_doc xmltype;
  l_xml varchar2(4000);
begin

l_xml := 
'
<ticket_purchase_request>
  <purchase_channel>VENUE</purchase_channel>
  <event>
    <event_id>561</event_id>
  </event>
  <customer>
    <customer_name>James Kirk</customer_name>
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <reseller>
    <reseller_name>VENUE DIRECT SALES</reseller_name>
  </reseller>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>2282</ticket_group_id>
      <price>85</price>
      <tickets_requested>4</tickets_requested>      
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2283</ticket_group_id>
      <price>42</price>
      <tickets_requested>2</tickets_requested>      
    </ticket_group>
  </ticket_groups>
</ticket_purchase_request>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.purchase_tickets_venue(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<ticket_purchase_request>
  <purchase_channel>VENUE</purchase_channel>
  <event>
    <event_id>561</event_id>
  </event>
  <customer>
    <customer_name>James Kirk</customer_name>
    <customer_email>James.Kirk@example.customer.com</customer_email>
    <customer_id>3961</customer_id>
  </customer>
  <reseller>
    <reseller_name>VENUE DIRECT SALES</reseller_name>
  </reseller>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>2282</ticket_group_id>
      <price>85</price>
      <tickets_requested>4</tickets_requested>
      <price_category>VIP</price_category>
      <ticket_sales_id>71023</ticket_sales_id>
      <actual_price>85</actual_price>
      <tickets_purchased>4</tickets_purchased>
      <purchase_amount>340</purchase_amount>
      <status_code>SUCCESS</status_code>
      <status_message>group tickets purchased</status_message>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2283</ticket_group_id>
      <price>42</price>
      <tickets_requested>2</tickets_requested>
      <price_category>GENERAL ADMISSION</price_category>
      <ticket_sales_id>71024</ticket_sales_id>
      <actual_price>42</actual_price>
      <tickets_purchased>2</tickets_purchased>
      <purchase_amount>84</purchase_amount>
      <status_code>SUCCESS</status_code>
      <status_message>group tickets purchased</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
  <total_tickets_requested>6</total_tickets_requested>
  <total_tickets_purchased>6</total_tickets_purchased>
  <total_purchase_amount>424</total_purchase_amount>
  <purchase_disclaimer>All Ticket Sales Are Final.</purchase_disclaimer>
</ticket_purchase_request>

*/
