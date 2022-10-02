--reissue lost ticket serial number using customer id
set serveroutput on;
declare
    l_xml_template varchar2(4000);
    l_xml varchar2(4000);
    l_xml_doc xmltype;

    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_event_name events.event_name%type := 'Evangeline Thorpe';
    l_venue_id number;
    l_event_id number;
    l_customer_email customers.customer_name%type := 'Gary.Walsh@example.customer.com';
    l_customer_id number;

    l_ticket_sales_id number;
    l_ticket_id number;
    l_original_serial_code tickets.serial_code%type;
    l_new_serial_code tickets.serial_code%type;
    l_status tickets.status%type;
    
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select t.ticket_id, t.serial_code, t.status into l_ticket_id, l_original_serial_code, l_status
    from customer_purchases_mv p join tickets t on p.ticket_sales_id = t.ticket_sales_id
    where p.event_id = l_event_id and p.customer_id = l_customer_id
    order by p.ticket_sales_id, t.ticket_id
    fetch first 1 row only;
    
l_xml_template :=
'
<ticket_reissue>
  <customer>
    <customer_id>$$CUSTOMER$$</customer_id>
  </customer>
  <ticket>
    <serial_code>$$SERIAL$$</serial_code>
  </ticket>
</ticket_reissue>
';
l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
l_xml := replace(l_xml, '$$SERIAL$$', l_original_serial_code);
l_xml_doc := xmltype(l_xml);
    dbms_output.put_line('original serial code = ' || l_original_serial_code || ', status is ' || l_status);
    events_xml_api.ticket_reissue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);
    
    select t.serial_code, t.status into l_new_serial_code, l_status
    from tickets t where t.ticket_id = l_ticket_id;
    dbms_output.put_line('after reissuing ticket serial code = ' || l_new_serial_code || ', status is ' || l_status);

l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
l_xml := replace(l_xml, '$$SERIAL$$', l_new_serial_code);
l_xml_doc := xmltype(l_xml);
    dbms_output.put_line('try to reissue the same ticket using the updated serial code');
    events_xml_api.ticket_reissue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
l_xml := replace(l_xml, '$$SERIAL$$', l_original_serial_code);
l_xml_doc := xmltype(l_xml);
    dbms_output.put_line('try to reissue the same ticket using the original serial code');
    events_xml_api.ticket_reissue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);
    
    update tickets t set t.status = 'ISSUED', t.serial_code = l_original_serial_code
    where t.ticket_id = l_ticket_id;
    commit;

l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id + 1);
l_xml := replace(l_xml, '$$SERIAL$$', l_original_serial_code);
l_xml_doc := xmltype(l_xml);
    dbms_output.put_line('reset ticket to issued state and serial code, then try to reissue for another customer');
    events_xml_api.ticket_reissue(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);


end;

/*
original serial code = G2484C3633S80345D20220715171025Q0004I0001, status is ISSUED
<ticket_reissue>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
    <status_code>SUCCESS</status_code>
    <status_message>REISSUED</status_message>
  </ticket>
</ticket_reissue>

after reissuing ticket serial code = G2484C3633S80345D20220715171025Q0004I0001R, status is REISSUED
try to reissue the same ticket using the updated serial code
<ticket_reissue>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001R</serial_code>
    <status_code>ERROR</status_code>
    <status_message>ORA-20100: Ticket has already been reissued, cannot reissue twice.</status_message>
  </ticket>
</ticket_reissue>

try to reissue the same ticket using the original serial code
<ticket_reissue>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
    <status_code>ERROR</status_code>
    <status_message>ORA-20100: Ticket not found for serial code = G2484C3633S80345D20220715171025Q0004I0001</status_message>
  </ticket>
</ticket_reissue>

reset ticket to issued state and serial code, then try to reissue for another customer
<ticket_reissue>
  <customer>
    <customer_id>3634</customer_id>
  </customer>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
    <status_code>ERROR</status_code>
    <status_message>ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue.</status_message>
  </ticket>
</ticket_reissue>
*/
