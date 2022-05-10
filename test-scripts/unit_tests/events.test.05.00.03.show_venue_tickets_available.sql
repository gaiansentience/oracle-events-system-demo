--show tickets available for an event directly from the venue using event id
--these match the values for venue direct sales rows in the show_all_event_tickets_available (test.05.01)
select
*
from
events_report_api.show_venue_tickets_available(67)
