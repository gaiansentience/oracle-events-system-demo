--change ticket groups for the event
--use show_ticket_groups to see groups that are created (test.03.00)
--total of all ticket groups created cannot exceed event size
--group size cannot be smaller than sum of current assignments to resellers and direct venue sales
--run this test after selling tickets in test.05.01.03 so the group cannot be redefined with smaller values, 
--if more than 100 tickets were sold in this group the group cannot be redefined with only 100 tickets
--error is 'Cannot set [price category] to XXXX tickets.  Current reseller assignments and direct venue sales are YYYY'
set serveroutput on;

declare
  v_event_id number;
  v_early varchar2(50) := 'EARLY PURCHASE DISCOUNT';
  v_early_price number := 33;
  v_early_tickets number := 100;
  v_group_id number;
begin

select event_id into v_event_id from events where event_name = 'The New Toys';

  
  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_early,
     p_price => v_early_price,
     p_tickets => v_early_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('early purchase discount group created with id = ' || v_group_id);



end;