create or replace view all_resellers_from_json_v as
select
   j.reseller_id,
   j.reseller_name,
   j.reseller_email
from
   all_resellers_json_v r,
   json_table(r.json_doc
      columns
      (
      nested path '$[*]'
         columns
         (
         reseller_id number path '$.reseller_id',
         reseller_name varchar2(50) path '$.reseller_name',
         reseller_email varchar2(50) path '$.reseller_email'
         )
      )
   ) j;