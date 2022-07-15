--update reseller information:  name, email and commission
--use show_reseller to get information before updating
set serveroutput on;

declare
    l_reseller resellers%rowtype;
begin

    l_reseller.reseller_name := 'Easy Tickets';
    l_reseller.reseller_email := 'tickets@EasyTickets.com';
    l_reseller.commission_percent := 0.0909;
        
    l_reseller.reseller_id := reseller_api.get_reseller_id(p_reseller_name => l_reseller.reseller_name);
    
    begin
    
        reseller_api.update_reseller(
        p_reseller_id => l_reseller.reseller_id,
        p_reseller_name => l_reseller.reseller_name,
        p_reseller_email => l_reseller.reseller_email,
        p_commission_percent => l_reseller.commission_percent);
    
        dbms_output.put_line('reseller updated');
    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
end;

/*
reseller updated

*/