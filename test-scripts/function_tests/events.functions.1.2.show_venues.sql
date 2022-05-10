--show all venues
select
*
from 
events_report_api.show_venues_summary()
where venue_name = 'All That Jazz'
order by venue_name
