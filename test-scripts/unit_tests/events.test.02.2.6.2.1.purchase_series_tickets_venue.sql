--purchase tickets directly from the venue
--use show_all_event_tickets_available to see purchases (test.05.00.01)
--or use show_venue_tickets_available to see purchases (test.05.00.03)
--customer needs to be created before placing order
--possible errors
--   if customer does not exist
--   if tickets requested are greater than available venue tickets in price category
set serveroutput on;

declare
    type r_purchase is record(
        email varchar2(100),
        customer_id number,
        price_category varchar2(50),
        quantity number,
        price number,
        average_price number,
        total_purchase number,
        total_tickets number,
        status_code varchar2(25),
        status_message varchar2(4000));

    type t_purchase is table of r_purchase index by pls_integer;

    l_purchases t_purchase;
    l_venue_id number;
    l_event_series_id number;    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Hometown Hockey League');

l_purchases(1).email := 'James.Kirk@example.customer.com';
l_purchases(1).price_category := 'GENERAL ADMISSION';
l_purchases(1).quantity := 3;
l_purchases(2).email := 'Keanu.Janeway@example.customer.com';
l_purchases(2).price_category := 'EARLY PURCHASE DISCOUNT';
l_purchases(2).quantity := 2;
l_purchases(3).email := 'Harry.Potter@example.customer.com';
l_purchases(3).price_category := 'VIP';
l_purchases(3).quantity := 5;


for i in 1..l_purchases.count loop

    l_purchases(i).customer_id := customer_api.get_customer_id(p_customer_email => l_purchases(i).email);

    select e.price 
    into l_purchases(i).price 
    from event_series_ticket_prices_v e
    where e.event_series_id = l_event_series_id and e.price_category = l_purchases(i).price_category;


    begin
    
        event_sales_api.purchase_tickets_venue_series(
            p_event_series_id => l_event_series_id,
            p_price_category => l_purchases(i).price_category,
            p_customer_id => l_purchases(i).customer_id,
            p_number_tickets => l_purchases(i).quantity,
            p_requested_price => l_purchases(i).price,
            p_average_price => l_purchases(i).average_price,
            p_total_purchase => l_purchases(i).total_purchase,
            p_total_tickets => l_purchases(i).total_tickets,
            p_status_code => l_purchases(i).status_code,
            p_status_message => l_purchases(i).status_message);
           
            dbms_output.put_line(l_purchases(i).total_tickets || ' ' || l_purchases(i).price_category || ' tickets purchased, total_purchase = ' || l_purchases(i).total_purchase 
                || ', average price = ' || l_purchases(i).average_price || ', status_message = ' || l_purchases(i).status_message); 
        
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
end loop;

end;
