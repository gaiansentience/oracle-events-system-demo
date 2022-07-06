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
events_report_api.show_ticket_groups_event_series(13);

select * from venues where venue_name = 'City Stadium';

select max(event_series_id) from events where venue_id = 1 and event_series_id is not null and event_name = 'Hometown Hockey League';