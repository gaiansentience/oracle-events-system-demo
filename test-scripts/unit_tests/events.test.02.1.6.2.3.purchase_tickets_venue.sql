--purchase tickets directly from the venue
--use show_all_event_tickets_available to see purchases (test.05.00.01)
--or use show_venue_tickets_available to see purchases (test.05.00.03)
--customer needs to be created before placing order
--possible errors
--   if customer does not exist
--   if tickets requested are greater than available venue tickets in price category
--   error message will show if tickets available from resellers
--   error when requested tickets are more than venue has and resellers have tickets
--   ORA-20100: Cannot purchase 3333 BACKSTAGE tickets from venue.  303 tickets are available directly from venue.  1502 tickets are available through resellers.
--   error when requested tickets are more than venue has and resellers have no available tickets
--   ORA-20100: Cannot purchase 15 VIP tickets from venue.  4 tickets are available directly from venue.  All resellers are SOLD OUT.
--   error when venue direct sales are sold out and resellers have tickets
--   ORA-20100: Cannot purchase 21 GENERAL ADMISSION tickets from venue.  No tickets are available directly from venue.  5153 tickets are available through resellers.
--   error when no tickets are available from venue direct or resellers (no resellers were assigned any tickets in group)
--   ORA-20100: Cannot purchase 4 VIP tickets from venue.  All VIP tickets are SOLD OUT.
--   error when no tickets are available from venue direct and resellers are sold out
--   ORA-20100: Cannot purchase 33 BACKSTAGE tickets from venue.  All BACKSTAGE tickets are SOLD OUT.
set serveroutput on;

declare
    type r_purchase is record(
        email varchar2(100),
        customer_id number,
        price_category varchar2(50),
        ticket_group_id number,
        quantity number,
        price number,
        actual_price number,
        extended_price number,
        ticket_sales_id number);
    type t_purchase is table of r_purchase index by pls_integer;
    l_purchases t_purchase;
    l_event_id number;
begin

select event_id into l_event_id from events where event_name = 'The New Toys';

l_purchases(1).email := 'James.Kirk@example.customer.com';
l_purchases(1).price_category := 'GENERAL ADMISSION';
l_purchases(1).quantity := 44;
l_purchases(2).email := 'Keanu.Janeway@example.customer.com';
l_purchases(2).price_category := 'BACKSTAGE';
l_purchases(2).quantity := 49;
l_purchases(3).email := 'Harry.Potter@example.customer.com';
l_purchases(3).price_category := 'VIP';
l_purchases(3).quantity := 101;

for i in 1..l_purchases.count loop

    select customer_id 
    into l_purchases(i).customer_id 
    from customers where customer_email = l_purchases(i).email;

    select e.ticket_group_id, e.price 
    into l_purchases(i).ticket_group_id, l_purchases(i).price 
    from event_ticket_prices_v e
    where e.event_id = l_event_id and e.price_category = l_purchases(i).price_category;

end loop;

for i in 1..l_purchases.count loop
    begin
    
        events_api.purchase_tickets_venue(
            p_ticket_group_id => l_purchases(i).ticket_group_id,
            p_customer_id => l_purchases(i).customer_id,
            p_number_tickets => l_purchases(i).quantity,
            p_requested_price => l_purchases(i).price,
            p_actual_price => l_purchases(i).actual_price,
            p_extended_price => l_purchases(i).extended_price,
            p_ticket_sales_id => l_purchases(i).ticket_sales_id);
   
        dbms_output.put_line(l_purchases(i).quantity || ' ' || l_purchases(i).price_category || ' tickets purchased, extended price = ' || l_purchases(i).extended_price || ', sale id = ' || l_purchases(i).ticket_sales_id); 

    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
end loop;

end;
