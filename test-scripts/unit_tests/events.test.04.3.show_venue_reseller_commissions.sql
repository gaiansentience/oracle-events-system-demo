--show commisions for the venue for a reseller per month and event
--use venue_id and reseller_id
select
*
from
venue_api.show_venue_reseller_commissions(1,3);

select * from venues where venue_name = 'City Stadium';

select * from resellers where reseller_name = 'Old School';