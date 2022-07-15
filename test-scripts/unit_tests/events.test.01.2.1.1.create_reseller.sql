--add a new reseller to the system
--reseller name and email must be unique
--error is returned when attempting to add a reseller with a duplicate name or email
--add the reseller again with the same name or email to see the error messages
--ORA-00001: unique constraint (RESELLERS_U_RESELLER_EMAIL) violated
--ORA-00001: unique constraint (RESELLERS_U_RESELLER_NAME) violated
set serveroutput on;
declare
    l_reseller resellers%rowtype;
begin

    l_reseller.reseller_name := 'Easy Tickets';
    l_reseller.reseller_email := 'ticket.sales@EasyTickets.com';
    l_reseller.commission_percent := 0.11;

    begin
    
        reseller_api.create_reseller(
        p_reseller_name => l_reseller.reseller_name,
        p_reseller_email => l_reseller.reseller_email,
        p_commission_percent => l_reseller.commission_percent,
        p_reseller_id => l_reseller.reseller_id);
    
        dbms_output.put_line('reseller created with id = ' || l_reseller.reseller_id);
    
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    
end;

/*
reseller created with id = 73
*/
