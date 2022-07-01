--change assigned tickets to a reseller
--assign more tickets than are available for the group after assignments to other resellers and venue direct sales
--causes error 'Cannot assign XXXX to reseller, maximum available are YYYY'
--maximum available value is max_available from show_reseller_ticket_group_availability (test.04.00)
set serveroutput on;
declare
  v_old_school_id     number;
  v_general_admission_group    number;
  v_general_admission_tickets  number := 20000;  
  v_backstage_pass_group       number;
  v_backstage_pass_tickets     number := 5000;  
  v_assignment_id number;
begin

  select reseller_id into v_old_school_id from resellers where reseller_name = 'Old School';
  
select tg.ticket_group_id into v_general_admission_group from events e join ticket_groups tg on e.event_id = tg.event_id
where e.event_name = 'The New Toys' and tg.price_category = 'GENERAL ADMISSION';

select tg.ticket_group_id into v_backstage_pass_group from events e join ticket_groups tg on e.event_id = tg.event_id
where e.event_name = 'The New Toys' and tg.price_category = 'BACKSTAGE';
  

  events_api.create_ticket_assignment(
           p_reseller_id => v_old_school_id,
           p_ticket_group_id => v_general_admission_group,
           p_number_tickets => v_general_admission_tickets,
           p_ticket_assignment_id => v_assignment_id);

  dbms_output.put_line(v_assignment_id || ' = id for general admission tickets assigned to old school');

  events_api.create_ticket_assignment(
           p_reseller_id => v_old_school_id,
           p_ticket_group_id => v_backstage_pass_group,
           p_number_tickets => v_backstage_pass_tickets,
           p_ticket_assignment_id => v_assignment_id);

  dbms_output.put_line(v_assignment_id || ' = id for general admission tickets assigned to old school');



end;