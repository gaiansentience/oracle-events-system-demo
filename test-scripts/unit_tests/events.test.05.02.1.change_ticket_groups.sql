--change ticket groups for the event
--use show_ticket_groups to see groups that are created (test.03.00)
--total of all ticket groups created cannot exceed event size
--group size cannot be smaller than sum of current assignments to resellers and direct venue sales
--run this test after assigning tickets to resellers in test.04.01 to see error because of assignments
--run this test after customers purchase tickets in test.05.01 to see error because of venue direct sales
--error is 'Cannot set [price category] to XXXX tickets.  Current reseller assignments and direct venue sales are YYYY'
set serveroutput on;

declare
  v_event_id number;
  v_BACKSTAGE varchar2(50) := 'BACKSTAGE';
  v_BACKSTAGE_price number := 100;
  v_BACKSTAGE_tickets number := 100;
  v_group_id number;
begin

select event_id into v_event_id from events where event_name = 'The New Toys';

  
  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_BACKSTAGE,
     p_price => v_BACKSTAGE_price,
     p_tickets => v_BACKSTAGE_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('backstage group created with id = ' || v_group_id);
  

end;