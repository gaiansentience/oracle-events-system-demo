create or replace view resellers_v_json_verify as
select
    r.reseller_id
    ,j.reseller_id as reseller_id_json
    ,j.reseller_name
    ,j.reseller_email
    ,j.commission_percent
from
    resellers_v_json r,
    json_table(r.json_doc
        columns
            (
            reseller_id         number       path '$.reseller_id'
            ,reseller_name      varchar2(50) path '$.reseller_name'
            ,reseller_email     varchar2(50) path '$.reseller_email'
            ,commission_percent number       path '$.commission_percent'
            )
    ) j;