--show all events scheduled at the venue using venue id
--run show_venues_summary to find venue ids (test.01.01.00)
select
*
from
event_api.show_event(602);


select * from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';