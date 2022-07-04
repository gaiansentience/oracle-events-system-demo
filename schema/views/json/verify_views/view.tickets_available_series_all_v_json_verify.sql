create or replace view tickets_available_series_all_v_json_verify as
with base as
(
    select
        venue_id
        ,event_series_id
        ,json_doc
    from tickets_available_series_all_v_json
)
select
    b.venue_id
    ,j.venue_id as venue_id_json
    ,j.venue_name
    ,b.event_series_id
    ,j.event_series_id as event_series_id_json
    ,j.event_name
    ,j.first_event_date
    ,j.last_event_date
    ,j.events_in_series
    ,j.price_category
    ,j.price
    ,j.reseller_id
    ,j.reseller_name
    ,j.tickets_available
    ,j.events_available
    ,j.events_sold_out
from
    base b,
    json_table (b.json_doc 
        columns
            (
            venue_id          number        path '$.venue_id'
            ,venue_name       varchar2(100) path '$.venue_name'
            ,event_series_id  number        path '$.event_series_id'
            ,event_name       varchar2(100) path '$.event_name'
            ,first_event_date date          path '$.first_event_date'
            ,last_event_date  date          path '$.last_event_date'
            ,events_in_series number        path '$.events_in_series'
            ,nested                         path '$.ticket_groups[*]'
                columns
                    (
                    price_category varchar2(100) path price_category
                    ,price         number        path price
                    ,nested                      path '$.ticket_resellers[*]'
                        columns
                            (
                            reseller_id        number        path reseller_id
                            ,reseller_name     varchar2(100) path reseller_name
                            ,tickets_available number        path tickets_available
                            ,events_available  number        path events_available
                            ,events_sold_out   number        path events_sold_out
                            )
                    )
            )
    ) j
