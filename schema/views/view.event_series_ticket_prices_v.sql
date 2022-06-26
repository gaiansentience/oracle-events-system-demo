create or replace view event_series_ticket_prices_v as
select
    p.venue_id
    ,min(p.venue_name) as venue_name
    ,p.event_series_id
    ,min(p.event_name) as event_name
    ,count(distinct p.event_id) as events_in_series
    ,min(p.event_date) as first_event_date
    ,max(p.event_date) as last_event_date
    ,min(p.event_tickets_available) as event_tickets_available
    ,p.price_category
    ,max(p.price) as price
    ,sum(p.tickets_available) as tickets_available_all_events
    ,sum(p.tickets_sold) as tickets_sold_all_events
    ,sum(p.tickets_remaining) as tickets_remaining_all_events
from event_ticket_prices_v p
where
    p.event_series_id is not null
group by
    p.venue_id
    ,p.event_series_id
    ,p.price_category;