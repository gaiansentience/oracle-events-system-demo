set serveroutput on;
declare
  l_reseller_id number;
  l_xml xmltype;
begin

    select reseller_id into l_reseller_id from resellers where reseller_name = 'New Wave Tickets'; 

    l_xml := events_xml_api.get_reseller(p_reseller_id => l_reseller_id, p_formatted => true);

    dbms_output.put_line(l_xml.getstringval);

end;

/*
<reseller>
  <reseller_id>21</reseller_id>
  <reseller_name>New Wave Tickets</reseller_name>
  <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1111</commission_percent>
</reseller>
*/