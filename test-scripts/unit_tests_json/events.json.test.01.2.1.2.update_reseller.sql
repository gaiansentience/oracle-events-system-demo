--create reseller using a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc :=
'
{
  "reseller_id" : 41,
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "sales@TicketFactory.com",
  "commission_percent" : 0.125
}
';

   events_json_api.update_reseller(p_json_doc => v_json_doc);
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success
{
  "reseller_id" : 41,
  "reseller_name" : "Ticket Factory Outlet",
  "reseller_email" : "sales@TicketFactory.com",
  "commission_percent" : 0.125,
  "status_code" : "SUCCESS",
  "status_message" : "Updated reseller"
}
*/