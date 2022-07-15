--show all venues in the system
--use to select a venue to view events
select
*
from 
venue_api.show_all_venues()
order by venue_name
