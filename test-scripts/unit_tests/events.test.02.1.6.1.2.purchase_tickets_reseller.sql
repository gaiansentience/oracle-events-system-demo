--purchase tickets from a reseller
--use show_all_event_tickets_available to see purchases (test.05.00.01)
--or use show_reseller_tickets_available to see purchases (test.05.00.02)
--error when requested quantity exceeds current availability for this reseller and ticket group
--OPEN ISSUE: SHOULD THIS ERROR REPORT AVAILABILITY FOR VENUE DIRECT AND OTHER RESELLERS?
--ORA-20100: Cannot purchase 11000 BACKSTAGE tickets from reseller.  1 tickets are available from reseller.  138 tickets are available directly from venue.  1501 tickets are available through other resellers.
--error when reseller is sold out of ticket group
--ORA-20100: Cannot purchase 12 BACKSTAGE tickets from reseller.  No tickets are available from reseller.  138 tickets are available directly from venue.  1501 tickets are available through other resellers.
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
    l_reseller_id number;
begin

select reseller_id into l_reseller_id from resellers where reseller_name = 'Tickets R Us';

l_purchases(1).email := 'Jane.Wells@example.customer.com';
l_purchases(1).price_category := 'GENERAL ADMISSION';
l_purchases(1).quantity := 33000;
l_purchases(2).email := 'Jules.Miller@example.customer.com';
l_purchases(2).price_category := 'BACKSTAGE';
l_purchases(2).quantity := 8;
l_purchases(3).email := 'Harry.Potter@example.customer.com';
l_purchases(3).price_category := 'VIP';
l_purchases(3).quantity := 11;

for i in 1..l_purchases.count loop

    select customer_id 
    into l_purchases(i).customer_id 
    from customers where customer_email = l_purchases(i).email;

    select tg.ticket_group_id, tg.price 
    into l_purchases(i).ticket_group_id, l_purchases(i).price 
    from events e join ticket_groups tg on e.event_id = tg.event_id
    where e.event_name = 'The New Toys' and tg.price_category = l_purchases(i).price_category;
end loop;

for i in 1..l_purchases.count loop
    begin
    
        events_api.purchase_tickets_reseller(
            p_reseller_id => l_reseller_id,
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
