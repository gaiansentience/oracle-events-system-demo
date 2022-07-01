--create event ticket groups table
create table 
ticket_groups(
  ticket_group_id number generated always as identity 
       constraint ticket_groups_nn_id not null
       constraint ticket_groups_pk primary key,
  event_id number 
       constraint ticket_groups_nn_event_id not null 
       constraint ticket_groups_fk_events references events(event_id),
  price_category varchar2(50) 
       constraint ticket_groups_nn_price_category not null,
  price number(6,2) 
       constraint ticket_groups_nn_price not null,
  tickets_available number 
       constraint ticket_groups_nn_tickets_available not null
  );
  
create unique index ticket_groups_udx on ticket_groups (event_id, price_category);  

create index ticket_groups_idx01 on ticket_groups (event_id, ticket_group_id, price_category, price, tickets_available);  

create index ticket_groups_idx02 on ticket_groups (ticket_group_id, price);  
