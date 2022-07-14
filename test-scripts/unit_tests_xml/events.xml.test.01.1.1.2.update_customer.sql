set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
    l_customer_id number;
    l_customer_name customers.customer_name%type := 'Frodo Underhill';
    l_customer_email customers.customer_email%type := 'Bilbo.Baggins@example.customer.com';
begin

    l_customer_id := events_api.get_customer_id(p_customer_email => l_customer_email);
    
l_xml := 
'
<update_customer>
  <customer>
    <customer_id>$$CUSTOMER_ID$$</customer_id>
    <customer_name>$$NAME$$</customer_name>
    <customer_email>$$EMAIL$$</customer_email>
  </customer>
</update_customer>    
';

    l_xml := replace(l_xml, '$$CUSTOMER_ID$$', l_customer_id);
    l_xml := replace(l_xml, '$$NAME$$', l_customer_name);
    l_xml := replace(l_xml, '$$EMAIL$$', l_customer_email);

    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_customer(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval());

end;

/*
<update_customer>
  <customer>
    <customer_id>5042</customer_id>
    <customer_name>Frodo Underhill</customer_name>
    <customer_email>Bilbo.Baggins@example.customer.com</customer_email>
    <status_code>SUCCESS</status_code>
    <status_message>Updated customer</status_message>
  </customer>
</update_customer>
*/
