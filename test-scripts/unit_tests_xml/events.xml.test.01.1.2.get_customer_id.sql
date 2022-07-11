set serveroutput on;
declare
    l_xml_doc xmltype;
    l_customer_email customers.customer_email%type := 'Edward.Scissorfoot@example.customer.com';
begin

    l_xml_doc := events_xml_api.get_customer_id(p_customer_email => l_customer_email, p_formatted => true);
    dbms_output.put_line(l_xml_doc.getclobval());

end;

/*
<customer>
  <customer_id>4961</customer_id>
  <customer_name>Edward Scissorfoot</customer_name>
  <customer_email>Edward.Scissorfoot@example.customer.com</customer_email>
</customer>
*/
