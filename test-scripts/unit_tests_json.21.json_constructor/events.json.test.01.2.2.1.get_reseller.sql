--get reseller information as a json document
set serveroutput on;
declare
    l_json json;
    l_reseller_id number;
begin

    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => 'Ticket Factory');
    
    l_json := events_json_api.get_reseller(p_reseller_id => l_reseller_id, p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/*
{
  "reseller_id" : 81,
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "sales@TicketFactory.com",
  "commission_percent" : 0.125
}
*/