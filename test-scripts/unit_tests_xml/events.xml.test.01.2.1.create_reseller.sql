set serveroutput on;
declare
    l_xml varchar2(4000);
    p_xml_doc xmltype;
begin

l_xml :=
'
<create_reseller>
  <reseller_name>New Wave Tickets</reseller_name>
  <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1111</commission_percent>
</create_reseller>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.create_reseller(p_xml_doc => p_xml_doc);
  
    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<create_reseller>
  <reseller_name>New Wave Tickets</reseller_name>
  <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1111</commission_percent>
  <reseller_id>21</reseller_id>
  <status_code>SUCCESS</status_code>
  <status_message>Created reseller</status_message>
</create_reseller>
*/
