set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
begin

l_xml := 
'
<create_customer>
  <customer>
    <customer_name>Bilbo Baggins</customer_name>
    <customer_email>Bilbo.Baggins@example.customer.com</customer_email>
  </customer>
</create_customer>    
';

    l_xml_doc := xmltype(l_xml);

    events_xml_api.create_customer(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval());

end;

/*
<create_customer>
  <customer>
    <customer_name>Bilbo Baggins</customer_name>
    <customer_email>Bilbo.Baggins@example.customer.com</customer_email>
    <customer_id>5042</customer_id>
    <status_code>SUCCESS</status_code>
    <status_message>Created customer</status_message>
  </customer>
</create_customer>

*/
