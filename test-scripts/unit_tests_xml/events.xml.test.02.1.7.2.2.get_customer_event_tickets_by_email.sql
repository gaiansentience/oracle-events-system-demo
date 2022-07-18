set serveroutput on;
declare
    l_customer_email varchar2(50) := 'James.Kirk@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');

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
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets>6</event_tickets>
    <purchases>
      <purchase>
        <ticket_group_id>2484</ticket_group_id>
        <price_category>VIP</price_category>
        <ticket_sales_id>80343</ticket_sales_id>
        <ticket_quantity>4</ticket_quantity>
        <sales_date>2022-07-15</sales_date>
        <reseller_name>VENUE DIRECT SALES</reseller_name>
        <tickets>
          <ticket>
            <ticket_id>641303</ticket_id>
            <serial_code>G2484C3961S80343D20220715170741Q0004I0001</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641304</ticket_id>
            <serial_code>G2484C3961S80343D20220715170741Q0004I0002</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641305</ticket_id>
            <serial_code>G2484C3961S80343D20220715170741Q0004I0003</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641306</ticket_id>
            <serial_code>G2484C3961S80343D20220715170741Q0004I0004</serial_code>
            <status>ISSUED</status>
          </ticket>
        </tickets>
      </purchase>
      <purchase>
        <ticket_group_id>2485</ticket_group_id>
        <price_category>GENERAL ADMISSION</price_category>
        <ticket_sales_id>80344</ticket_sales_id>
        <ticket_quantity>2</ticket_quantity>
        <sales_date>2022-07-15</sales_date>
        <reseller_name>VENUE DIRECT SALES</reseller_name>
        <tickets>
          <ticket>
            <ticket_id>641307</ticket_id>
            <serial_code>G2485C3961S80344D20220715170741Q0002I0001</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641308</ticket_id>
            <serial_code>G2485C3961S80344D20220715170741Q0002I0002</serial_code>
            <status>ISSUED</status>
          </ticket>
        </tickets>
      </purchase>
    </purchases>
  </event>
</customer_tickets>



PL/SQL procedure successfully completed.


*/