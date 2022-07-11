set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
begin

l_xml := 
'
<update_customer>
  <customer>
    <customer_id>4961</customer_id>
    <customer_name>Edward Scissorhand</customer_name>
    <customer_email>Edward.Scissorfoot@example.customer.com</customer_email>
  </customer>
</update_customer>    
';

    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_customer(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval());

end;

/*
<update_customer>
  <customer>
    <customer_id>4961</customer_id>
    <customer_name>Edward Scissorhand</customer_name>
    <customer_email>Edward.Scissorfoot@example.customer.com</customer_email>
    <status_code>SUCCESS</status_code>
    <status_message>Updated customer</status_message>
  </customer>
</update_customer>

*/
