--show all venues in the system with event counts
--use to select a venue to view events
select
*
from 
venue_api.show_all_venues_summary()
order by venue_name;
