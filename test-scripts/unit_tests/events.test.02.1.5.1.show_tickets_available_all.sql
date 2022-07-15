--show tickets available for an event (via reseller and direct) using event id
select
* 
from
event_sales_api.show_event_tickets_available_all(602);

select * from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';
