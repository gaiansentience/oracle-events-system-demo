--create event using a json document
set serveroutput on;
declare
  v_json_doc clob;
begin

   v_json_doc := 
'
{
  "event_series_id" : 13,
  "event_name" : "Monster Truck Smashup",
  "tickets_available" : 10000
}
';

   events_json_api.update_event_series(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_clob(v_json_doc));

end;

/*  reply document for success

*/
