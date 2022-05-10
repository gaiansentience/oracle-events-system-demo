--create a reseller
set serveroutput on;
declare
  v_name varchar2(100) := 'Future Event Tickets';
  v_email varchar2(100) := 'ticket.sales@ContemporaryEvents.com';
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
