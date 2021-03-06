set serveroutput on;
declare
  l_reseller_id number;
  l_xml xmltype;
begin

    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => 'New Wave Tickets');

    l_xml := events_xml_api.get_reseller(p_reseller_id => l_reseller_id, p_formatted => true);
    dbms_output.put_line(l_xml.getstringval);

end;

/*
<reseller>
  <reseller_id>82</reseller_id>
  <reseller_name>New Wave Tickets</reseller_name>
  <reseller_email>sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1111</commission_percent>
</reseller>

*/