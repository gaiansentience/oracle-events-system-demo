--change ticket groups for the event
--use show_ticket_groups to see groups that are created (test.03.00)
--total of all ticket groups created cannot exceed event size
set serveroutput on;
declare
    v_event_id number;
    type r_group is record(
        group_id number,
        price_category ticket_groups.price_category%type,
        price number,
        tickets number);
    type t_groups is table of r_group index by pls_integer;
    v_groups t_groups;

  v_VIP varchar2(50) := 'VIP';
  v_VIP_price number := 75;
  v_VIP_tickets number := 1000;
  v_BACKSTAGE varchar2(50) := 'BACKSTAGE';
  v_BACKSTAGE_price number := 100;
  v_BACKSTAGE_tickets number := 1000;
  v_GENERAL varchar2(50) := 'GENERAL ADMISSION';
  v_GENERAL_price number := 42;
  v_GENERAL_tickets number := 10000;
  v_early varchar2(50) := 'EARLY PURCHASE DISCOUNT';
  v_early_price number := 33;
  v_early_tickets number := 3000;
begin

    v_groups(1) := r_group(0,'VIP',75,1000);
    v_groups(2) := r_group(0,'BACKSTAGE',150,1000);
    v_groups(3) := r_group(0,'GENERAL ADMISSION', 42, 10000);
    v_groups(4) := r_group(0,'EARLY PURCHASE DISCOUNT', 33, 3000);

    select min(event_id) 
    into v_event_id 
    from events 
    where event_name = 'The New Toys';

    for i in 1..v_groups.count loop
        events_api.create_ticket_group(
            p_event_id => v_event_id,
            p_price_category => v_groups(i).price_category,
            p_price => v_groups(i).price,
            p_tickets => v_groups(i).tickets,
            p_ticket_group_id => v_groups(i).group_id);
        dbms_output.put_line(v_groups(i).price_category || ' group created with id = ' || v_groups(i).group_id);
    end loop;


end;