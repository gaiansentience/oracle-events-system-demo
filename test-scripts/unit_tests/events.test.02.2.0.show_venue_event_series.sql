--show all events scheduled at the venue using venue id
--run show_venues_summary to find venue ids (test.01.01.00)
select
*
from
events_report_api.show_venue_upcoming_event_series(1) 
order by event_date;

select * from venues where venue_name = 'City Stadium';