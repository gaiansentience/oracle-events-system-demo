--show info for a reseller
--use to get info before calling update reseller
select
*
from 
event_system.events_report_api.show_reseller(12)
order by reseller_name;


select * from resellers r 
where r.reseller_name = 'Easy Tickets';
