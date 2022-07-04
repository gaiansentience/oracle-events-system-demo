set serveroutput on;
declare
  p_xml_doc xmltype;
  l_xml varchar2(4000);
begin

l_xml := 
'
<ticket_purchase_request>
  <purchase_channel>Old School</purchase_channel>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>17</events_in_series>
  </event_series>
  <customer>
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
  </customer>
  <reseller>
    <reseller_id>3</reseller_id>
    <reseller_name>Old School</reseller_name>
  </reseller>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>110</price>
      <tickets_requested>2</tickets_requested>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>60</price>
      <tickets_requested>3</tickets_requested>
    </ticket_group>
  </ticket_groups>
</ticket_purchase_request>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.purchase_tickets_reseller_series(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*

<ticket_purchase_request>
  <purchase_channel>Old School</purchase_channel>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>17</events_in_series>
  </event_series>
  <customer>
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
    <customer_id>3633</customer_id>
  </customer>
  <reseller>
    <reseller_id>3</reseller_id>
    <reseller_name>Old School</reseller_name>
  </reseller>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>110</price>
      <tickets_requested>2</tickets_requested>
      <average_price>100</average_price>
      <tickets_purchased>34</tickets_purchased>
      <purchase_amount>3400</purchase_amount>
      <status_code>SUCCESS</status_code>
      <status_message>Tickets purchased for 17 events in the series.</status_message>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>60</price>
      <tickets_requested>3</tickets_requested>
      <average_price>50</average_price>
      <tickets_purchased>51</tickets_purchased>
      <purchase_amount>2550</purchase_amount>
      <status_code>SUCCESS</status_code>
      <status_message>Tickets purchased for 17 events in the series.</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
  <total_tickets_requested>5</total_tickets_requested>
  <total_tickets_purchased>85</total_tickets_purchased>
  <total_purchase_amount>5950</total_purchase_amount>
  <purchase_disclaimer>All Ticket Sales Are Final.</purchase_disclaimer>
</ticket_purchase_request>

*/
