--change ticket groups for the event
--use show_ticket_groups to see groups that are created (test.05.02.0)
--total of all ticket groups created cannot exceed event size
--error is 'Cannot set [price category] to XXXX tickets.  Current reseller assignments and direct venue sales are YYYY'
--in this example general admission tickets were not completely assigned 
--so tickets can be moved from that group to the sold out backstage group
--prices can also be changed when modifying ticket groups
--any changed prices will be reflected in new ticket sales (and commissions)
set serveroutput on;

declare
  v_event_id number;
  v_general varchar2(50) := 'GENERAL ADMISSION';
  v_general_price number := 42;
  v_general_tickets number := 8000;
  v_backstage varchar2(50) := 'BACKSTAGE';
  v_backstage_price number := 100;
  v_backstage_tickets number := 3000;
  v_group_id number;
begin

select event_id into v_event_id from events where event_name = 'The New Toys';

  --decrease the general admission group from 10,000 to 8,000 tickets
  --also drop the current price by 4
  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_general,
     p_price => v_general_price - 4,
     p_tickets => v_general_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('general admission group changed with id = ' || v_group_id);

  --increase the backstage pass group from 1,000 to 3,000 using the tickets just moved above
  --also increase the backstage price by 11
  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_backstage,
     p_price => v_backstage_price + 11,
     p_tickets => v_backstage_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('general admission group changed with id = ' || v_group_id);


end;