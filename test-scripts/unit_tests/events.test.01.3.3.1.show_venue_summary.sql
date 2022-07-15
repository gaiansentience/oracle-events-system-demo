--show all venues in the system with event counts
--use to select a venue to view events
select
*
from 
venue_api.show_venue_summary(67);

select * from venues v where v.venue_name = 'Roadside Cafe';
