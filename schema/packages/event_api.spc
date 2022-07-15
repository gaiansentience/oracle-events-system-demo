create or replace package event_api 
authid current_user
as 
            
    function get_event_id
    (
        p_venue_id in number,
        p_event_name in varchar2
    ) return number;

    function get_event_series_id
    (
        p_venue_id in number,
        p_event_name in varchar2        
    ) return number;
    
    function get_event_series_id
    (
        p_event_id in number
    ) return number;
    
    procedure show_event
    (
        p_event_id in number,
        p_event_info out sys_refcursor
    );

    procedure show_event_series
    (
        p_event_series_id in number,
        p_series_events out sys_refcursor
    );
        
    --show all planned events for the venue
    procedure show_all_events
    (
        p_venue_id in number,
        p_events out sys_refcursor
    );
    
    --show all planned events that are part of an event series for the venue
    --include total ticket sales to date
    procedure show_all_event_series
    (
        p_venue_id in number,
        p_events out sys_refcursor
    );
    
    type r_event_info is record
    (
        venue_id           venues.venue_id%type
        ,venue_name        venues.venue_name%type
        ,organizer_name    venues.organizer_name%type
        ,organizer_email   venues.organizer_email%type
        ,event_id          events.event_id%type
        ,event_series_id   events.event_series_id%type
        ,event_name        events.event_name%type
        ,event_date        events.event_date%type
        ,tickets_available events.tickets_available%type
        ,tickets_remaining events.tickets_available%type
    ); 
    
    type t_event_info is table of r_event_info;

    function show_event
    (
        p_event_id in number
    ) return t_event_info pipelined;
    
    type r_event_series_info is record
    (
        venue_id                      venues.venue_id%type
        ,venue_name                   venues.venue_name%type
        ,event_series_id              events.event_series_id%type
        ,event_series_name            events.event_name%type
        ,events_in_series             number
        ,tickets_available_all_events number
        ,tickets_remaining_all_events number
        ,events_sold_out              number
        ,events_still_available       number
        ,event_id                     events.event_id%type
        ,event_name                   events.event_name%type
        ,event_date                   events.event_date%type
        ,tickets_available            events.tickets_available%type
        ,tickets_remaining            events.tickets_available%type
    );
    
    type t_event_series_info is table of r_event_series_info;
        
    function show_event_series
    (
        p_event_series_id in number
    ) return t_event_series_info pipelined;

    --show all planned events for the venue
    function show_all_events
    (
        p_venue_id in number
    ) return t_event_info pipelined;

    --show all planned events for the venue
    function show_all_event_series
    (
        p_venue_id in number
    ) return t_event_info pipelined;

end event_api;