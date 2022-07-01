--compare reseller performance for all sales in venue using venue_id
select
*
from
events_report_api.show_venue_reseller_performance(1);

select * from venues where venue_name = 'City Stadium';