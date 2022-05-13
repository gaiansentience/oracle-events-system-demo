create or replace package events_test_data_api
authid current_user
as
--used to populate the system with sample using events_api code

--remove all data from the system tables
procedure delete_test_data;

--remove all data for an event
--use during testing to repeat event creation process
procedure delete_event_data(p_event_id in number);

--use during testing to remove a recurring venue event by name
procedure delete_venue_events_by_name
(
   p_venue_id in number,
   p_event_name in varchar2
);

--create random sales for an event
procedure create_event_ticket_sales
(
   p_event_id in number
);

--generate random sales for random events
procedure create_ticket_sales;

procedure create_test_data;

end events_test_data_api;
