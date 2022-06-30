create or replace view tickets_available_all_v as
select
    r.venue_id
    ,r.venue_name
    ,r.event_id
    ,r.event_series_id
    ,r.event_name
    ,r.event_date
    ,r.event_tickets_available
    ,r.price_category
    ,r.ticket_group_id
    ,r.price
    ,r.group_tickets_available
    ,r.group_tickets_sold
    ,r.group_tickets_remaining
    ,r.reseller_id
    ,r.reseller_name
    ,r.tickets_available
    ,r.ticket_status
from tickets_available_reseller_v r
union all
select
    v.venue_id
    ,v.venue_name
    ,v.event_id
    ,v.event_series_id
    ,v.event_name
    ,v.event_date
    ,v.event_tickets_available
    ,v.price_category
    ,v.ticket_group_id
    ,v.price
    ,v.group_tickets_available
    ,v.group_tickets_sold
    ,v.group_tickets_remaining
    ,v.reseller_id
    ,v.reseller_name
    ,v.tickets_available
    ,v.ticket_status
from tickets_available_venue_v v;