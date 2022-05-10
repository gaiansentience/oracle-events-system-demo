--show resellers
select
*
from 
events_report_api.show_resellers()
where reseller_name in ('Future Event Tickets', 'Old School', 'Tickets R Us')
order by reseller_name
