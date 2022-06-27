create or replace view event_series_ticket_prices_v_json_verify as
with base as
(
    select
        venue_id
        ,event_series_id
        ,json_doc
    from event_series_ticket_prices_v_json
)
select
    b.venue_id
    ,j.venue_id venue_id_json
    ,j.venue_name
    ,b.event_series_id
    ,j.event_series_id event_series_id_json
    ,j.event_name
    ,j.events_in_series
    ,cast(j.first_event_date as date) as first_event_date
    ,cast(j.last_event_date as date) as last_event_date
    ,j.event_tickets_available
    ,j.price_category
    ,j.price
    ,j.tickets_available_all_events
    ,j.tickets_sold_all_events
    ,j.tickets_remaining_all_events
from
    base b,
    json_table(b.json_doc
        columns
        (
            venue_id                 number        path '$.venue_id'
            ,venue_name              varchar2(100) path '$.venue_name'
            ,event_series_id         number        path '$.event_series_id'
            ,event_name              varchar2(100) path '$.event_name'
            ,events_in_series        number        path '$.events_in_series'            
            ,first_event_date        timestamp     path '$.first_event_date'
            ,last_event_date         timestamp     path '$.last_event_date'
            ,event_tickets_available number        path '$.event_tickets_available'
            ,nested path '$.ticket_groups[*]'
                columns
                (
                    price_category     varchar2(50) path price_category
                    ,price             number       path price
                    ,tickets_available_all_events number       path tickets_available_all_events
                    ,tickets_sold_all_events      number       path tickets_sold_all_events
                    ,tickets_remaining_all_events number       path tickets_remaining_all_events
                )
        )
    ) j;