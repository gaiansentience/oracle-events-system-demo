--show tickets available for an event through a reseller using event id and reseller id
select
*
from
events_report_api.show_event_series_tickets_available_reseller(13,3);

select * from venues where venue_name = 'City Stadium';

select max(event_series_id) from events where venue_id = 1 and event_series_id is not null and event_name = 'Hometown Hockey League';

select * from resellers where reseller_name = 'Old School';
