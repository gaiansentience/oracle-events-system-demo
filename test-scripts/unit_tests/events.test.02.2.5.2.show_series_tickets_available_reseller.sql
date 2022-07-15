--show tickets available for an event through a reseller using event id and reseller id
select
*
from
event_sales_api.show_event_series_tickets_available_reseller(61,3);

select max(event_series_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_series_id is not null and e.event_name = 'Hometown Hockey League';

select * from resellers where reseller_name = 'Old School';
