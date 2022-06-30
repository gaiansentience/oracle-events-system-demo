create or replace view tickets_available_reseller_v as
--reseller unsold tickets available from their assignments
with available_reseller as 
(
    select
        tg.event_id
        ,tg.event_series_id
        ,tg.price_category
        ,tg.ticket_group_id
        ,tg.price
        ,tg.tickets_available as group_tickets_available
        ,tg.tickets_sold as group_tickets_sold
        ,tg.tickets_remaining as group_tickets_remaining        
        ,ta.reseller_id
        ,r.reseller_name
        ,ta.tickets_assigned
            - nvl(
                (
                    select sum(ts.ticket_quantity) 
                    from event_system.ticket_sales ts 
                    where 
                        ts.ticket_group_id = tg.ticket_group_id 
                        and ts.reseller_id = r.reseller_id
                )
            ,0) as tickets_available
    from
        event_system.event_ticket_prices_v tg 
        join event_system.ticket_assignments ta 
            on tg.ticket_group_id = ta.ticket_group_id
        join event_system.resellers r 
            on ta.reseller_id = r.reseller_id
)
select 
    e.venue_id
    ,e.venue_name
    ,e.event_id
    ,e.event_series_id
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
    event_system.venue_event_base_v e
    join available_reseller a 
        on e.event_id = a.event_id;