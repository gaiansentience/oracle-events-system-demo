--assign ticket groups to another reseller for an event
set serveroutput on;
declare
    l_reseller_id number;
    l_venue_id number;
    l_event_id number;
    type r_assign is record(price_category varchar2(50), ticket_group_id number, quantity number, assignment_id number);
    type t_assign is table of r_assign index by pls_integer;
    l_assign t_assign;
begin
    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => 'Tickets R Us');
    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'The New Toys');

    l_assign(1).price_category := 'GENERAL ADMISSION';
    l_assign(1).quantity := 1000;
    l_assign(2).price_category := 'BACKSTAGE';
    l_assign(2).quantity := 100;
    l_assign(3).price_category := 'VIP';
    l_assign(3).quantity := 100;
    
    
    for i in 1..l_assign.count loop
    
        select e.ticket_group_id into l_assign(i).ticket_group_id
        from event_ticket_prices_v e where e.event_id = l_event_id and e.price_category = l_assign(i).price_category;
    
      events_api.create_ticket_assignment(
               p_reseller_id => l_reseller_id,
               p_ticket_group_id => l_assign(i).ticket_group_id,
               p_number_tickets => l_assign(i).quantity,
               p_ticket_assignment_id => l_assign(i).assignment_id);
    
        dbms_output.put_line(l_assign(i).assignment_id || ' = id for ' || l_assign(i).price_category || ' tickets assigned to reseller');
    
    end loop;

end;