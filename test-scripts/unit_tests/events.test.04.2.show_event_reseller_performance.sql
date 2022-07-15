--compare reseller performance for all sales in venue using venue_id
select
*
from
venue_api.show_event_reseller_performance(602);

select * from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';