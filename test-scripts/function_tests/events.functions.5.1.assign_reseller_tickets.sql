--assign ticket groups to resellers for event
set serveroutput on;
declare
  v_reseller_old_school        number;
  v_reseller_future            number;
  v_reseller_tickets_r_us      number;
  v_general_group              number;
  v_vip_tickets                number := 100;  
  v_vip_group                  number;
  v_general_tickets            number := 100;    
  v_backstage_group            number;
  v_backstage_tickets          number := 100;  
  v_assignment_id number;
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
  
begin
  v_reseller_old_school    := get_reseller_id('Old School');
  v_reseller_future        := get_reseller_id('Future Event Tickets');
  v_reseller_tickets_r_us  := get_reseller_id('Tickets R Us');
  
  v_general_group          := get_ticket_group_id('GENERAL ADMISSION');
  v_backstage_group        := get_ticket_group_id('BACKSTAGE');
  v_vip_group              := get_ticket_group_id('VIP');
  
  events_api.assign_reseller_ticket_group(v_reseller_old_school, v_general_group, v_general_tickets, v_assignment_id);
  events_api.assign_reseller_ticket_group(v_reseller_old_school, v_backstage_group, v_backstage_tickets, v_assignment_id);
  events_api.assign_reseller_ticket_group(v_reseller_old_school, v_vip_group, v_vip_tickets, v_assignment_id);
  dbms_output.put_line('Tickets assigned to reseller:  Old School');

  events_api.assign_reseller_ticket_group(v_reseller_future, v_general_group, v_general_tickets, v_assignment_id);
  events_api.assign_reseller_ticket_group(v_reseller_future, v_backstage_group, v_backstage_tickets, v_assignment_id);
  events_api.assign_reseller_ticket_group(v_reseller_future, v_vip_group, v_vip_tickets, v_assignment_id);
  dbms_output.put_line('Tickets assigned to reseller:  Future Event Tickets');
  
  events_api.assign_reseller_ticket_group(v_reseller_tickets_r_us, v_general_group, v_general_tickets, v_assignment_id);
  events_api.assign_reseller_ticket_group(v_reseller_tickets_r_us, v_backstage_group, v_backstage_tickets, v_assignment_id);
  events_api.assign_reseller_ticket_group(v_reseller_tickets_r_us, v_vip_group, v_vip_tickets, v_assignment_id);
  dbms_output.put_line('Tickets assigned to reseller:  Tickets R Us');
  
end;