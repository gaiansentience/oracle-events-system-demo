create or replace view resellers_from_json_v as
select
   r.reseller_id,
   j.reseller_id as reseller_id_json,
   j.reseller_name,
   j.reseller_email
from
   resellers_json_v r,
   json_table(r.json_doc
      columns
      (
        reseller_id number path '$.reseller_id',
        reseller_name varchar2(50) path '$.reseller_name',
        reseller_email varchar2(50) path '$.reseller_email'
      )
   ) j;