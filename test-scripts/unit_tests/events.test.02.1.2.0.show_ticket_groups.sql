--show ticket groups created for an event using event id
--use show_venue_upcoming events to get event_ids (test.02.00)
--An event will only show the price category of UNDEFINED before ticket groups are created
--tickets_available shows the current number of tickets in the group
--currently_assigned shows the total number of tickets currently assigned to resellers
--any vendor_direct sales are also shown for the group
--the group size can be increased if there are UNDEFINED tickets
--the group size can only be decreased to the sum of currently_assigned and sold_by_venue
--if there are values in currently_assigned
select
*
from
event_setup_api.show_ticket_groups(602);


select * from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';