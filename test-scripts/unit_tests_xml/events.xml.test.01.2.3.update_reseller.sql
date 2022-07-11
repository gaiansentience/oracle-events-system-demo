set serveroutput on;
declare
    l_xml varchar2(4000);
    p_xml_doc xmltype;
begin

l_xml :=
'
<update_reseller>
  <reseller_id>21</reseller_id>
  <reseller_name>New Wave Tickets</reseller_name>
  <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1313</commission_percent>
</update_reseller>
';
    p_xml_doc := xmltype(l_xml);

    events_xml_api.update_reseller(p_xml_doc => p_xml_doc);
  
    dbms_output.put_line(p_xml_doc.getstringval);

end;

/*
<update_reseller>
  <reseller_id>21</reseller_id>
  <reseller_name>xyzNew Wave Tickets</reseller_name>
  <reseller_email>xyzticket.sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1313</commission_percent>
  <status_code>SUCCESS</status_code>
  <status_message>Updated reseller</status_message>
</update_reseller>
*/
