create or replace view resellers_v_json_verify as
with base as
(
    select
        reseller_id
        ,json_doc
    from event_system.resellers_v_json
)
select
    b.reseller_id
    ,j.reseller_id as reseller_id_json
    ,j.reseller_name
    ,j.reseller_email
    ,j.commission_percent
from
    base b,
    json_table(b.json_doc
        columns
            (
            reseller_id         number        path '$.reseller_id'
            ,reseller_name      varchar2(100) path '$.reseller_name'
            ,reseller_email     varchar2(100) path '$.reseller_email'
            ,commission_percent number        path '$.commission_percent'
            )
    ) j;