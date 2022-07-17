drop materialized view customer_purchases_mv;
/

create materialized view customer_purchases_mv 
refresh fast on statement
enable query rewrite
as
select
    e.rowid as events_rowid
    ,e.venue_id
    ,e.event_series_id
    ,tg.event_id
    ,tg.rowid as ticket_groups_rowid
    ,tg.ticket_group_id
    ,ts.rowid as ticket_sales_rowid
    ,ts.ticket_sales_id
    ,ts.ticket_quantity
    ,ts.customer_id
    ,ts.reseller_id
from
    event_system.events e
    ,event_system.ticket_groups tg
    ,event_system.ticket_sales ts
where
    e.event_id = tg.event_id
    and tg.ticket_group_id = ts.ticket_group_id;
/

create index customer_purchases_mv_idx01 on customer_purchases_mv (customer_id, event_id, event_series_id);