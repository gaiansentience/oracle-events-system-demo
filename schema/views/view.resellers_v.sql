create or replace view resellers_v as
select
   r.reseller_id,
   r.reseller_name,
   r.reseller_email
from
   event_system.resellers r;