create or replace view event_series_ticket_assignment_v as
select
    ta.venue_id
    ,min(ta.venue_name) as venue_name
    ,min(ta.organizer_email) as organizer_email
    ,min(ta.organizer_name) as organizer_name
    ,ta.event_series_id
    ,min(ta.event_name) as event_name
    ,min(ta.event_date) as first_event_date
    ,max(ta.event_date) as last_event_date
    ,min(ta.event_tickets_available) as event_tickets_available
    ,ta.price_category
    ,max(ta.price) as price
    ,max(ta.tickets_in_group) as tickets_in_group
    ,ta.reseller_id
    ,min(ta.reseller_name) as reseller_name
    ,min(ta.reseller_email) as reseller_email
    ,max(ta.assigned_to_others) as assigned_to_others
    ,max(ta.tickets_assigned) as tickets_assigned
    ,min(ta.max_available) as max_available
    ,max(ta.min_assignment) as min_assignment
    ,max(ta.sold_by_reseller) as sold_by_reseller
    ,max(ta.sold_by_venue) as sold_by_venue
from event_ticket_assignment_v ta
where ta.event_series_id is not null
group by
    ta.venue_id
    ,ta.event_series_id
    ,ta.reseller_id
    ,ta.price_category