create or replace view all_resellers_json_v as
with json_base as
(
select
json_arrayagg(
json_object(
   'reseller_id' : r.reseller_id,
   'reseller_name' : r.reseller_name,
   'reseller_email' : r.reseller_email
)
returning clob) as json_doc
from resellers r
)
select
b.json_doc,
json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b