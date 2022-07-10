set serveroutput on;
declare
    l_json_doc varchar2(4000);
begin

l_json_doc := 
'
{
    "action" : "ticket-verify-restricted-access",
    "ticket_group_id" : 456,
    "price_category" : "VIP",
    "serial_code" : "abc"
}        
';

    events_json_api.ticket_verify_restricted_access(p_json_doc => l_json_doc);
   
    dbms_output.put_line(events_json_api.format_json_string(l_json_doc));

 end;


/*

*/
