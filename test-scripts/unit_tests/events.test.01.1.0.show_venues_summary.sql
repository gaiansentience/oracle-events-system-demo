--show all venues in the system with event counts
--use to select a venue to view events
select
*
from 
events_report_api.show_venues_summary()
order by venue_name
