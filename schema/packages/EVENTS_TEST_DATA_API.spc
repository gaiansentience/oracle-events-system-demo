create or replace package events_test_data_api
authid current_user
as
--used to populate the system with sample data using events_api code

    --remove all data from the system tables
    procedure delete_test_data;

    --remove customer and any ticket purchases
    procedure delete_customer_data(p_customer_id in number);

    --remove reseller and any ticket sales and ticket assignments
    procedure delete_reseller_data(p_reseller_id in number);
    
    --remove venue and any associated event data
    procedure delete_venue_data(p_venue_id in number);

    --remove all data for an event
    --use during testing to repeat event creation process
    procedure delete_event_data(p_event_id in number);

    --use during testing to remove a recurring venue event
    procedure delete_event_series(p_event_series_id in number);

    procedure delete_venue_events_by_name(p_venue_id in number, p_event_name in varchar2);

    --create random sales for an event
    procedure create_event_ticket_sales(p_event_id in number);

    --create random series sales for an event series
    procedure create_event_series_ticket_sales(p_event_series_id in number);

    --generate random sales for random events
    procedure create_ticket_sales;

    procedure create_test_data;
    
    --write a large clob in chunks using dbms_output
    --use for test scripts with large documents
    procedure output_put_clob
    (
        p_doc in out nocopy clob, 
        p_chunksize in number default 32000
    );
    
end events_test_data_api;
