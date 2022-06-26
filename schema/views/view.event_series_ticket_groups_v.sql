create or replace view event_series_ticket_groups_v as
select
    etg.venue_id
    ,min(etg.venue_name) as venue_name
    ,etg.event_series_id
    ,min(etg.event_name) as event_name
    ,count(distinct etg.event_id) as events_in_series
    ,min(etg.event_date) as first_event_date
    ,max(etg.event_date) as last_event_date
    ,min(etg.event_tickets_available) as event_tickets_available
    ,etg.price_category
    ,max(etg.price) as price
    ,case 
        when etg.price_category = 'UNDEFINED' then min(etg.tickets_available) 
        else max(etg.tickets_available) 
    end as tickets_available
    ,max(etg.currently_assigned) as currently_assigned
    ,max(etg.sold_by_venue) as sold_by_venue
from 
    event_ticket_groups_v etg
where 
    etg.event_series_id is not null
group by
    etg.venue_id
    ,etg.event_series_id
    ,etg.price_category;