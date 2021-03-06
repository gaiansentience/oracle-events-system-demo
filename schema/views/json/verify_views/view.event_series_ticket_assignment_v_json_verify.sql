create or replace view event_series_ticket_assignment_v_json_verify as
with base as
(
    select
        venue_id
        ,event_series_id
        ,json_doc
from event_series_ticket_assignment_v_json
)
select
    b.venue_id
    ,j.venue_id as venue_id_json
    ,j.venue_name
    ,j.organizer_name
    ,j.organizer_email
    ,b.event_series_id
    ,j.event_series_id as event_series_id_json
    ,j.event_name
    ,j.first_event_date
    ,j.last_event_date
    ,j.event_tickets_available
    ,j.price_category
    ,j.price
    ,j.tickets_in_group    
    ,j.reseller_id
    ,j.reseller_name
    ,j.reseller_email
    ,j.assigned_to_others
    ,j.tickets_assigned
    ,j.max_available
    ,j.min_assignment
    ,j.sold_by_reseller
    ,j.sold_by_venue
from 
    base b,
    json_table(b.json_doc
        columns
        (
            venue_id                number        path '$.venue_id',
            venue_name              varchar2(100) path '$.venue_name',
            organizer_name          varchar2(100) path '$.organizer_name',
            organizer_email         varchar2(100) path '$.organizer_email',
            event_series_id         number        path '$.event_series_id',
            event_name              varchar2(100) path '$.event_name', 
            first_event_date        date          path '$.first_event_date',
            last_event_date         date          path '$.last_event_date',
            event_tickets_available number        path '$.event_tickets_available',
            nested                                path '$.ticket_resellers[*]'
                columns
                (
                    reseller_id    number        path reseller_id,
                    reseller_name  varchar2(100) path reseller_name,
                    reseller_email varchar2(100) path reseller_email,
                    nested                       path '$.ticket_assignments[*]'
                        columns
                        (
                            price_category       varchar2(50) path price_category,
                            price                number       path price,
                            tickets_in_group     number       path tickets_in_group,   
                            tickets_assigned     number       path tickets_assigned,
                            assigned_to_others   number       path assigned_to_others,
                            max_available        number       path max_available,
                            min_assignment       number       path min_assignment,
                            sold_by_reseller     number       path sold_by_reseller,
                            sold_by_venue        number       path sold_by_venue
                        )
                )
        )
    ) j;