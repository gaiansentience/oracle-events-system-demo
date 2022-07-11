set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
begin

l_xml :=
'
<update_reseller>
  <reseller>
    <reseller_id>21</reseller_id>
    <reseller_name>New Wave Tickets</reseller_name>
    <reseller_email>tickets@NewWaveTickets.com</reseller_email>
    <commission_percent>.1414</commission_percent>
  </reseller>
</update_reseller>
';
    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_reseller(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getstringval);

end;

/*
<update_reseller>
  <reseller>
    <reseller_id>21</reseller_id>
    <reseller_name>New Wave Tickets</reseller_name>
    <reseller_email>tickets@NewWaveTickets.com</reseller_email>
    <commission_percent>.1414</commission_percent>
    <status_code>SUCCESS</status_code>
    <status_message>Updated reseller</status_message>
  </reseller>
</update_reseller>
*/
