create or replace view tickets_available_venue_v as
--venue tickets available (all unsold tickets not assigned to resellers)
with available_venue as
(
    select
        tg.event_id
        ,tg.price_category
        ,tg.ticket_group_id
        ,tg.price
        ,tg.tickets_available as group_tickets_available
        ,tg.tickets_sold as group_tickets_sold
        ,tg.tickets_remaining as group_tickets_remaining
        ,null as reseller_id
        ,'VENUE DIRECT SALES' as reseller_name
        ,tg.tickets_available
            - nvl(
                (
                    select 
                        sum(ta.tickets_assigned) 
                    from ticket_assignments ta 
                    where 
                        ta.ticket_group_id = tg.ticket_group_id
                )
            ,0)
            - nvl(
                (
                    select 
                        sum(ts.ticket_quantity) 
                    from ticket_sales ts 
                    where 
                        ts.ticket_group_id = tg.ticket_group_id 
                        and ts.reseller_id is null
                )
            ,0) as tickets_available
    from event_ticket_prices_v tg
)
select 
    v.venue_id
    ,v.venue_name
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available as event_tickets_available
    ,a.price_category
    ,a.ticket_group_id 
    ,a.price
    ,a.group_tickets_available
    ,a.group_tickets_sold
    ,a.group_tickets_remaining
    ,a.reseller_id
    ,a.reseller_name 
    ,a.tickets_available
    ,case 
        when a.tickets_available = 0 then 'SOLD OUT' 
        else a.tickets_available || ' AVAILABLE' 
    end as ticket_status
from 
    venues v join events e on v.venue_id = e.venue_id
    join available_venue a on e.event_id = a.event_id