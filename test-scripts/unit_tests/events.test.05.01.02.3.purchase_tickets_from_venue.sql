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
  v_backstage_tickets number := 33;  
  v_vip_tickets number := 4;
  v_general_tickets number := 21;

  v_customer1 number;
  v_customer2 number;
  v_backstage_pass_group number;
  v_general_admission_group number;
  v_vip_group number;
  v_sales_id number;
  function get_ticket_group(p_price_category in varchar2) return number
  is
     v_group_id number;
  begin
     select tg.ticket_group_id into v_group_id from events e join ticket_groups tg on e.event_id = tg.event_id
     where e.event_name = 'The New Toys' and tg.price_category = p_price_category;
     return v_group_id;
  end get_ticket_group;   

begin

select customer_id into v_customer1 from customers where customer_email = 'James.Kirk@example.customer.com';
select customer_id into v_customer2 from customers where customer_email = 'Keanu.Janeway@example.customer.com';

v_general_admission_group := get_ticket_group('GENERAL ADMISSION');
v_backstage_pass_group := get_ticket_group('BACKSTAGE');
v_vip_group := get_ticket_group('VIP');

events_api.purchase_tickets_from_venue(
   p_ticket_group_id => v_backstage_pass_group,
   p_customer_id => v_customer1,
   p_number_tickets => v_backstage_tickets,
   p_ticket_sales_id => v_sales_id);
   dbms_output.put_line(v_backstage_tickets || ' backstage tickets purchased, sale id = ' || v_sales_id); 
   
events_api.purchase_tickets_from_venue(
   p_ticket_group_id => v_vip_group,
   p_customer_id => v_customer2,
   p_number_tickets => v_vip_tickets,
   p_ticket_sales_id => v_sales_id);
   dbms_output.put_line(v_vip_tickets || ' vip tickets purchased, sale id = ' || v_sales_id); 


events_api.purchase_tickets_from_venue(
   p_ticket_group_id => v_general_admission_group,
   p_customer_id => v_customer2,
   p_number_tickets => v_general_tickets,
   p_ticket_sales_id => v_sales_id);
   dbms_output.put_line(v_general_tickets || ' general admission tickets purchased, sale id = ' || v_sales_id); 



end;
