--show tickets available for an event (via reseller and direct) using event id
select
* 
from
event_sales_api.show_event_series_ticket_prices(61);

select max(event_series_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_series_id is not null and e.event_name = 'Hometown Hockey League';


