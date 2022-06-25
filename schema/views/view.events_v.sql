create or replace view events_v as
select
    e.venue_id
    ,e.venue_name
    ,e.organizer_name
    ,e.organizer_email
    ,e.event_id
    ,e.event_series_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_available
        - nvl(
            (
            select sum(ts.ticket_quantity)
            from 
                event_system.ticket_groups tg 
                join event_system.ticket_sales ts 
                    on tg.ticket_group_id = ts.ticket_group_id
            where tg.event_id = e.event_id
            )
        ,0) as tickets_remaining
from venue_event_base_v e;