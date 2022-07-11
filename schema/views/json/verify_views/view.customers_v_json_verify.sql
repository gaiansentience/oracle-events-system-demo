create or replace view customers_v_json_verify as
with base as
(
    select
        customer_id
        ,json_doc
    from event_system.customers_v_json
)
select
    b.customer_id
    ,j.customer_id as customer_id_json
    ,j.customer_name
    ,j.customer_email
from
    base b,
    json_table(b.json_doc
        columns
            (
            customer_id         number        path '$.customer_id'
            ,customer_name      varchar2(100) path '$.customer_name'
            ,customer_email     varchar2(100) path '$.customer_email'
            )
    ) j;