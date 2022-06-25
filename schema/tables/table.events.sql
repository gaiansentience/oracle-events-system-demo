--create table events
create table events(
    event_id number generated always as identity
        constraint events_nn_id not null
        constraint events_pk primary key,
    venue_id number 
        constraint events_nn_venue_id not null
        constraint events_fk_venues references venues(venue_id),
    event_name varchar2(100)
        constraint events_nn_event_name not null,
    event_date date
        constraint events_nn_event_date not null,
    tickets_available number 
        constraint events_nn_tickets not null,
    event_series_id number
);

create index events_idx_venue_id 
    on events (venue_id);

create index events_idx_date 
    on events (event_date);

create index events_idx01 
    on events(event_id, event_date, venue_id, tickets_available, event_name);
    
create index events_idx_series
    on events(event_series_id);
    
create sequence event_series_id_seq;