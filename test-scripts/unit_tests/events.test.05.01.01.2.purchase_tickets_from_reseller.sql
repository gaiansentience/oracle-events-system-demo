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
  v_backstage_tickets number := 12;  
  v_general_tickets number := 18000;

  v_customer1 number;
  v_customer2 number;
  v_reseller number;
  v_backstage_pass_group number;
  v_general_admission_group number;
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

select reseller_id into v_reseller from resellers where reseller_name = 'Tickets R Us';

select customer_id into v_customer1 from customers where customer_email = 'Jane.Wells@example.customer.com';
select customer_id into v_customer2 from customers where customer_email = 'Jules.Miller@example.customer.com';

v_general_admission_group := get_ticket_group('GENERAL ADMISSION');
v_backstage_pass_group := get_ticket_group('BACKSTAGE');

events_api.purchase_tickets_from_reseller(
   p_reseller_id => v_reseller,
   p_ticket_group_id => v_backstage_pass_group,
   p_customer_id => v_customer1,
   p_number_tickets => v_backstage_tickets,
   p_ticket_sales_id => v_sales_id);
   dbms_output.put_line(v_backstage_tickets || ' backstage tickets purchased, sale id = ' || v_sales_id); 
   

events_api.purchase_tickets_from_reseller(
   p_reseller_id => v_reseller,
   p_ticket_group_id => v_general_admission_group,
   p_customer_id => v_customer2,
   p_number_tickets => v_general_tickets,
   p_ticket_sales_id => v_sales_id);
   dbms_output.put_line(v_general_tickets || ' general admission tickets purchased, sale id = ' || v_sales_id); 


end;
