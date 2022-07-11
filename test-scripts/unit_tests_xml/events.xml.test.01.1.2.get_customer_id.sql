set serveroutput on;
declare
    l_xml varchar2(4000);
    p_xml_doc xmltype;
begin

l_xml := 
'
<get_customer_id>
  <customer>
    <customer_name>Edward Scissorfoot</customer_name>
    <customer_email>Edward.Scissorfoot@example.customer.com</customer_email>
  </customer>
</get_customer_id>    
';

p_xml_doc := xmltype(l_xml);

--not implemented
  events_xml_api.get_customer_id(p_xml_doc => p_xml_doc);

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
