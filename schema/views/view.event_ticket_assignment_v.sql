create or replace view event_ticket_assignment_v as
with base as
(
    select 
        tg.event_id
        ,r.reseller_id
        ,r.reseller_name
        ,r.reseller_email
        ,tg.ticket_group_id
        ,tg.price_category
        ,tg.price
        ,tg.tickets_available as tickets_in_group
        ,nvl(
            (
            select sum(ta.tickets_assigned) 
            from event_system.ticket_assignments ta
            where 
                ta.ticket_group_id = tg.ticket_group_id 
                and ta.reseller_id <> r.reseller_id
            )
        ,0) as assigned_to_others
        ,nvl(
            (
            select ta.tickets_assigned 
            from event_system.ticket_assignments ta
            where 
                ta.ticket_group_id = tg.ticket_group_id 
                and ta.reseller_id = r.reseller_id
            )
        ,0) as assigned_to_reseller    
        ,nvl(
            (
            select ta.ticket_assignment_id 
            from event_system.ticket_assignments ta
            where 
                ta.ticket_group_id = tg.ticket_group_id 
                and ta.reseller_id = r.reseller_id
            )
        ,0) as ticket_assignment_id    
        ,nvl(
            (
            select sum(ts.ticket_quantity)
            from event_system.ticket_sales ts
            where 
                ts.ticket_group_id = tg.ticket_group_id
                and ts.reseller_id = r.reseller_id
            )
        ,0) as sold_by_reseller
        ,nvl(
            (
            select sum(ts.ticket_quantity)
            from event_system.ticket_sales ts
            where 
                ts.ticket_group_id = tg.ticket_group_id
                and ts.reseller_id is null
            )
        ,0) as sold_by_venue
    from
        event_system.ticket_groups tg
        cross join event_system.resellers r
)
select
    e.venue_id
    ,e.venue_name
    ,e.organizer_email
    ,e.organizer_name
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available as event_tickets_available
    ,b.ticket_group_id
    ,b.price_category
    ,b.price
    ,b.tickets_in_group
    ,b.reseller_id
    ,b.reseller_name
    ,b.assigned_to_others
    ,b.assigned_to_reseller as tickets_assigned
    ,b.ticket_assignment_id
    ,b.tickets_in_group - (b.assigned_to_others + b.sold_by_venue) as max_available
    ,b.sold_by_reseller as min_assignment
    ,b.sold_by_reseller
    ,b.sold_by_venue
from 
    base b 
    join venue_event_base_v e 
        on b.event_id = e.event_id;