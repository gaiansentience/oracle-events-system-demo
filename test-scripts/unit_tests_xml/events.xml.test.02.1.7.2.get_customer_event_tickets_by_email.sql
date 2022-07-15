set serveroutput on;
declare
    l_customer_email varchar2(50) := 'James.Kirk@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');

    l_xml := events_xml_api.get_customer_event_tickets_by_email(p_customer_email => l_customer_email, p_event_id => l_event_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
<customer_tickets>
  <customer>
    <customer_id>3961</customer_id>
    <customer_name>James Kirk</customer_name>
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <event>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>561</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets>6</event_tickets>
    <event_ticket_purchases>
      <ticket_purchase>
        <ticket_group_id>2282</ticket_group_id>
        <price_category>VIP</price_category>
        <ticket_sales_id>71023</ticket_sales_id>
        <ticket_quantity>4</ticket_quantity>
        <sales_date>2022-07-04</sales_date>
        <reseller_name>VENUE DIRECT SALES</reseller_name>
      </ticket_purchase>
      <ticket_purchase>
        <ticket_group_id>2283</ticket_group_id>
        <price_category>GENERAL ADMISSION</price_category>
        <ticket_sales_id>71024</ticket_sales_id>
        <ticket_quantity>2</ticket_quantity>
        <sales_date>2022-07-04</sales_date>
        <reseller_name>VENUE DIRECT SALES</reseller_name>
      </ticket_purchase>
    </event_ticket_purchases>
  </event>
</customer_tickets>

*/