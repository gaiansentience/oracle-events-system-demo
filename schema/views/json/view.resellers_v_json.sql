create or replace view resellers_v_json as
with json_base as
(
    select
        r.reseller_id
        ,json_object(
            'reseller_id'     : r.reseller_id
            ,'reseller_name'  : r.reseller_name
            ,'reseller_email' : r.reseller_email
            ,'commission_percent' : r.commission_percent
        ) as json_doc
    from event_system.resellers r
)
select
    b.reseller_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;