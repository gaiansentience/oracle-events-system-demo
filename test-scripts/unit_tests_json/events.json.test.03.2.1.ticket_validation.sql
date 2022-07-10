set serveroutput on;
declare
    l_json_doc varchar2(4000);
begin

l_json_doc := 
'
{
    "action" : "ticket-validate",
    "event_id" : 123,
    "serial_code" : "abc"
}    
';

    events_json_api.ticket_validate(p_json_doc => l_json_doc);
   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

end;

/*

*/
