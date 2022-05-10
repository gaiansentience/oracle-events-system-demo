--purchase tickets from resellers
set serveroutput on; 
declare
  v_customer1                  number;
  v_customer2                  number;
  v_customer3                  number;
  v_reseller_old_school        number;
  v_reseller_future            number;
  v_reseller_tickets_r_us      number;  
  v_backstage_group            number;
  v_backstage_tickets          number := 5;  
  v_general_group              number;
  v_general_tickets            number := 9;
  v_sales_id                   number;
  function get_reseller_id(p_name in varchar2) return number
  is
     v_id number;
  begin
     select r.reseller_id into v_id from resellers r where r.reseller_name = p_name;
     return v_id;
  end get_reseller_id;  
  function get_ticket_group_id(p_category in varchar2) return number
  is
     v_id number;
  begin
     select tg.ticket_group_id into v_id from events e join ticket_groups tg on e.event_id = tg.event_id
     where e.event_name = 'Blues and Jazz Show' and tg.price_category = p_category;
     return v_id;
  end get_ticket_group_id;  
  function get_customer_id(p_email in varchar2) return number
  is
     v_id number;
  begin
     select c.customer_id into v_id from customers c where c.customer_email = p_email;
     return v_id;
  end get_customer_id;
begin

  v_customer1 := get_customer_id('Jane.Wells@example.customer.com');
  v_customer2 := get_customer_id('Jules.Miller@example.customer.com');
  v_customer3 := get_customer_id('Reese.Richards@example.customer.com');
  
  v_general_group          := get_ticket_group_id('GENERAL ADMISSION');
  v_backstage_group        := get_ticket_group_id('BACKSTAGE');  
  
  v_reseller_old_school    := get_reseller_id('Old School');
  v_reseller_future        := get_reseller_id('Future Event Tickets');
  v_reseller_tickets_r_us  := get_reseller_id('Tickets R Us');

for i in 1..5 loop
  events_api.purchase_tickets_from_reseller(v_reseller_old_school, v_backstage_group, v_customer1, v_backstage_tickets + i, v_sales_id);
  events_api.purchase_tickets_from_reseller(v_reseller_old_school, v_general_group, v_customer2, v_general_tickets + i, v_sales_id);
  events_api.purchase_tickets_from_reseller(v_reseller_old_school, v_general_group, v_customer3, v_general_tickets + i, v_sales_id);
end loop;

for i in 1..3 loop
  events_api.purchase_tickets_from_reseller(v_reseller_future, v_backstage_group, v_customer1, v_backstage_tickets + i, v_sales_id);
  events_api.purchase_tickets_from_reseller(v_reseller_future, v_general_group, v_customer2, v_general_tickets + i, v_sales_id);
  events_api.purchase_tickets_from_reseller(v_reseller_future, v_general_group, v_customer3, v_general_tickets + i, v_sales_id);
end loop;

  events_api.purchase_tickets_from_reseller(v_reseller_tickets_r_us, v_backstage_group, v_customer1, v_backstage_tickets, v_sales_id);
  events_api.purchase_tickets_from_reseller(v_reseller_tickets_r_us, v_general_group, v_customer2, v_general_tickets, v_sales_id);
  events_api.purchase_tickets_from_reseller(v_reseller_tickets_r_us, v_general_group, v_customer3, v_general_tickets, v_sales_id);  

end;
