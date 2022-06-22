create or replace view tickets_available_venue_v_json_verify as
select
    b.venue_id
    ,j.venue_id as venue_id_json
    ,j.venue_name
    ,b.event_id
    ,j.event_id as event_id_json
    ,j.event_name
    ,j.event_date
    ,j.event_tickets_available
    ,j.price_category
    ,j.ticket_group_id
    ,j.price
    ,j.group_tickets_available
    ,j.group_tickets_sold
    ,j.group_tickets_remaining
    ,j.reseller_id
    ,j.reseller_name
    ,j.tickets_available
    ,j.ticket_status
from
    tickets_available_venue_v_json b,
    json_table (b.json_doc 
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
                    ticket_group_id          number        path ticket_group_id
                    ,price_category          varchar2(100) path price_category
                    ,price                   number        path price
                    ,group_tickets_available number        path tickets_available
                    ,group_tickets_sold      number        path tickets_sold
                    ,group_tickets_remaining number        path tickets_remaining
                    ,nested                                path '$.ticket_resellers[*]'
                        columns
                            (
                            reseller_id        number        path reseller_id
                            ,reseller_name     varchar2(100) path reseller_name
                            ,tickets_available number        path reseller_tickets_available
                            ,ticket_status     varchar2(100) path reseller_ticket_status
                            )
                    )
            )
    ) j
