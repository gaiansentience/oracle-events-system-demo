--create ticket groups for the event
--use show_ticket_groups to see groups that are created (test.03.00)
--total of all ticket groups created cannot exceed event size
set serveroutput on;

declare
  v_event_id number;
  v_VIP varchar2(50) := 'VIP';
  v_VIP_price number := 75;
  v_VIP_tickets number := 2000;
  v_BACKSTAGE varchar2(50) := 'BACKSTAGE';
  v_BACKSTAGE_price number := 100;
  v_BACKSTAGE_tickets number := 1000;
  v_GENERAL varchar2(50) := 'GENERAL ADMISSION';
  v_GENERAL_price number := 42;
  v_GENERAL_tickets number := 6000;
  v_early varchar2(50) := 'EARLY PURCHASE DISCOUNT';
  v_early_price number := 33;
  v_early_tickets number := 1500;
  v_group_id number;
begin

select event_id into v_event_id from events where event_name = 'The New Toys';

  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_vip,
     p_price => v_vip_price,
     p_tickets => v_vip_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('vip group created with id = ' || v_group_id);
  
  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_BACKSTAGE,
     p_price => v_BACKSTAGE_price,
     p_tickets => v_BACKSTAGE_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('backstage group created with id = ' || v_group_id);
  
  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_GENERAL,
     p_price => v_GENERAL_price,
     p_tickets => v_GENERAL_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('general admission group created with id = ' || v_group_id);
  
  events_api.create_ticket_group(
     p_event_id => v_event_id,
     p_price_category => v_early,
     p_price => v_early_price,
     p_tickets => v_early_tickets,
     p_ticket_group_id => v_group_id);
  dbms_output.put_line('early purchase discount group created with id = ' || v_group_id);



end;