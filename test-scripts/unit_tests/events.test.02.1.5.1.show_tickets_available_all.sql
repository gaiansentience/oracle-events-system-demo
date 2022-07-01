--show tickets available for an event (via reseller and direct) using event id
select
* 
from
events_report_api.show_event_tickets_available_all(533);

select * from events e where e.event_name = 'The New Toys';
