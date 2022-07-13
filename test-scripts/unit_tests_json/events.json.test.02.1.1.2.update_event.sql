--create event using a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc := 
'
{
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400
}
';

   events_json_api.update_event(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success


*/