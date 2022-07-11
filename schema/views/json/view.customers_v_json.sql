create or replace view customers_v_json as
with json_base as
(
    select
        c.customer_id
        ,c.customer_email
        ,json_object(
            'customer_id'     : c.customer_id
            ,'customer_name'  : c.customer_name
            ,'customer_email' : c.customer_email
        ) as json_doc
    from event_system.customers_v c
)
select
    b.customer_id
    ,b.customer_email
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;