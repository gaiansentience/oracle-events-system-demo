create or replace view tickets_available_series_all_v as
select
    a.venue_id
    ,min(a.venue_name) as venue_name
    ,a.event_series_id
    ,min(a.event_name) as event_name
    ,min(a.event_date) as first_event_date
    ,max(a.event_date) as last_event_date
    ,count(distinct event_id) as events_in_series
    --,min(a.event_tickets_available) as event_tickets_available
    ,a.price_category
    ,max(a.price) as price
    --,a.group_tickets_available
    --,a.group_tickets_sold
    --,a.group_tickets_remaining
    ,a.reseller_id
    ,min(a.reseller_name) as reseller_name
    ,sum(a.tickets_available) as tickets_available
    ,sum(case when a.tickets_available = 0 then 0 else 1 end) as events_available
    ,sum(case when a.tickets_available = 0 then 1 else 0 end) as events_sold_out
   -- ,a.ticket_status
from
    event_system.tickets_available_all_v a
where
    a.event_series_id is not null
group by
    a.venue_id
    ,a.event_series_id
    ,a.price_category
    ,a.reseller_id;