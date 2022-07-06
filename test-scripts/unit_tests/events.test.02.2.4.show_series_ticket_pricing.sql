--show tickets available for an event (via reseller and direct) using event id
select
* 
from
events_report_api.show_event_series_ticket_prices(13);

select * from venues where venue_name = 'City Stadium';

select max(event_series_id) from events where venue_id = 1 and event_series_id is not null and event_name = 'Hometown Hockey League';


