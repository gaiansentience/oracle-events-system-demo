--get reseller information as a json document
set serveroutput on;
declare
    l_json_doc varchar2(4000);
    l_reseller_id number;
begin

    l_reseller_id := events_api.get_reseller_id(p_reseller_name => 'Events For You');
    
    l_json_doc := events_json_api.get_reseller(p_reseller_id => l_reseller_id, p_formatted => true);
   
    dbms_output.put_line(l_json_doc);

 end;

/*
{
  "reseller_id" : 1,
  "reseller_name" : "Events For You",
  "reseller_email" : "ticket.sales@EventsForYou.com",
  "commission_percent" : 0.1198
}

*/