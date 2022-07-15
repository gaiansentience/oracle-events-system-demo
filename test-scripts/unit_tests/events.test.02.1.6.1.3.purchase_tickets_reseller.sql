--purchase tickets from a reseller
--use show_all_event_tickets_available to see purchases (test.05.00.01)
--or use show_reseller_tickets_available to see purchases (test.05.00.02)
--error when requested quantity exceeds current availability for this reseller and ticket group
--OPEN ISSUE: SHOULD THIS ERROR REPORT AVAILABILITY FOR VENUE DIRECT AND OTHER RESELLERS?
--ORA-20100: Cannot purchase 11000 BACKSTAGE tickets from reseller.  1 tickets are available from reseller.  138 tickets are available directly from venue.  1501 tickets are available through other resellers.
--error when reseller is sold out of ticket group
--ORA-20100: Cannot purchase 12 BACKSTAGE tickets from reseller.  No tickets are available from reseller.  138 tickets are available directly from venue.  1501 tickets are available through other resellers.
--error when quantity is more than reseller available and other resellers are sold out
--ORA-20100: Cannot purchase 310 BACKSTAGE tickets from reseller.  301 tickets are available from reseller.  138 tickets are available directly from venue.  No tickets are available through other resellers.
--error when reseller is sold out and all other resellers are sold out but venue still has tickets
--ORA-20100: Cannot purchase 15 BACKSTAGE tickets from reseller.  No tickets are available from reseller.  138 tickets are available directly from venue.  No tickets are available through other resellers.
--error when ticket group is sold out (no tickets available from venue or reseller or other resellers
--ORA-20100: Cannot purchase 15 BACKSTAGE tickets from reseller.  No tickets are available from reseller.  BACKSTAGE tickets are SOLD OUT.
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
    l_event_id number;
    l_venue_id number;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => 'The New Toys');
    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => 'Old School');

l_purchases(1).email := 'Jane.Wells@example.customer.com';
l_purchases(1).price_category := 'GENERAL ADMISSION';
l_purchases(1).quantity := 33;
l_purchases(2).email := 'Jules.Miller@example.customer.com';
l_purchases(2).price_category := 'BACKSTAGE';
l_purchases(2).quantity := 8;
l_purchases(3).email := 'Harry.Potter@example.customer.com';
l_purchases(3).price_category := 'VIP';
l_purchases(3).quantity := 11;

for i in 1..l_purchases.count loop

    l_purchases(i).customer_id := customer_api.get_customer_id(p_customer_email => l_purchases(i).email);

    select e.ticket_group_id, 3 as price 
    into l_purchases(i).ticket_group_id, l_purchases(i).price 
    from event_ticket_prices_v e
    where e.event_id = l_event_id and e.price_category = l_purchases(i).price_category;

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
