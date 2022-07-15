create or replace package events_api 
authid current_user
as 
/*
    c_ticket_status_issued constant varchar2(20) := 'ISSUED';
    c_ticket_status_reissued constant varchar2(20) := 'REISSUED';
    c_ticket_status_cancelled constant varchar2(20) := 'CANCELLED';
    c_ticket_status_validated constant varchar2(20) := 'VALIDATED';
    c_ticket_status_refunded constant varchar2(20) := 'REFUNDED';
*/
            
----event setup api-------------------begin
            
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
        
    --raise error if event date is already past or venue has a conflicting event
    --raise error if tickets available is > venue max event capacity
    procedure create_event
    (
        p_venue_id in number,   
        p_event_name in varchar2,
        p_event_date in date,
        p_tickets_available in number,
        p_event_id out number
    );
    
    --update event name, date and tickets available
    --raise error if event date is already past or venue has a conflicting event
    --raise error if tickets available is > venue max event capacity
    --raise error if ticket sales are > requested tickets available
    --raise error if all reseller assignments plus venue direct sales are > requested tickets available
    --raise error if sum of currently defined ticket groups is > requested tickets available
    procedure update_event
    (
        p_event_id in number,   
        p_event_name in varchar2,
        p_event_date in date,
        p_tickets_available in number
    );

    procedure show_event
    (
        p_event_id in number,
        p_event_info out sys_refcursor
    );
        
    type r_series_event is record
    (
        event_id        number
        ,event_date     date
        ,status_code    varchar2(20)
        ,status_message varchar2(4000)
    );
    
    type t_series_event is table of r_series_event index by pls_integer;
    
    procedure create_weekly_event
    (
        p_venue_id in number,   
        p_event_name in varchar2,
        p_event_start_date in date,
        p_event_end_date in date,
        p_event_day in varchar2,
        p_tickets_available in number,
        p_event_series_id out number,        
        p_status_details out events_api.t_series_event,
        p_status_code out varchar2,
        p_status_message out varchar2
    );
    
    procedure create_weekly_event
    (
        p_venue_id in number,   
        p_event_name in varchar2,
        p_event_start_date in date,
        p_event_end_date in date,
        p_event_day in varchar2,
        p_tickets_available in number,
        p_event_series_id out number,
        p_status out varchar2
    );

    --update event name for events in the series that have not occurred
    --update tickets_available for events in the series that have not occurred
    --verify requested tickets available against venue max capacity
    --raise error if any upcoming event has sales > requested tickets available
    --raise error if any upcoming event has reseller_assignments + venue_sales > requested tickets available
    --raise error if any upcoming event has sum of ticket groups defined > requested tickets available
    procedure update_event_series
    (
        p_event_series_id in number,   
        p_event_name in varchar2,
        p_tickets_available in number
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
    
    --show currently defined ticket groups for an event
    --for each group include quantity and price
    --also include an UNDEFINED group to show how many more tickets could be assigned to groups
    --the quantity of the UNDEFINED group is event capacity - sum of all current groups
    procedure show_ticket_groups
    (
        p_event_id in number,
        p_ticket_groups out sys_refcursor
    );

    procedure show_ticket_groups_event_series
    (
        p_event_series_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    --create a price category ticket group for the event
    --if the group already exists, update the number of tickets available
    --raise an error if ticket group would exceed event total tickets
    procedure create_ticket_group
    (
        p_event_id in number,
        p_price_category in varchar2 default 'General Admission',
        p_price in number,
        p_tickets in number,
        p_ticket_group_id out number
    );

    --create a price category ticket group for all events in the event series
    --if the group already exists, update the number of tickets available
    --raise an error if ticket group would exceed event total tickets
    procedure create_ticket_group_event_series
    (
        p_event_series_id in number,
        p_price_category in varchar2 default 'General Admission',
        p_price in number,
        p_tickets in number,
        p_status_code out varchar2,
        p_status_message out varchar2
    );

    
    function get_ticket_group_category
    (
        p_ticket_group_id in number
    ) return varchar2;

    --show ticket groups and availability for this event and reseller
    --     tickets_in_group    tickets in group, 
    --     assigned_to_others  tickets assigned to other resellers, 
    --     currently_assigned  tickets currently assigned to reseller, 
    --     max_available       maximum tickets available for reseller (includes currently assigned)
    procedure show_ticket_assignments
    (
        p_event_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    );

    procedure show_ticket_assignments_event_series
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    --assign a group of tickets in a price category to a reseller
    --if the reseller already has that category assigned, update the number of tickets
    --raise an error if the ticket group doesnt have that many tickets available
    procedure create_ticket_assignment
    (
        p_reseller_id in number,
        p_ticket_group_id in number,
        p_number_tickets in number,
        p_ticket_assignment_id out number
    );

    procedure create_ticket_assignment_event_series
    (
        p_event_series_id in number,    
        p_reseller_id in number,
        p_price_category in varchar2 default 'General Admission',
        p_number_tickets in number,
        p_status_code out varchar2,
        p_status_message out varchar2
    );

----event setup api-------------------end



----event manage api------------------begin


      

end events_api;