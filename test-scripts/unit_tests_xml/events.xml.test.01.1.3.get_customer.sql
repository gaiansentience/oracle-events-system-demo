set serveroutput on;
declare
    l_xml_doc xmltype;
    l_customer_id number;
    l_customer_email customers.customer_email%type := 'Bilbo.Baggins@example.customer.com';
begin

    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    l_xml_doc := events_xml_api.get_customer(p_customer_id => l_customer_id, p_formatted => true);
    dbms_output.put_line(l_xml_doc.getclobval());

end;

/*
<customer>
  <customer_id>5042</customer_id>
  <customer_name>Frodo Underhill</customer_name>
  <customer_email>Bilbo.Baggins@example.customer.com</customer_email>
</customer>

*/
