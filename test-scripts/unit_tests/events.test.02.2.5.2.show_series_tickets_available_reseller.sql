--show tickets available for an event through a reseller using event id and reseller id
select
*
from
events_report_api.show_event_series_tickets_available_reseller(13,3);

select max(event_series_id) from events where event_series_id is not null and event_name = 'Hometown Hockey League' group by event_series_id;

select * from resellers where reseller_name = 'Old School';
