set serveroutput on;
declare
  p_customer_id number := 4;
  p_event_id number := 1;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_customer_event_tickets(p_customer_id => p_customer_id,p_event_id => p_event_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;


/*
<customer_tickets>
  <customer>
    <customer_id>4</customer_id>
    <customer_name>Kathy Barry</customer_name>
    <customer_email>Kathy.Barry@example.customer.com</customer_email>
  </customer>
  <event>
    <venue>
      <venue_id>1</venue_id>
      <venue_name>City Stadium</venue_name>
    </venue>
    <event_id>1</event_id>
    <event_name>Rudy and the Trees</event_name>
    <event_date>2022-05-27</event_date>
  </event>
  <total_tickets_purchased>2</total_tickets_purchased>
  <event_ticket_purchases>
    <ticket_purchase>
      <ticket_group_id>913</ticket_group_id>
      <price_category>BACKSTAGE-ALL ACCESS</price_category>
      <ticket_sales_id>13203</ticket_sales_id>
      <ticket_quantity>2</ticket_quantity>
      <sales_date>2022-05-13</sales_date>
      <reseller_name>VENUE DIRECT SALES</reseller_name>
    </ticket_purchase>
  </event_ticket_purchases>
</customer_tickets>
*/