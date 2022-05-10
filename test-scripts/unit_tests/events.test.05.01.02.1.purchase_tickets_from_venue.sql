--purchase tickets directly from the venue
--use show_all_event_tickets_available to see purchases (test.05.00.01)
--or use show_venue_tickets_available to see purchases (test.05.00.03)
--customer needs to be created before placing order
--possible errors
--   if customer does not exist
--   if tickets requested are greater than available venue tickets in price category
set serveroutput on;

declare
  v_customer1 number;
  v_customer2 number;
  v_backstage_pass_group number;
  v_backstage_tickets number := 33;  
  v_general_admission_group number;
  v_general_tickets number := 21;
  v_sales_id number;
begin

select customer_id into v_customer1 from customers where customer_email = 'James.Kirk@example.customer.com';
select customer_id into v_customer2 from customers where customer_email = 'Keanu.Janeway@example.customer.com';

select tg.ticket_group_id into v_general_admission_group from events e join ticket_groups tg on e.event_id = tg.event_id
where e.event_name = 'The New Toys' and tg.price_category = 'GENERAL ADMISSION';

select tg.ticket_group_id into v_backstage_pass_group from events e join ticket_groups tg on e.event_id = tg.event_id
where e.event_name = 'The New Toys' and tg.price_category = 'BACKSTAGE';


events_api.purchase_tickets_from_venue(
   p_ticket_group_id => v_backstage_pass_group,
   p_customer_id => v_customer1,
   p_number_tickets => v_backstage_tickets,
   p_ticket_sales_id => v_sales_id);
   
   dbms_output.put_line('backstage tickets purchased, sale id = ' || v_sales_id); 
   

events_api.purchase_tickets_from_venue(
   p_ticket_group_id => v_general_admission_group,
   p_customer_id => v_customer2,
   p_number_tickets => v_general_tickets,
   p_ticket_sales_id => v_sales_id);
   
   dbms_output.put_line('backstage tickets purchased, sale id = ' || v_sales_id); 


end;
