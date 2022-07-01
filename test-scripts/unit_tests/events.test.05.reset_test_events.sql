--remove current data for events created by test scripts (test.02-test.05)
declare

v_event_name varchar2(100);
v_venue_id number;
v_reseller_id number;
v_customer_id number;
begin

select v.venue_id into v_venue_id from venues v where v.venue_name = 'City Stadium';

v_event_name := 'The New Toys';
events_test_data_api.delete_venue_events_by_name(v_venue_id, v_event_name);

--delete events for Hometown Hockey League
v_event_name := 'Hometown Hockey League';
events_test_data_api.delete_venue_events_by_name(v_venue_id, v_event_name);

--delete test customers created
v_customer_id := events_api.get_customer_id('Julius.Irving@example.customer.com');
events_test_data_api.delete_customer_data(v_customer_id);

--delete test reseller created
select r.reseller_id into v_reseller_id from resellers r where r.reseller_id = 'Easy Tickets';
events_test_data_api.delete_reseller_data(v_reseller_id);

--delete test venue created
select v.venue_id into v_venue_id from venues v where v.venue_name = 'Roadside Cafe';
events_test_data_api.delete_venue_data(v_venue_id);

end;