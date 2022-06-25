--create venue organizer table
create table 
venues(
  venue_id number generated always as identity
       constraint venues_nn_id not null
       constraint venues_pk primary key,
  venue_name varchar2(50) 
       constraint venues_nn_name not null
       constraint venues_u_name unique,
  organizer_name varchar2(50),
  organizer_email varchar2(50),
  max_event_capacity number 
       constraint venues_nn_capacity not null
       constraint venues_chk_capacity_gt_0 check (max_event_capacity > 0)
);

create index venues_idx01 on venues (venue_id, venue_name);