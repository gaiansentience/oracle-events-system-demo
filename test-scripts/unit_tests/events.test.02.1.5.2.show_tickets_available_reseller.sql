--show tickets available for an event through a reseller using event id and reseller id
select
*
from
events_report_api.show_event_tickets_available_reseller(602,3);

select * from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';

select * from resellers r where r.reseller_name = 'Old School';
