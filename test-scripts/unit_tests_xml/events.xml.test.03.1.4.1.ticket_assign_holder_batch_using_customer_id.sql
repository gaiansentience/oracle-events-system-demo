--assign name and identification to tickets
set serveroutput on;
declare
    l_xml_template varchar2(4000);
    l_xml varchar2(4000);
    l_xml_doc xmltype;

    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_event_name events.event_name%type := 'Evangeline Thorpe';
    l_customer_email customers.customer_name%type := 'Gary.Walsh@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_customer_id number;

    type r_ticket is record(serial_code tickets.serial_code%type);
    type t_tickets is table of r_ticket;
    l_tickets t_tickets;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select t.serial_code
    bulk collect into l_tickets
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    and t.issued_to_name is null
    order by t.ticket_sales_id, t.ticket_id
    fetch first 3 rows only;
        
l_xml_template :=
'
<ticket_assign_holder_batch>
  <customer>
    <customer_id>$$CUSTOMER$$</customer_id>
  </customer>
  <tickets>
    <ticket>
      <serial_code>$$SERIAL1$$</serial_code>
      <issued_to_name>Nicola Tesla</issued_to_name>
      <issued_to_id>NY987654321</issued_to_id>
    </ticket>
    <ticket>
      <serial_code>$$SERIAL2$$</serial_code>
      <issued_to_name>Thomas Edison</issued_to_name>
      <issued_to_id>NY213450773</issued_to_id>
    </ticket>
    <ticket>
      <serial_code>$$SERIAL3$$</serial_code>
      <issued_to_name>Benjamin Franklin</issued_to_name>
      <issued_to_id>MA00000011</issued_to_id>
    </ticket>
  </tickets>
</ticket_assign_holder_batch>
';
    l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
    for i in 1..l_tickets.count loop
        l_xml := replace(l_xml, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
    end loop;
    l_xml_doc := xmltype(l_xml);
    events_xml_api.ticket_assign_holder_batch(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

    l_xml_doc := events_xml_api.get_customer_event_tickets(p_customer_id => l_customer_id, p_event_id => l_event_id, p_formatted => true);
    dbms_output.put_line(l_xml_doc.getclobval());


end;

/*

<ticket_assign_holder_batch>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <tickets>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0003</serial_code>
      <issued_to_name>Nicola Tesla</issued_to_name>
      <issued_to_id>NY987654321</issued_to_id>
      <status_code>SUCCESS</status_code>
      <status_message>SERIAL CODE ASSIGNED</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0004</serial_code>
      <issued_to_name>Thomas Edison</issued_to_name>
      <issued_to_id>NY213450773</issued_to_id>
      <status_code>SUCCESS</status_code>
      <status_message>SERIAL CODE ASSIGNED</status_message>
    </ticket>
    <ticket>
      <serial_code>G2485C3633S80346D20220715171025Q0008I0001</serial_code>
      <issued_to_name>Benjamin Franklin</issued_to_name>
      <issued_to_id>MA00000011</issued_to_id>
      <status_code>SUCCESS</status_code>
      <status_message>SERIAL CODE ASSIGNED</status_message>
    </ticket>
  </tickets>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</ticket_assign_holder_batch>

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
            <issued_to_name>Albert Einstein</issued_to_name>
            <issued_to_id>MA123456789</issued_to_id>
          </ticket>
          <ticket>
            <ticket_id>641310</ticket_id>
            <serial_code>G2484C3633S80345D20220715171025Q0004I0002</serial_code>
            <status>ISSUED</status>
            <issued_to_name>Elizabeth Einstein</issued_to_name>
            <issued_to_id>MA87655112</issued_to_id>
          </ticket>
          <ticket>
            <ticket_id>641311</ticket_id>
            <serial_code>G2484C3633S80345D20220715171025Q0004I0003</serial_code>
            <status>ISSUED</status>
            <issued_to_name>Nicola Tesla</issued_to_name>
            <issued_to_id>NY987654321</issued_to_id>
          </ticket>
          <ticket>
            <ticket_id>641312</ticket_id>
            <serial_code>G2484C3633S80345D20220715171025Q0004I0004</serial_code>
            <status>ISSUED</status>
            <issued_to_name>Thomas Edison</issued_to_name>
            <issued_to_id>NY213450773</issued_to_id>
          </ticket>
        </tickets>
      </purchase>
      <purchase>
        <ticket_group_id>2485</ticket_group_id>
        <price_category>GENERAL ADMISSION</price_category>
        <ticket_sales_id>80346</ticket_sales_id>
        <ticket_quantity>8</ticket_quantity>
        <sales_date>2022-07-15</sales_date>
        <reseller_id>3</reseller_id>
        <reseller_name>Old School</reseller_name>
        <tickets>
          <ticket>
            <ticket_id>641313</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0001</serial_code>
            <status>ISSUED</status>
            <issued_to_name>Benjamin Franklin</issued_to_name>
            <issued_to_id>MA00000011</issued_to_id>
          </ticket>
          <ticket>
            <ticket_id>641314</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0002</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641315</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0003</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641316</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0004</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641317</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0005</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641318</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0006</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641319</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0007</serial_code>
            <status>ISSUED</status>
          </ticket>
          <ticket>
            <ticket_id>641320</ticket_id>
            <serial_code>G2485C3633S80346D20220715171025Q0008I0008</serial_code>
            <status>ISSUED</status>
          </ticket>
        </tickets>
      </purchase>
    </purchases>
  </event>
</customer_tickets>



PL/SQL procedure successfully completed.


*/
