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
    l_event_id number;
    type r_group is record(
        group_id number,
        price_category ticket_groups.price_category%type,
        price number,
        tickets number);
    type t_groups is table of r_group index by pls_integer;
    l_groups t_groups;
begin
    select event_id into l_event_id from events where event_name = 'The New Toys';

    l_groups(1) := r_group(0,'BACKSTAGE',150,1000);
    l_groups(2) := r_group(0,'GENERAL ADMISSION', 42, 10000);


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