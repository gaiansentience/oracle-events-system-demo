--get reseller information as a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
  v_reseller_id number := 1;
begin

   v_json_doc := events_json_api.get_reseller(p_reseller_id => v_reseller_id, p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*

{
  "reseller_id" : 1,
  "reseller_name" : "Events For You",
  "reseller_email" : "ticket.sales@EventsForYou.com"
}

*/