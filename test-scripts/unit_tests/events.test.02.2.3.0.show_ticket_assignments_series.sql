--show possible ticket group amounts for an event and a reseller using event id and reseller_id
--tickets assigned to other resellers are shown as assigned_to_others
--max_available is calculated using tickets_in_group - assigned_to_others - sold_by_venue
--min_available is based on tickets already sold by the reseller for the group
select
*
from
event_setup_api.show_ticket_assignments_event_series(61,3);

select max(e.event_series_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_series_id is not null and e.event_name = 'Hometown Hockey League';

select * from resellers where reseller_name = 'Old School';