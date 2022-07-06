set serveroutput on;
declare
  p_xml_doc xmltype;
  l_xml varchar2(4000);
  l_customer_id number;
begin

l_xml := 
'
<ticket_purchase_request>
  <purchase_channel>VENUE</purchase_channel>
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
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <reseller>
    <reseller_name>VENUE DIRECT SALES</reseller_name>
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
      <tickets_requested>5</tickets_requested>
    </ticket_group>
  </ticket_groups>
</ticket_purchase_request>
';
    p_xml_doc := xmltype(l_xml);
    
    l_customer_id := events_api.get_customer_id(p_customer_email => 'James.Kirk@example.customer.com');
    
    delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = l_customer_id);
    delete from ticket_sales ts where ts.customer_id = l_customer_id;
    commit;
    

    events_xml_api.purchase_tickets_venue_series(p_xml_doc => p_xml_doc);

    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<ticket_purchase_request>
  <purchase_channel>VENUE</purchase_channel>
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
    <customer_email>James.Kirk@example.customer.com</customer_email>
    <customer_id>3961</customer_id>
  </customer>
  <reseller>
    <reseller_name>VENUE DIRECT SALES</reseller_name>
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
      <tickets_requested>5</tickets_requested>
      <average_price>50</average_price>
      <tickets_purchased>85</tickets_purchased>
      <purchase_amount>4250</purchase_amount>
      <status_code>SUCCESS</status_code>
      <status_message>Tickets purchased for 17 events in the series.</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
  <total_tickets_requested>7</total_tickets_requested>
  <total_tickets_purchased>119</total_tickets_purchased>
  <total_purchase_amount>7650</total_purchase_amount>
  <purchase_disclaimer>All Ticket Sales Are Final.</purchase_disclaimer>
</ticket_purchase_request>



PL/SQL procedure successfully completed.

*/
