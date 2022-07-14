set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
    l_reseller_id number;
    l_reseller_name resellers.reseller_name%type := 'New Wave Tickets';
    l_reseller_email resellers.reseller_email%type;
    l_commission resellers.commission_percent%type := 0.1212;
begin
    l_reseller_id := events_api.get_reseller_id(p_reseller_name => l_reseller_name);

l_xml :=
'
<update_reseller>
  <reseller>
    <reseller_id>$$RESELLER_ID$$</reseller_id>
    <reseller_name>$$RESELLER_NAME$$</reseller_name>
    <reseller_email>$$RESELLER_EMAIL$$</reseller_email>
    <commission_percent>$$COMMISSION$$</commission_percent>
  </reseller>
</update_reseller>
';

    l_xml := replace(l_xml, '$$RESELLER_ID$$', l_reseller_id);
    
    l_reseller_name := 'Old Wave Events';
    l_reseller_email := 'sales@OldWaveEvents.com';
    l_commission := 0.0909;
    l_xml := replace(l_xml, '$$RESELLER_NAME$$', l_reseller_name);
    l_xml := replace(l_xml, '$$RESELLER_EMAIL$$', l_reseller_email);
    l_xml := replace(l_xml, '$$COMMISSION$$', l_commission);
    
    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_reseller(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);

l_xml :=
'
<update_reseller>
  <reseller>
    <reseller_id>$$RESELLER_ID$$</reseller_id>
    <reseller_name>$$RESELLER_NAME$$</reseller_name>
    <reseller_email>$$RESELLER_EMAIL$$</reseller_email>
    <commission_percent>$$COMMISSION$$</commission_percent>
  </reseller>
</update_reseller>
';

    l_xml := replace(l_xml, '$$RESELLER_ID$$', l_reseller_id);
    
    l_reseller_name := 'New Wave Tickets';
    l_reseller_email := 'events@NewWaveTickets.com';
    l_commission := 0.1414;
    l_xml := replace(l_xml, '$$RESELLER_NAME$$', l_reseller_name);
    l_xml := replace(l_xml, '$$RESELLER_EMAIL$$', l_reseller_email);
    l_xml := replace(l_xml, '$$COMMISSION$$', l_commission);
    
    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_reseller(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);


end;

/*
<update_reseller>
  <reseller>
    <reseller_id>82</reseller_id>
    <reseller_name>Old Wave Events</reseller_name>
    <reseller_email>sales@OldWaveEvents.com</reseller_email>
    <commission_percent>.0909</commission_percent>
    <status_code>SUCCESS</status_code>
    <status_message>Updated reseller</status_message>
  </reseller>
</update_reseller>

<update_reseller>
  <reseller>
    <reseller_id>82</reseller_id>
    <reseller_name>New Wave Tickets</reseller_name>
    <reseller_email>events@NewWaveTickets.com</reseller_email>
    <commission_percent>.1414</commission_percent>
    <status_code>SUCCESS</status_code>
    <status_message>Updated reseller</status_message>
  </reseller>
</update_reseller>



PL/SQL procedure successfully completed.

*/
