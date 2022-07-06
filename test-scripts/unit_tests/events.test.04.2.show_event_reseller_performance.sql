--compare reseller performance for all sales in venue using venue_id
select
*
from
events_report_api.show_event_reseller_performance(533);

select * from venues where venue_name = 'City Stadium';

select * from events where venue_id = 1 and event_name = 'The New Toys';