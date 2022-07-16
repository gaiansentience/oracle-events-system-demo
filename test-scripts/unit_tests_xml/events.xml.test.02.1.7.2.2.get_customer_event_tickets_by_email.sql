set serveroutput on;
declare
    l_customer_email varchar2(50) := 'James.Kirk@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');

    l_xml := events_xml_api.get_customer_event_purchases_by_email(p_customer_email => l_customer_email, p_event_id => l_event_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*

<customer_event_ticket_purchases>
  <customer>
    <customer_id>3961</customer_id>
    <customer_name>James Kirk</customer_name>
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <event>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets>6</event_tickets>
    <event_ticket_purchases>
      <ticket_purchase>
        <ticket_group_id>2484</ticket_group_id>
        <price_category>VIP</price_category>
        <ticket_sales_id>80343</ticket_sales_id>
        <ticket_quantity>4</ticket_quantity>
        <sales_date>2022-07-15</sales_date>
        <reseller_name>VENUE DIRECT SALES</reseller_name>
      </ticket_purchase>
      <ticket_purchase>
        <ticket_group_id>2485</ticket_group_id>
        <price_category>GENERAL ADMISSION</price_category>
        <ticket_sales_id>80344</ticket_sales_id>
        <ticket_quantity>2</ticket_quantity>
        <sales_date>2022-07-15</sales_date>
        <reseller_name>VENUE DIRECT SALES</reseller_name>
      </ticket_purchase>
    </event_ticket_purchases>
  </event>
</customer_event_ticket_purchases>



PL/SQL procedure successfully completed.


*/