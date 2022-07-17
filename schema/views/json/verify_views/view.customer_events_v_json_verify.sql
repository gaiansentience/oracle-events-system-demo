create or replace view customer_events_v_json_verify as
with base as
(
    select
        customer_id
        ,venue_id
        ,json_doc
    from customer_events_v_json
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
    ,j.event_id 
    ,j.event_name
    ,cast(j.event_date as date) as event_date
    ,j.event_tickets
from 
    base b,
    json_table(b.json_doc
        columns
        (
            customer_id     number        path '$.customer_id'
            ,customer_name  varchar2(100) path '$.customer_name'
            ,customer_email varchar2(100) path '$.customer_email'
            ,venue_id       number        path '$.venue_id'
            ,venue_name     varchar2(100) path '$.venue_name'
            ,nested                       path '$.event_listing[*]'
                columns
                (
                    event_series_id number path event_series_id
                    ,event_id       number        path event_id
                    ,event_name     varchar2(100) path event_name
                    ,event_date     timestamp     path event_date
                    ,event_tickets  number        path event_tickets
                )
        )
    ) j;

