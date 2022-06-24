set serveroutput on;
declare
    l_xml varchar2(4000);
    p_xml_doc xmltype;
begin

l_xml := 
'
<create_customer>
  <customer>
    <customer_name>Edward Scissorfoot</customer_name>
    <customer_email>Edward.Scissorfoot@example.customer.com</customer_email>
  </customer>
</create_customer>    
';

p_xml_doc := xmltype(l_xml);

  events_xml_api.create_customer(p_xml_doc => p_xml_doc);

dbms_output.put_line(p_xml_doc.getclobval());

end;

/*
<create_customer>
  <customer>
    <customer_name>Edward Scissorfoot</customer_name>
    <customer_email>Edward.Scissorfoot@example.customer.com</customer_email>
    <customer_id>2761</customer_id>
    <status_code>SUCCESS</status_code>
    <status_message>Created customer</status_message>
  </customer>
</create_customer>
*/
