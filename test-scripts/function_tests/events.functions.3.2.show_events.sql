--show all events scheduled at the venue
select
*
from
events_report_api.show_venue_upcoming_events(23) 
order by event_date;

