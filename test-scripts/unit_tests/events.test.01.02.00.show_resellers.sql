--show all resellers
--use to select a reseller
select
*
from 
events_report_api.show_resellers()
order by reseller_name
