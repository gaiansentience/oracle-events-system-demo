set serveroutput on;
DECLARE
l_xml varchar2(4000);
  P_XML_DOC XMLTYPE;
BEGIN

l_xml :=
'
<reseller>
  <reseller_name>New Wave Tickets</reseller_name>
  <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1111</commission_percent>
</reseller>
';
p_xml_doc := xmltype(l_xml);

  EVENTS_XML_API.CREATE_RESELLER(
    P_XML_DOC => P_XML_DOC
  );
DBMS_OUTPUT.PUT_LINE(P_XML_DOC.getstringval);

END;

/*

<reseller>
  <reseller_name>New Wave Tickets</reseller_name>
  <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
  <commission_percent>.1111</commission_percent>
  <reseller_id>21</reseller_id>
  <status_code>SUCCESS</status_code>
  <status_message>Created reseller</status_message>
</reseller>

*/
