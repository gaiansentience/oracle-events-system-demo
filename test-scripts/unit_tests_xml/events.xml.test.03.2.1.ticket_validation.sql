set serveroutput on;
declare
    l_xml varchar2(4000);
    l_xml_doc xmltype;
begin

l_xml :=
'
<ticket_validate>
    <event>
        <event_id>123</event_id>        
    </event>
    <ticket>
        <serial_code>xyz</serial_code>
    </ticket>
</ticket_validate>
';
l_xml_doc := xml_type(l_xml);
events_xml_api.ticket_validate(p_xml_doc => l_xml_doc);

dbms_output.put_line(l_xml_doc.getclobval);

end;

/*

*/
