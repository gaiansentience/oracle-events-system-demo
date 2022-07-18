set serveroutput on;
declare
    l_customer_id number;
    l_customer_email varchar2(100) := 'Gary.Walsh@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_ticket_sales_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select ticket_sales_id into l_ticket_sales_id
    from customer_purchases_mv 
    where 
        event_id = l_event_id 
        and customer_id = l_customer_id 
    fetch first 1 row only;
    
    
    l_xml := events_xml_api.get_customer_event_tickets_by_sale_id(p_customer_id => l_customer_id, p_ticket_sales_id => l_ticket_sales_id, p_formatted => true);
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
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets>12</event_tickets>
    <purchases>
      <purchase>
        <ticket_group_id>2484</ticket_group_id>
        <price_category>VIP</price_category>
        <ticket_sales_id>80345</ticket_sales_id>
        <ticket_quantity>4</ticket_quantity>
        <sales_date>2022-07-15</sales_date>
        <reseller_id>3</reseller_id>
        <reseller_name>Old School</reseller_name>
        <tickets>
          <ticket>
            <ticket_id>641309</ticket_id>
            <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641310</ticket_id>
            <serial_code>G2484C3633S80345D20220715171025Q0004I0002</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641311</ticket_id>
            <serial_code>G2484C3633S80345D20220715171025Q0004I0003</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641312</ticket_id>
            <serial_code>G2484C3633S80345D20220715171025Q0004I0004</serial_code>
            <status>ISSUED</status>
          </ticket>
        </tickets>
      </purchase>
    </purchases>
  </event>
</customer_tickets>



PL/SQL procedure successfully completed.



*/