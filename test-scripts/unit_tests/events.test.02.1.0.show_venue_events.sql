--show all events scheduled at the venue using venue id
--run show_venues_summary to find venue ids (test.01.01.00)
select
*
from
events_report_api.show_venue_upcoming_events(1) 
where event_name = 'The New Toys'
--where event_name = 'Amateur Comedy Hour'
order by event_date;

