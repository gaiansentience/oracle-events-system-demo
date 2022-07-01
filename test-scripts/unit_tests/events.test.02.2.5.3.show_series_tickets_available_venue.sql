--show tickets available for an event directly from the venue using event id
--these match the values for venue direct sales rows in the show_all_event_tickets_available (test.05.01)
select
*
from
events_report_api.show_event_series_tickets_available_venue(13);

select max(event_series_id) from events where event_series_id is not null and event_name = 'Hometown Hockey League' group by event_series_id;

