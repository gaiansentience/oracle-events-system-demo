--change ticket groups for the event
--use show_ticket_groups to see groups that are created (test.03.00)
--total of all ticket groups created cannot exceed event size
--group size cannot be smaller than sum of current assignments to resellers and direct venue sales
--run this test after selling tickets in test.05.01.03 so the group cannot be redefined with smaller values, 
--if more than 100 tickets were sold in this group the group cannot be redefined with only 100 tickets
--error is 'Cannot set [price category] to XXXX tickets.  Current reseller assignments and direct venue sales are YYYY'
set serveroutput on;
declare
    l_event_id number;
    l_venue_id number;
    type r_group is record(
        group_id number,
        price_category ticket_groups.price_category%type,
        price number,
        tickets number);
    type t_groups is table of r_group index by pls_integer;
    l_groups t_groups;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'The New Toys');

    l_groups(1) := r_group(0,'VIP',75,1500);
    l_groups(2) := r_group(0,'BACKSTAGE',100,100);
    l_groups(3) := r_group(0,'GENERAL ADMISSION', 42, 8000);
    l_groups(4) := r_group(0,'EARLY PURCHASE DISCOUNT', 33, 10);

    for i in 1..l_groups.count loop
        begin
        
            events_api.create_ticket_group(
                p_event_id => l_event_id,
                p_price_category => l_groups(i).price_category,
                p_price => l_groups(i).price,
                p_tickets => l_groups(i).tickets,
                p_ticket_group_id => l_groups(i).group_id);
            dbms_output.put_line(l_groups(i).price_category || ' group created with id = ' || l_groups(i).group_id);
        
        exception
            when others then
                dbms_output.put_line(sqlerrm);
        end;
        
    end loop;

end;