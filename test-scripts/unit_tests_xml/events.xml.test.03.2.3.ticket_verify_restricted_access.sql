set serveroutput on;
declare
    l_xml_template varchar2(4000);
    l_xml varchar2(4000);
    l_xml_doc xmltype;
    
    
    l_venue_id number;
    l_event_id number;    
    l_customer_email varchar2(100) := 'Gary.Walsh@example.customer.com';
    l_customer_id number;    
    l_serial_code varchar2(100);
    l_ticket_group_id number;
    l_price_category ticket_groups.price_category%type;
    l_other_ticket_group_id number;
    l_other_price_category ticket_groups.price_category%type;
    
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
--get a specific ticket
select et.serial_code, et.ticket_group_id, et.price_category
into l_serial_code, l_ticket_group_id, l_price_category
from customer_event_tickets_v et
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, et.ticket_id
fetch first 1 row only;
    

l_xml_template :=
'
<ticket_verify_restricted_access>
    <ticket_group>
        <ticket_group_id>$$GROUP$$</ticket_group_id>
        <price_category>$$CATEGORY$$</price_category>
    </ticket_group>
    <ticket>
        <serial_code>$$SERIAL$$</serial_code>
    </ticket>
</ticket_verify_restricted_access>
';
l_xml := replace(l_xml_template, '$$GROUP$$', l_ticket_group_id);
l_xml := replace(l_xml, '$$CATEGORY$$', l_price_category);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code);
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('force the ticket to ISSUED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    events_xml_api.ticket_verify_restricted_access(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);


l_xml := replace(l_xml_template, '$$GROUP$$', l_ticket_group_id);
l_xml := replace(l_xml, '$$CATEGORY$$', l_price_category);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code);
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('force the ticket to VALIDATED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_validated, p_use_commit => true);
    events_xml_api.ticket_verify_restricted_access(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

    select tg.ticket_group_id, tg.price_category
    into l_other_ticket_group_id, l_other_price_category
    from ticket_groups tg where tg.event_id = l_event_id and tg.ticket_group_id <> l_ticket_group_id
    fetch first 1 row only;

l_xml := replace(l_xml_template, '$$GROUP$$', l_other_ticket_group_id);
l_xml := replace(l_xml, '$$CATEGORY$$', l_other_price_category);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code);
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('try to verify access for a different ticket group');
    events_xml_api.ticket_verify_restricted_access(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

l_xml := replace(l_xml_template, '$$GROUP$$', l_ticket_group_id);
l_xml := replace(l_xml, '$$CATEGORY$$', l_price_category);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code || 'xxxxx');
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('try to verify access for an invalid ticket serial code');
    events_xml_api.ticket_verify_restricted_access(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

    --reset ticket status to ISSUED for other testing
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);

end;


/*

force the ticket to ISSUED
<ticket_verify_restricted_access>
  <ticket_group>
    <ticket_group_id>2484</ticket_group_id>
    <price_category>VIP</price_category>
  </ticket_group>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
  </ticket>
  <status_code>ERROR</status_code>
  <status_message>ORA-20100: Ticket has not been validated for event entry, cannot verify access for status ISSUED</status_message>
</ticket_verify_restricted_access>

force the ticket to VALIDATED
<ticket_verify_restricted_access>
  <ticket_group>
    <ticket_group_id>2484</ticket_group_id>
    <price_category>VIP</price_category>
  </ticket_group>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
  </ticket>
  <status_code>SUCCESS</status_code>
  <status_message>ACCESS VERIFIED</status_message>
</ticket_verify_restricted_access>

try to verify access for a different ticket group
<ticket_verify_restricted_access>
  <ticket_group>
    <ticket_group_id>2483</ticket_group_id>
    <price_category>SPONSOR</price_category>
  </ticket_group>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
  </ticket>
  <status_code>ERROR</status_code>
  <status_message>ORA-20100: Ticket is for VIP, ticket not valid for SPONSOR</status_message>
</ticket_verify_restricted_access>

try to verify access for an invalid ticket serial code
<ticket_verify_restricted_access>
  <ticket_group>
    <ticket_group_id>2484</ticket_group_id>
    <price_category>VIP</price_category>
  </ticket_group>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001xxxxx</serial_code>
  </ticket>
  <status_code>ERROR</status_code>
  <status_message>ORA-20100: Ticket not found for serial code = G2484C3633S80345D20220715171025Q0004I0001xxxxx</status_message>
</ticket_verify_restricted_access>



PL/SQL procedure successfully completed.


*/    
