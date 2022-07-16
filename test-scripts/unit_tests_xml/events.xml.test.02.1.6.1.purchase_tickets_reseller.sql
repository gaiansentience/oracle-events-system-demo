--use get_event_tickets_available_venue or get_event_tickets_available_all for correct event/ticket_group_id values
set serveroutput on;
declare
  l_xml_doc xmltype;
  l_xml varchar2(4000);
begin

l_xml := 
'
<ticket_purchase_request>
  <purchase_channel>Old School</purchase_channel>
  <event>
    <event_id>636</event_id>
  </event>
  <customer>
    <customer_name>Gary Walsh</customer_name>
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
  </customer>
  <reseller>
    <reseller_id>3</reseller_id>
    <reseller_name>Old School</reseller_name>
  </reseller>  
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>2484</ticket_group_id>
      <price>85</price>
      <tickets_requested>4</tickets_requested>      
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2485</ticket_group_id>
      <price>42</price>
      <tickets_requested>8</tickets_requested>      
    </ticket_group>
  </ticket_groups>
</ticket_purchase_request>
';
    l_xml_doc := xmltype(l_xml);

    events_xml_api.purchase_tickets_reseller(p_xml_doc => l_xml_doc);

    dbms_output.put_line(l_xml_doc.getstringval);

end;

/*


<ticket_purchase_request>
  <purchase_channel>Old School</purchase_channel>
  <event>
    <event_id>636</event_id>
  </event>
  <customer>
    <customer_name>Gary Walsh</customer_name>
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
    <customer_id>3633</customer_id>
  </customer>
  <reseller>
    <reseller_id>3</reseller_id>
    <reseller_name>Old School</reseller_name>
  </reseller>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>2484</ticket_group_id>
      <price>85</price>
      <tickets_requested>4</tickets_requested>
      <price_category>VIP</price_category>
      <ticket_sales_id>80345</ticket_sales_id>
      <actual_price>85</actual_price>
      <tickets_purchased>4</tickets_purchased>
      <purchase_amount>340</purchase_amount>
      <status_code>SUCCESS</status_code>
      <status_message>group tickets purchased</status_message>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2485</ticket_group_id>
      <price>42</price>
      <tickets_requested>8</tickets_requested>
      <price_category>GENERAL ADMISSION</price_category>
      <ticket_sales_id>80346</ticket_sales_id>
      <actual_price>42</actual_price>
      <tickets_purchased>8</tickets_purchased>
      <purchase_amount>336</purchase_amount>
      <status_code>SUCCESS</status_code>
      <status_message>group tickets purchased</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
  <total_tickets_requested>12</total_tickets_requested>
  <total_tickets_purchased>12</total_tickets_purchased>
  <total_purchase_amount>676</total_purchase_amount>
  <purchase_disclaimer>All Ticket Sales Are Final.</purchase_disclaimer>
</ticket_purchase_request>


*/
