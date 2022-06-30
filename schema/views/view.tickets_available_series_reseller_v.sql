create or replace view tickets_available_series_reseller_v as
select
    a.venue_id
    ,a.venue_name
    ,a.event_series_id
    ,a.event_name
    ,a.first_event_date
    ,a.last_event_date
    ,a.events_in_series
    ,a.price_category
    ,a.price
    ,a.reseller_id
    ,a.reseller_name
    ,a.tickets_available
    ,a.events_available
    ,a.events_sold_out
from
    tickets_available_series_all_v a
where
    a.reseller_id is not null;