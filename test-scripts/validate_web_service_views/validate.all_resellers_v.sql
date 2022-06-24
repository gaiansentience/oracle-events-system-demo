(
select
    reseller_id
    ,reseller_name
    ,reseller_email
    ,commission_percent
from resellers_v
minus
select
    reseller_id
    ,reseller_name
    ,reseller_email
    ,commission_percent
from all_resellers_v_json_verify
)
union all
(
select
    reseller_id
    ,reseller_name
    ,reseller_email
    ,commission_percent
from resellers_v
minus
select
    reseller_id
    ,reseller_name
    ,reseller_email
    ,commission_percent
from all_resellers_v_xml_verify
)