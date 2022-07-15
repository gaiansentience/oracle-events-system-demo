--show all events scheduled at the venue using venue id
--run show_venues_summary to find venue ids (test.01.01.00)
select
*
from
event_api.show_all_events(1) 
--where event_name = 'The New Toys'
order by event_date;

select * from venues v where venue_name = 'City Stadium';