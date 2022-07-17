create or replace view customer_event_series_v_json_verify as
with base as
(
    select
        customer_id
        ,venue_id
        ,json_doc
    from customer_event_series_v_json
)
select
    b.customer_id
    ,j.customer_id as customer_id_json
    ,j.customer_name
    ,j.customer_email
    ,b.venue_id
    ,j.venue_id as venue_id_json
    ,j.venue_name
    ,j.event_series_id
    ,j.event_series_name
    ,cast(j.first_event_date as date) as first_event_date
    ,cast(j.last_event_date as date) as last_event_date
    ,j.series_events
    ,j.series_tickets
from 
    base b,
    json_table(b.json_doc
        columns
        (
            customer_id       number        path '$.customer_id'
            ,customer_name    varchar2(100) path '$.customer_name'
            ,customer_email   varchar2(100) path '$.customer_email'
            ,venue_id         number        path '$.venue_id'
            ,venue_name       varchar2(100) path '$.venue_name'
            ,nested                         path '$.event_series_listing[*]'
                columns
                (
                    event_series_id  number        path event_series_id
                    ,event_series_name varchar2(100) path event_series_name
                    ,first_event_date timestamp     path first_event_date
                    ,last_event_date  timestamp     path last_event_date
                    ,series_events    number        path series_events
                    ,series_tickets   number        path series_tickets
                )
        )
    ) j;

