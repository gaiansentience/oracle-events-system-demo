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
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'Evangeline Thorpe');
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
--get a specific ticket
select et.serial_code
into l_serial_code
from customer_event_tickets_v et
where et.customer_id = l_customer_id and et.event_id = l_event_id
order by et.ticket_sales_id, et.ticket_id
fetch first 1 row only;

l_xml_template :=
'
<ticket_cancel>
    <event>
        <event_id>$$EVENT$$</event_id>        
    </event>    
    <ticket>
        <serial_code>$$SERIAL$$</serial_code>
    </ticket>
</ticket_cancel>
';
l_xml := replace(l_xml_template, '$$EVENT$$', l_event_id);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code);
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('force the ticket to ISSUED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);
    events_xml_api.ticket_cancel(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);


l_xml := replace(l_xml_template, '$$EVENT$$', l_event_id);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code);
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('force the ticket to VALIDATED');
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_validated, p_use_commit => true);
    events_xml_api.ticket_cancel(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

l_xml := replace(l_xml_template, '$$EVENT$$', l_event_id + 1);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code);
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('try to cancel a ticket from a different event');
    events_xml_api.ticket_cancel(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);


l_xml := replace(l_xml_template, '$$EVENT$$', l_event_id);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code || 'xxxxx');
l_xml_doc := xmltype(l_xml);

    dbms_output.put_line('try to cancel a ticket with an invalid serial code');
    events_xml_api.ticket_cancel(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

    --reset ticket to issued for other testing
    event_tickets_api.update_ticket_status(p_serial_code => l_serial_code, p_status => event_tickets_api.c_ticket_status_issued, p_use_commit => true);

end;

/*

force the ticket to ISSUED
<ticket_cancel>
  <event>
    <event_id>636</event_id>
  </event>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
  </ticket>
  <status_code>SUCCESS</status_code>
  <status_message>CANCELLED</status_message>
</ticket_cancel>

force the ticket to VALIDATED
<ticket_cancel>
  <event>
    <event_id>636</event_id>
  </event>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
  </ticket>
  <status_code>ERROR</status_code>
  <status_message>ORA-20100: Ticket has been validated for event entry, cannot cancel</status_message>
</ticket_cancel>

try to cancel a ticket from a different event
<ticket_cancel>
  <event>
    <event_id>637</event_id>
  </event>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
  </ticket>
  <status_code>ERROR</status_code>
  <status_message>ORA-20100: Ticket is for different event, cannot cancel</status_message>
</ticket_cancel>

try to cancel a ticket with an invalid serial code
<ticket_cancel>
  <event>
    <event_id>636</event_id>
  </event>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001xxxxx</serial_code>
  </ticket>
  <status_code>ERROR</status_code>
  <status_message>ORA-20100: Ticket not found for serial code = G2484C3633S80345D20220715171025Q0004I0001xxxxx</status_message>
</ticket_cancel>



PL/SQL procedure successfully completed.



*/    
