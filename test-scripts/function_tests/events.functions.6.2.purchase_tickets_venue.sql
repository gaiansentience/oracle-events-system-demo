--purchase tickets directly from the venue
set serveroutput on;
declare
  v_customer1 number;
  v_customer2 number;
  v_customer3 number;
  v_backstage_group number;
  v_backstage_tickets number := 33;  
  v_general_group number;
  v_general_tickets number := 21;
  v_vip_group number;
  v_vip_tickets number := 21;  
  v_sales_id number;
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

  v_customer1 := get_customer_id('James.Kirk@example.customer.com');
  v_customer2 := get_customer_id('Keanu.Janeway@example.customer.com');
  v_customer3 := get_customer_id('Tilly.Rodriguez@example.customer.com');
  
  v_general_group          := get_ticket_group_id('GENERAL ADMISSION');
  v_vip_group              := get_ticket_group_id('VIP');  
  v_backstage_group        := get_ticket_group_id('BACKSTAGE');  
  

  events_api.purchase_tickets_from_venue(v_backstage_group, v_customer1, v_backstage_tickets, v_sales_id);
  events_api.purchase_tickets_from_venue(v_vip_group, v_customer1, v_vip_tickets, v_sales_id);
  events_api.purchase_tickets_from_venue(v_general_group, v_customer1, v_general_tickets, v_sales_id);
   
  events_api.purchase_tickets_from_venue(v_backstage_group, v_customer2, v_backstage_tickets, v_sales_id);
  events_api.purchase_tickets_from_venue(v_vip_group, v_customer2, v_vip_tickets, v_sales_id);
  events_api.purchase_tickets_from_venue(v_general_group, v_customer2, v_general_tickets, v_sales_id);

  events_api.purchase_tickets_from_venue(v_backstage_group, v_customer3, v_backstage_tickets, v_sales_id);
  events_api.purchase_tickets_from_venue(v_vip_group, v_customer3, v_vip_tickets, v_sales_id);
  events_api.purchase_tickets_from_venue(v_general_group, v_customer3, v_general_tickets, v_sales_id);

end;
