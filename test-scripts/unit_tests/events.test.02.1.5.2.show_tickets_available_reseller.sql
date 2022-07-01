--show tickets available for an event through a reseller using event id and reseller id
select
*
from
events_report_api.show_event_tickets_available_reseller(533,3);

select * from events e where e.event_name = 'The New Toys';

select * from resellers r where r.reseller_name = 'Old School';
