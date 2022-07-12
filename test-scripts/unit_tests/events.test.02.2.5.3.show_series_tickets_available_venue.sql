--show tickets available for an event directly from the venue using event id
--these match the values for venue direct sales rows in the show_all_event_tickets_available (test.05.01)
select
*
from
events_report_api.show_event_series_tickets_available_venue(61);

select max(event_series_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_series_id is not null and e.event_name = 'Hometown Hockey League';

