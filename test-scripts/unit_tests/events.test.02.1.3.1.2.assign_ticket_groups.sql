--assign tickets to another reseller
--amounts are visible in assigned_to_others in show_reseller_ticket_availability(test.04.00) for the first reseller
--error when assigning more to reseller than are available based on other assignments and total amount in group
--ORA-20100: Cannot assign 30000 tickets for  GENERAL ADMISSION to reseller, maximum available are 3000
set serveroutput on;
declare
  v_tickets_r_us_id     number;
  v_general_admission_group    number;
  v_general_admission_tickets  number := 3000;  
  v_backstage_pass_group       number;
  v_backstage_pass_tickets     number := 100;  
  v_assignment_id number;
begin

  select reseller_id into v_tickets_r_us_id from resellers where reseller_name = 'Tickets R Us';
  
select tg.ticket_group_id into v_general_admission_group from events e join ticket_groups tg on e.event_id = tg.event_id
where e.event_name = 'The New Toys' and tg.price_category = 'GENERAL ADMISSION';

select tg.ticket_group_id into v_backstage_pass_group from events e join ticket_groups tg on e.event_id = tg.event_id
where e.event_name = 'The New Toys' and tg.price_category = 'BACKSTAGE';
  


  events_api.create_ticket_assignment(
           p_reseller_id => v_tickets_r_us_id,
           p_ticket_group_id => v_general_admission_group,
           p_number_tickets => v_general_admission_tickets,
           p_ticket_assignment_id => v_assignment_id);

  dbms_output.put_line(v_assignment_id || ' = id for general admission tickets assigned to tickets r us');

  events_api.create_ticket_assignment(
           p_reseller_id => v_tickets_r_us_id,
           p_ticket_group_id => v_backstage_pass_group,
           p_number_tickets => v_backstage_pass_tickets,
           p_ticket_assignment_id => v_assignment_id);

  dbms_output.put_line(v_assignment_id || ' = id for general admission tickets assigned to tickets r us');



end;