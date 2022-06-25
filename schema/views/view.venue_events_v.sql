create or replace view venue_events_v as
select
    e.venue_id
    ,e.venue_name
    ,e.organizer_name
    ,e.organizer_email
    ,e.max_event_capacity
    ,nvl(
        (
        select count(*) 
        from event_system.events es 
        where 
            es.venue_id = e.venue_id 
            and es.event_date > trunc(sysdate)
        )
    ,0) as venue_scheduled_events
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_available 
        - nvl(
            (
            select sum(ts.ticket_quantity) 
            from 
                event_system.ticket_sales ts 
                join event_system.ticket_groups tg 
                    on ts.ticket_group_id = tg.ticket_group_id
            where tg.event_id = e.event_id
            )
        ,0) as tickets_remaining
from event_system.venue_event_base_v e;
