--reissue lost ticket serial number using customer id
set serveroutput on;
declare
    l_xml_template varchar2(4000);
    l_xml varchar2(4000);
    l_xml_doc xmltype;

    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
    l_event_id number;
    l_event_name events.event_name%type := 'Evangeline Thorpe';
    l_customer_id number;
    l_customer_email customers.customer_name%type := 'Gary.Walsh@example.customer.com';

    type r_ticket is record(ticket_id number, serial_code tickets.serial_code%type, status tickets.status%type);
    type t_tickets is table of r_ticket;
    l_tickets t_tickets;
    l_updated_tickets t_tickets;
    l_ticket_ids util_types.t_ids;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select t.ticket_id
    bulk collect into l_ticket_ids
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    order by t.ticket_sales_id, t.ticket_id
    fetch first 3 rows only;
    
    select t.ticket_id, t.serial_code, t.status
    bulk collect into l_tickets
    from tickets t join table(l_ticket_ids) ti on t.ticket_id = ti.column_value;
    
l_xml_template :=
'
<ticket_reissue_batch>
  <customer>
    <customer_id>$$CUSTOMER$$</customer_id>
  </customer>
  <tickets>
    <ticket>
      <serial_code>$$SERIAL1$$</serial_code>
    </ticket>
    <ticket>
      <serial_code>$$SERIAL2$$</serial_code>
    </ticket>
    <ticket>
      <serial_code>$$SERIAL3$$</serial_code>
    </ticket>
  </tickets>
</ticket_reissue_batch>
';
    l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
    for i in 1..l_tickets.count loop
        l_xml := replace(l_xml, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
        dbms_output.put_line('original serial code = ' || l_tickets(i).serial_code || ', status is ' || l_tickets(i).status);
    end loop;
    l_xml_doc := xmltype(l_xml);
    events_xml_api.ticket_reissue_batch(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

    --get the updated serial codes and statuses
    select t.ticket_id, t.serial_code, t.status
    bulk collect into l_updated_tickets
    from tickets t join table(l_ticket_ids) ti on t.ticket_id = ti.column_value;
    for i in 1..l_updated_tickets.count loop    
        dbms_output.put_line('after reissuing ticket serial code = ' || l_updated_tickets(i).serial_code || ', status is ' || l_updated_tickets(i).status);
    end loop;

    dbms_output.put_line('try to reissue the tickets using the updated serial codes');
    l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
    for i in 1..l_tickets.count loop
        l_xml := replace(l_xml, '$$SERIAL' || i || '$$', l_updated_tickets(i).serial_code);
    end loop;
    l_xml_doc := xmltype(l_xml);
    events_xml_api.ticket_reissue_batch(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

    dbms_output.put_line('try to reissue the tickets using the original serial codes');
    l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id);
    for i in 1..l_tickets.count loop
        l_xml := replace(l_xml, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
    end loop;
    l_xml_doc := xmltype(l_xml);
    events_xml_api.ticket_reissue_batch(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);
    

    dbms_output.put_line('update tickets to ISSUED with original serial codes and try to update with a different customer');    
    forall i in 1..l_tickets.count 
    update tickets t set t.status = 'ISSUED', t.serial_code = l_tickets(i).serial_code
    where t.ticket_id = l_tickets(i).ticket_id;
    commit;

    l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_id + 1);
    for i in 1..l_tickets.count loop
        l_xml := replace(l_xml, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
    end loop;
    l_xml_doc := xmltype(l_xml);
    events_xml_api.ticket_reissue_batch(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;

/*
original serial code = G2484C3633S80345D20220715171025Q0004I0001, status is ISSUED
original serial code = G2484C3633S80345D20220715171025Q0004I0002, status is ISSUED
original serial code = G2484C3633S80345D20220715171025Q0004I0003, status is ISSUED
<ticket_reissue_batch>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <tickets>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
      <status_code>SUCCESS</status_code>
      <status_message>REISSUED</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0002</serial_code>
      <status_code>SUCCESS</status_code>
      <status_message>REISSUED</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0003</serial_code>
      <status_code>SUCCESS</status_code>
      <status_message>REISSUED</status_message>
    </ticket>
  </tickets>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</ticket_reissue_batch>

after reissuing ticket serial code = G2484C3633S80345D20220715171025Q0004I0001R, status is REISSUED
after reissuing ticket serial code = G2484C3633S80345D20220715171025Q0004I0002R, status is REISSUED
after reissuing ticket serial code = G2484C3633S80345D20220715171025Q0004I0003R, status is REISSUED
try to reissue the tickets using the updated serial codes
<ticket_reissue_batch>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <tickets>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0001R</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Ticket has already been reissued, cannot reissue twice.</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0002R</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Ticket has already been reissued, cannot reissue twice.</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0003R</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Ticket has already been reissued, cannot reissue twice.</status_message>
    </ticket>
  </tickets>
  <request_status>ERRORS</request_status>
  <request_errors>3</request_errors>
</ticket_reissue_batch>

try to reissue the tickets using the original serial codes
<ticket_reissue_batch>
  <customer>
    <customer_id>3633</customer_id>
  </customer>
  <tickets>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Ticket not found for serial code = G2484C3633S80345D20220715171025Q0004I0001</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0002</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Ticket not found for serial code = G2484C3633S80345D20220715171025Q0004I0002</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0003</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Ticket not found for serial code = G2484C3633S80345D20220715171025Q0004I0003</status_message>
    </ticket>
  </tickets>
  <request_status>ERRORS</request_status>
  <request_errors>3</request_errors>
</ticket_reissue_batch>

update tickets to ISSUED with original serial codes and try to update with a different customer
<ticket_reissue_batch>
  <customer>
    <customer_id>3634</customer_id>
  </customer>
  <tickets>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0001</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue.</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0002</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue.</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3633S80345D20220715171025Q0004I0003</serial_code>
      <status_code>ERROR</status_code>
      <status_message>ORA-20100: Tickets can only be reissued to original purchasing customer, cannot reissue.</status_message>
    </ticket>
  </tickets>
  <request_status>ERRORS</request_status>
  <request_errors>3</request_errors>
</ticket_reissue_batch>



PL/SQL procedure successfully completed.



*/
