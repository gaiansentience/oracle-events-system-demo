create or replace package events_api 
authid current_user
as 

    c_ticket_status_issued constant varchar2(20) := 'ISSUED';
    c_ticket_status_reissued constant varchar2(20) := 'REISSUED';
    c_ticket_status_cancelled constant varchar2(20) := 'CANCELLED';
    c_ticket_status_validated constant varchar2(20) := 'VALIDATED';
    c_ticket_status_refunded constant varchar2(20) := 'REFUNDED';

            
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


      
    function get_ticket_status
    (
        p_serial_code in tickets.serial_code%type
    ) return varchar2;
      
    --use to replace customer lost tickets
    --update ticket status to REISSUED and add R to the serial code
    --raise error if customer is not the original purchaser
    --raise error if ticket status is REISSUED or VALIDATED
    procedure ticket_reissue
    (
        p_customer_id in number,
        p_serial_code in varchar2
    );
    
    procedure ticket_reissue_using_email
    (
        p_customer_email in varchar2,
        p_serial_code in varchar2
    );

    type r_ticket_reissue_request is record
        (
            customer_id customers.customer_id%type,
            customer_email customers.customer_email%type,
            serial_code tickets.serial_code%type, 
            status varchar2(20), 
            status_message varchar2(4000)
        );
    
    type t_ticket_reissues is table of r_ticket_reissue_request index by pls_integer;

    procedure ticket_reissue_batch
    (
        p_tickets in out t_ticket_reissues
    );

    procedure ticket_reissue_using_email_batch
    (
        p_tickets in out t_ticket_reissues
    );


    --validate that the ticket has been used for event entry
    --raise error if ticket was sold for a different event
    --raise error if ticket status is not ISSUED or REISSUED
    --raise error if ticket status is already VALIDATED or CANCELLED
    --set valid ticket status to VALIDATED
    procedure ticket_validate
    (
        p_event_id in number,
        p_serial_code in varchar2
    );
    
    --used to verify that the ticket was used to enter the event
    --raise error if ticket was sold for a different event
    --verify that the ticket status is VALIDATED
    --raise error for any other status
    procedure ticket_verify_validation
    (
        p_event_id in number,
        p_serial_code in varchar2
    );
    
    --used to enter restricted areas like RESERVED SEATING, VIP, etc
    --verify that the ticket serial number was purchased in the ticket group
    --and that the ticket has been validated for entry (status = VALIDATED)
    --raise error if ticket is not part of the ticket group or status is not validated
    --raise error if ticket was sold for a different event
    procedure ticket_verify_restricted_access
    (
        p_ticket_group_id in number,
        p_serial_code in varchar2
    );

    --set ticket status to cancelled
    --raise error if ticket was sold for a different event
    procedure ticket_cancel
    (
        p_event_id in number,    
        p_serial_code in varchar2
    );

end events_api;