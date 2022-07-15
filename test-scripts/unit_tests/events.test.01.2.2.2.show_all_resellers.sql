--show all resellers
--use to select a reseller
select
*
from 
reseller_api.show_all_resellers()
order by reseller_name
