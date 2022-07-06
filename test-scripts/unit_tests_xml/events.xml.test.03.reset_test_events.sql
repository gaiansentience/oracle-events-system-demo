--remove current data for events created by test scripts (test.02-test.05)
declare

v_event_name varchar2(100);
v_venue_id number;
v_customer_id number;
v_reseller_id number;
begin

v_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
v_event_name := 'Evangeline Thorpe';
events_test_data_api.delete_venue_events_by_name(v_venue_id, v_event_name);

--delete events for Cool Jazz Evening
v_event_name := 'Cool Jazz Evening';
events_test_data_api.delete_venue_events_by_name(v_venue_id, v_event_name);

--delete test customers created
v_customer_id := events_api.get_customer_id('Edward.Scissorfoot@example.customer.com');
events_test_data_api.delete_customer_data(v_customer_id);

--delete test reseller created
v_reseller_id := events_api.get_reseller_id(p_reseller_name => 'New Wave Tickets');
events_test_data_api.delete_reseller_data(v_reseller_id);

--delete test venue created
events_test_data_api.delete_venue_data(v_venue_id);

end;