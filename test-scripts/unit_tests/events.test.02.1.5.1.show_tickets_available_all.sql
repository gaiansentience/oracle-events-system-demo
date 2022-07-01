--show tickets available for an event (via reseller and direct) using event id
select
* 
from
events_report_api.show_event_tickets_available_all(30)

--select * from tickets_available_all_v a where event_id = 30