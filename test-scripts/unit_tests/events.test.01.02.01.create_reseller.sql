--add a new reseller to the system
--reseller name and email must be unique
--error is returned when attempting to add a reseller with a duplicate name or email
--add the reseller again with the same name or email to see the error messages
--ORA-00001: unique constraint (TOPTAL.RESELLERS_U_RESELLER_EMAIL) violated
--ORA-00001: unique constraint (TOPTAL.RESELLERS_U_RESELLER_NAME) violated
set serveroutput on;

declare
  v_name varchar2(100) := 'New Ticket Source';
  v_email varchar2(100) := 'ticket.sales@NewTicketSource.com';
  v_commission number := 0.11;
  v_reseller_id number;
begin

  events_api.create_reseller(
       p_reseller_name => v_name,
       p_reseller_email => v_email,
       p_commission_percent => v_commission,
       p_reseller_id => v_reseller_id);
    
   dbms_output.put_line('reseller created with id = ' || v_reseller_id);

end;
