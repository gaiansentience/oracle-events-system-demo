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

create index customer_purchases_mv_idx02 on customer_purchases_mv (customer_id, event_series_id, event_id);

create unique index customer_purchases_mv_udx_ticket_sales_id on customer_purchases_mv (ticket_sales_id);

--index the rowid columns to improve fast refresh performance
create index customer_purchases_mv_idx_rid01 on customer_purchases_mv (events_rowid);

create index customer_purchases_mv_idx_rid02 on customer_purchases_mv (ticket_groups_rowid);

--creating the mv results in system generated unique index on ticket_sales_rowid
--create index customer_purchases_mv_idx_rid03 on customer_purchases_mv (ticket_sales_rowid);
