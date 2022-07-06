--show possible ticket group amounts for an event and a reseller using event id and reseller_id
--tickets assigned to other resellers are shown as assigned_to_others
--max_available is calculated using tickets_in_group - assigned_to_others - sold_by_venue
--min_available is based on tickets already sold by the reseller for the group
select
*
from
events_report_api.show_ticket_assignments(533,3);


select * from events e where e.event_name = 'The New Toys';

select * from resellers r where r.reseller_name = 'Old School';
