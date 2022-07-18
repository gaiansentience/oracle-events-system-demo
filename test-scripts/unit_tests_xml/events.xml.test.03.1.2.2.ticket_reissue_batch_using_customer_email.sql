--reissue lost ticket serial number using customer email
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
    l_customer_email customers.customer_name%type := 'James.Kirk@example.customer.com';
    l_ticket_sales_id number;
    l_ticket_id number;
    l_original_serial_code tickets.serial_code%type;
    l_new_serial_code tickets.serial_code%type;
    l_status tickets.status%type;

    type r_ticket is record(ticket_id number, serial_code tickets.serial_code%type, status tickets.status%type);
    type t_tickets is table of r_ticket;
    l_tickets t_tickets;    
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select t.ticket_id, t.serial_code, t.status 
    bulk collect into l_tickets
    from customer_purchases_mv p join tickets t on p.ticket_sales_id = t.ticket_sales_id
    where p.event_id = l_event_id and p.customer_id = l_customer_id
    order by p.ticket_sales_id, t.ticket_id
    fetch first 3 rows only;
    

l_xml_template :=
'
<ticket_reissue_batch>
  <customer>
    <customer_email>$$CUSTOMER$$</customer_email>
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
l_xml := replace(l_xml_template, '$$CUSTOMER$$', l_customer_email);
for i in 1..3 loop
    l_xml := replace(l_xml, '$$SERIAL' || i || '$$', l_tickets(i).serial_code);
    dbms_output.put_line('original serial code = ' || l_tickets(i).serial_code || ', status is ' || l_tickets(i).status);
end loop;
l_xml_doc := xmltype(l_xml);

    events_xml_api.ticket_reissue_batch(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);
    
for i in 1..3 loop    
    select t.serial_code, t.status into l_new_serial_code, l_status
    from tickets t where t.ticket_id = l_tickets(i).ticket_id;
    dbms_output.put_line('after reissuing ticket serial code = ' || l_new_serial_code || ', status is ' || l_status);
end loop;
    
    forall i in 1..l_tickets.count 
    update tickets t set t.status = 'ISSUED', t.serial_code = l_tickets(i).serial_code
    where t.ticket_id = l_tickets(i).ticket_id;
    commit;


end;

/*
original serial code = G2484C3961S80343D20220715170741Q0004I0001, status is ISSUED
original serial code = G2484C3961S80343D20220715170741Q0004I0002, status is ISSUED
original serial code = G2484C3961S80343D20220715170741Q0004I0003, status is ISSUED
<ticket_reissue_batch>
  <customer>
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <tickets>
    <ticket>
      <serial_code>G2484C3961S80343D20220715170741Q0004I0001</serial_code>
      <status_code>SUCCESS</status_code>
      <status_message>REISSUED</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3961S80343D20220715170741Q0004I0002</serial_code>
      <status_code>SUCCESS</status_code>
      <status_message>REISSUED</status_message>
    </ticket>
    <ticket>
      <serial_code>G2484C3961S80343D20220715170741Q0004I0003</serial_code>
      <status_code>SUCCESS</status_code>
      <status_message>REISSUED</status_message>
    </ticket>
  </tickets>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</ticket_reissue_batch>

after reissuing ticket serial code = G2484C3961S80343D20220715170741Q0004I0001R, status is REISSUED
after reissuing ticket serial code = G2484C3961S80343D20220715170741Q0004I0002R, status is REISSUED
after reissuing ticket serial code = G2484C3961S80343D20220715170741Q0004I0003R, status is REISSUED


PL/SQL procedure successfully completed.


*/
