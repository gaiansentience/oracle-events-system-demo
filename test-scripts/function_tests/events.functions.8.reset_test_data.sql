--remove data created by functional test scripts
declare
   v_event_name varchar2(100);
   v_venue_id number;
begin

select v.venue_id into v_venue_id from venues v where v.venue_name = 'All That Jazz';

v_event_name := 'Blues and Jazz Show';
events_test_data_api.delete_venue_events_by_name(v_venue_id, v_event_name);

delete from resellers r where r.reseller_name = 'Future Event Tickets';

delete from venues v where v.venue_id = v_venue_id;

commit;

end;