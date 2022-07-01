--assign ticket groups to a reseller for an event
set serveroutput on;
declare
    l_reseller_id number;
    l_event_id number;
    type r_assign is record(price_category varchar2(50), ticket_group_id number, quantity number, assignment_id number);
    type t_assign is table of r_assign index by pls_integer;
    l_assign t_assign;
    
begin

select reseller_id into l_reseller_id from resellers where reseller_name = 'Old School';

select event_id into l_event_id from events where event_name = 'The New Toys';

l_assign(1).price_category := 'GENERAL ADMISSION';
l_assign(1).quantity := 1000;
l_assign(2).price_category := 'BACKSTAGE';
l_assign(2).quantity := 500;
l_assign(3).price_category := 'VIP';
l_assign(3).quantity := 100;


for i in 1..l_assign.count loop

    select e.ticket_group_id into l_assign(i).ticket_group_id
    from event_ticket_prices_v e where e.event_id = l_event_id and e.price_category = l_assign(i).price_category;

end loop;

for i in 1..l_assign.count loop  

  events_api.create_ticket_assignment(
           p_reseller_id => l_reseller_id,
           p_ticket_group_id => l_assign(i).ticket_group_id,
           p_number_tickets => l_assign(i).quantity,
           p_ticket_assignment_id => l_assign(i).assignment_id);

    dbms_output.put_line(l_assign(i).assignment_id || ' = id for ' || l_assign(i).price_category || ' tickets assigned to reseller');

end loop;

end;