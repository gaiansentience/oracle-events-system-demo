--show tickets available for an event (via reseller and direct) using event id
select
* 
from
events_report_api.show_event_series_tickets_available_all(13);

select max(event_series_id) from events where event_series_id is not null and event_name = 'Hometown Hockey League' group by event_series_id;

