set serveroutput on;
declare
    l_xml_doc xmltype;
    l_xml varchar2(4000);
    l_customer_id number;
    l_customer_email customers.customer_email%type := 'Gary.Walsh@example.customer.com';
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_reseller_id number;
    l_reseller_name resellers.reseller_name%type := 'Old School';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => l_reseller_name);
    
l_xml := 
'
<ticket_purchase_request>
  <purchase_channel>Old School</purchase_channel>
  <event_series>
    <venue>
      <venue_id>$$VENUE_ID$$</venue_id>
      <venue_name>$$VENUE_NAME$$</venue_name>
    </venue>
    <event_series_id>$$SERIES_ID$$</event_series_id>
    <event_name>$$EVENT_NAME$$</event_name>
  </event_series>
  <customer>
    <customer_email>$$CUSTOMER_EMAIL$$</customer_email>
  </customer>
  <reseller>
    <reseller_id>$$RESELLER_ID$$</reseller_id>
    <reseller_name>$$RESELLER_NAME$$</reseller_name>
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
    
    l_xml := replace(l_xml,'$$VENUE_ID$$', l_venue_id);
    l_xml := replace(l_xml,'$$VENUE_NAME$$', l_venue_name);
    l_xml := replace(l_xml,'$$SERIES_ID$$', l_event_series_id);
    l_xml := replace(l_xml,'$$EVENT_NAME$$', l_event_name);
    
    l_xml := replace(l_xml,'$$CUSTOMER_EMAIL$$', l_customer_email);
    l_xml := replace(l_xml,'$$RESELLER_ID$$', l_reseller_id);
    l_xml := replace(l_xml,'$$RESELLER_NAME$$', l_reseller_name);
    
    l_xml_doc := xmltype(l_xml);
    
    
    delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = l_customer_id);
    delete from ticket_sales ts where ts.customer_id = l_customer_id;
    commit;
    

    events_xml_api.purchase_tickets_reseller_series(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;

/*
<ticket_purchase_request>
  <purchase_channel>Old School</purchase_channel>
  <event_series>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>82</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
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
