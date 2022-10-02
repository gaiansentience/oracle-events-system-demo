--create reseller using a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_name resellers.reseller_name%type := 'Ticket Factory';
    l_email resellers.reseller_email%type := 'sales@TicketFactory.com';
    l_commission resellers.commission_percent%type := 0.125;
    l_reseller_id number;
begin

    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => l_name);

l_json_doc :=
'
{
  "reseller_id" : $$RESELLER$$,
  "reseller_name" : "$$NAME$$",
  "reseller_email" : "$$EMAIL$$",
  "commission_percent" : $$COMMISSION$$
}
';

    l_json_doc := replace(l_json_doc,'$$RESELLER$$',l_reseller_id);
    l_json_doc := replace(l_json_doc,'$$NAME$$',l_name);
    l_json_doc := replace(l_json_doc,'$$EMAIL$$',l_email);
    l_json_doc := replace(l_json_doc,'$$COMMISSION$$',l_commission);

    events_json_api.update_reseller(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json(l_json_doc));

 end;

/*
{
  "reseller_id" : 81,
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "sales@TicketFactory.com",
  "commission_percent" : 0.125,
  "status_code" : "SUCCESS",
  "status_message" : "Updated reseller"
}

*/