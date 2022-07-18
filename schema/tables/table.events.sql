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

create index events_idx01 
    on events(venue_id, event_date, event_id);

create index events_idx02
    on events(venue_id, event_date, event_series_id, event_id);
    
create index events_idx03
    on events(event_series_id, event_id, event_date);
    
create sequence event_series_id_seq;