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

    l_serial_code tickets.serial_code%type;    
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select t.serial_code 
    into l_serial_code
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    and t.issued_to_name is null
    order by t.ticket_sales_id, t.ticket_id
    fetch first 1 row only;
        
l_xml_template :=
'
<ticket_assign_holder>
  <customer>
    <customer_id>$$CUSTOMER$$</customer_id>
  </customer>
  <ticket>
    <serial_code>$$SERIAL$$</serial_code>
    <issued_to_name>Albert Einstein</issued_to_name>
    <issued_to_id>MA123456789</issued_to_id>    
  </ticket>
</ticket_assign_holder>
';
l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
l_xml := replace(l_xml, '$$SERIAL$$', l_serial_code);
l_xml_doc := xmltype(l_xml);

    events_xml_api.ticket_assign_holder(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);
    
end;

/*
<ticket_assign_holder>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <ticket>
    <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
    <issued_to_name>Albert Einstein</issued_to_name>
    <issued_to_id>MA123456789</issued_to_id>
    <status_code>SUCCESS</status_code>
    <status_message>SERIAL CODE ASSIGNED</status_message>
  </ticket>
</ticket_assign_holder>
*/
