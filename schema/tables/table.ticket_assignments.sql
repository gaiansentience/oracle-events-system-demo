--create event ticket assignments table
create table 
ticket_assignments(
  ticket_assignment_id number generated always as identity
       constraint ticket_assignments_nn_id not null
       constraint ticket_assignments_pk primary key,
  ticket_group_id number 
       constraint ticket_assignments_nn_ticket_group_id not null 
       constraint ticket_assignments_fk_ticket_groups references ticket_groups(ticket_group_id),
  reseller_id number 
       constraint ticket_assignments_nn_reseller_id not null 
       constraint ticket_assignments_fk_resellers references resellers(reseller_id),
  tickets_assigned number 
       constraint ticket_assignments_nn_tickets_assigned not null
  );
  
create unique index ticket_assignments_udx on ticket_assignments (ticket_group_id, reseller_id);  

create index ticket_assignments_idx01 on ticket_assignments (ticket_group_id, reseller_id, tickets_assigned);  
