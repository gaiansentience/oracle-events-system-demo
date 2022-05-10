--remove current data for events created by test scripts (test.02-test.05)
declare

v_event_name varchar2(100);
v_venue_id number;


begin

select v.venue_id into v_venue_id from venues v where v.venue_name = 'City Stadium';

v_event_name := 'The New Toys';
events_test_data_api.delete_venue_events_by_name(v_venue_id, v_event_name);

v_event_name := 'Amateur Comedy Hour';
events_test_data_api.delete_venue_events_by_name(v_venue_id, v_event_name);


end;