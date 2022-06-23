create or replace view event_ticket_groups_v_json_verify as
with base as
(
    select
        venue_id
        ,event_id
        ,json_doc
    from event_ticket_groups_v_json
)
select
    b.venue_id
    ,j.venue_id as venue_id_json
    ,j.venue_name
    ,b.event_id
    ,j.event_id as event_id_json
    ,j.event_name
    ,j.event_date
    ,j.event_tickets_available
    ,j.ticket_group_id
    ,j.price_category
    ,j.price
    ,j.tickets_available
    ,j.currently_assigned
    ,j.sold_by_venue
from 
    base b,
    json_table(b.json_doc
        columns
        (
            venue_id                 number        path '$.venue_id'
            ,venue_name              varchar2(100) path '$.venue_name'
            ,event_id                number        path '$.event_id'
            ,event_name              varchar2(100) path '$.event_name'
            ,event_date              date          path '$.event_date'
            ,event_tickets_available number        path '$.event_tickets_available'
            ,nested                                path '$.ticket_groups[*]'
                columns
                (
                    ticket_group_id     number       path ticket_group_id
                    ,price_category     varchar2(50) path price_category
                    ,price              number       path price
                    ,tickets_available  number       path tickets_available
                    ,currently_assigned number       path currently_assigned
                    ,sold_by_venue      number       path sold_by_venue
                )
        )
    ) j;