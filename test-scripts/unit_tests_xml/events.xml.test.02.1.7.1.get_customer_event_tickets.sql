set serveroutput on;
declare
    l_customer_id number;
    l_customer_email varchar2(100) := 'Gary.Walsh@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    l_xml := events_xml_api.get_customer_event_tickets(p_customer_id => l_customer_id, p_event_id => l_event_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;


/*
<customer_tickets>
  <customer>
    <customer_id>3633</customer_id>
    <customer_name>Gary Walsh</customer_name>
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
  </customer>
  <event>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>561</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets>8</event_tickets>
    <event_ticket_purchases>
      <ticket_purchase>
        <ticket_group_id>2282</ticket_group_id>
        <price_category>VIP</price_category>
        <ticket_sales_id>71021</ticket_sales_id>
        <ticket_quantity>6</ticket_quantity>
        <sales_date>2022-07-04</sales_date>
        <reseller_id>3</reseller_id>
        <reseller_name>Old School</reseller_name>
      </ticket_purchase>
      <ticket_purchase>
        <ticket_group_id>2283</ticket_group_id>
        <price_category>GENERAL ADMISSION</price_category>
        <ticket_sales_id>71022</ticket_sales_id>
        <ticket_quantity>2</ticket_quantity>
        <sales_date>2022-07-04</sales_date>
        <reseller_id>3</reseller_id>
        <reseller_name>Old School</reseller_name>
      </ticket_purchase>
    </event_ticket_purchases>
  </event>
</customer_tickets>



PL/SQL procedure successfully completed.



*/