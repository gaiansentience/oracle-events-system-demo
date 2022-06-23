create or replace view all_resellers_v_json_verify as
select
    j.reseller_id
    ,j.reseller_name
    ,j.reseller_email
    ,j.commission_percent
from
    all_resellers_v_json r,
    json_table(r.json_doc
        columns
        (
            nested path '$[*]'
                columns
                (
                    reseller_id         number        path '$.reseller_id'
                    ,reseller_name      varchar2(100) path '$.reseller_name'
                    ,reseller_email     varchar2(100) path '$.reseller_email'
                    ,commission_percent number        path '$.commission_percent'
                )
        )
    ) j;