create or replace package events_api 
authid current_user
as 

    procedure create_venue
    (
        p_venue_name in varchar2,
        p_organizer_name in varchar2,
        p_organizer_email in varchar2,   
        p_max_event_capacity in number,
        p_venue_id out number
    );
    
    procedure show_venues_summary
    (
        p_venues out sys_refcursor
    );
      
    procedure create_reseller
    (
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10,
        p_reseller_id out number
    );

    procedure show_resellers
    (
        p_resellers out sys_refcursor
    );
    
    function get_customer_id
    (
        p_customer_email in varchar2
    ) return number;
    
    procedure create_customer
    (
        p_customer_name in varchar2,
        p_customer_email in varchar2,
        p_customer_id out number
    );   
    
    procedure create_event
    (
        p_venue_id in number,   
        p_event_name in varchar2,
        p_event_date in date,
        p_tickets_available in number,
        p_event_id out number
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

    --show all planned events for the venue
    procedure show_venue_upcoming_events
    (
        p_venue_id in number,
        p_events out sys_refcursor
    );
    
    --show all planned events that are part of an event series for the venue
    --include total ticket sales to date
    procedure show_venue_upcoming_event_series
    (
        p_venue_id in number,
        p_events out sys_refcursor
    );
    
    --show ticket sales and ticket quantity for each reseller
    --rank resellers by total sales amount
    procedure show_venue_reseller_performance
    (
        p_venue_id in number,
        p_reseller_sales out sys_refcursor
    );

    procedure show_event_reseller_performance
    (
        p_event_id in number,
        p_reseller_sales out sys_refcursor
    );

    --show reseller commission report grouped by month and event
    --?if date is specified show that month, otherwise show all months
    --?if event is specified show that event only, otherwise show all events
    procedure show_venue_reseller_commissions
    (
        p_venue_id in number,
        p_reseller_id in number,
        --?   p_month in date default null,
        --?   p_event_id in number default null,
        p_commissions out sys_refcursor
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

    --show pricing and availability for tickets created for the event
    procedure show_event_ticket_prices
    (
        p_event_id in number,
        p_ticket_prices out sys_refcursor
    );

    procedure show_event_series_ticket_prices
    (
        p_event_series_id in number,
        p_ticket_prices out sys_refcursor
    );

    --show all tickets available for event (reseller or venue direct)
    --show each ticket group with availability by source (each reseller or venue)
    --include tickets available in each group by source
    --show [number] AVAILABLE or SOLD OUT as status for each group/source
    --include ticket price for each group
    --used by venue application to show overall ticket availability
    procedure show_event_tickets_available_all
    (
        p_event_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    --show ticket groups assigned to reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by reseller application to show available ticket groups to customers
    procedure show_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    --show ticket groups not assigned to any reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by venue organizer application to show tickets available for direct purchase to customers
    procedure show_event_tickets_available_venue
    (
        p_event_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    function get_current_ticket_price
    (
        p_ticket_group_id in number
    ) return number;
    
    --record ticket purchased through reseller application
    --raise error if ticket group quantity available is less than number of tickets requested
    --return ticket sales id as sales confirmation number
    procedure purchase_tickets_from_reseller
    (
        p_reseller_id in number,
        p_ticket_group_id in number,
        p_customer_id in number,
        p_number_tickets in number,
        p_ticket_sales_id out number
    );
    
    --record ticket purchased from venue directly
    --raise error if ticket group quantity available is less than number of tickets requested
    --return ticket sales id as sales confirmation number
    procedure purchase_tickets_from_venue
    (
        p_ticket_group_id in number,
        p_customer_id in number,
        p_number_tickets in number,
        p_ticket_sales_id out number
    );

    procedure show_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number,
        p_tickets out sys_refcursor
    );
    
    procedure show_customer_event_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number,
        p_tickets out sys_refcursor
    );


end events_api;
