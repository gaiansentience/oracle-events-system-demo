create or replace package events_api 
authid current_user
as 

    function get_venue_id
    (
        p_venue_name in varchar2
    ) return number;

    procedure create_venue
    (
        p_venue_name in varchar2,
        p_organizer_name in varchar2,
        p_organizer_email in varchar2,   
        p_max_event_capacity in number,
        p_venue_id out number
    );
    
    procedure update_venue
    (
        p_venue_id in number,
        p_venue_name in varchar2,
        p_organizer_name in varchar2,
        p_organizer_email in varchar2,   
        p_max_event_capacity in number  
    );    
    
    procedure show_venue
    (
        p_venue_id in number,
        p_info out sys_refcursor
    );
        
    procedure show_venues_summary
    (
        p_venues out sys_refcursor
    );
    
    function get_reseller_id
    (
        p_reseller_name in varchar2
    ) return number;
      
    procedure create_reseller
    (
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10,
        p_reseller_id out number
    );
    
    procedure update_reseller
    (
        p_reseller_id in number,    
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10    
    );
    
    procedure show_reseller
    (
        p_reseller_id in number,
        p_info out sys_refcursor
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
    
    procedure update_customer
    (
        p_customer_id in number,
        p_customer_name in varchar2,
        p_customer_email in varchar2
    );
    
    procedure show_customer
    (
        p_customer_id in number,
        p_info out sys_refcursor
    );
    
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
    procedure show_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    --show ticket groups not assigned to any reseller for this event
    procedure show_event_tickets_available_venue
    (
        p_event_id in number,
        p_ticket_groups out sys_refcursor
    );

    --show all tickets available for events in the series (reseller or venue direct)
    --show each ticket group with availability by source (each reseller or venue)
    --include tickets available in each group by source
    --events_in_series shows the total number of events included in the series
    --events_available shows the number of events in the series the source still has tickets available for
    --events_sold_out show the number of events in the series that the source has no more tickets available
    --include ticket price for each group
    --used by venue application to show overall ticket availability
    procedure show_event_series_tickets_available_all
    (
        p_event_series_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    procedure show_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    );
    
    procedure show_event_series_tickets_available_venue
    (
        p_event_series_id in number,
        p_ticket_groups out sys_refcursor
    );

    
    function get_current_ticket_price
    (
        p_ticket_group_id in number
    ) return number;
    
    
    
    --record ticket purchased through reseller application
    --raise error if ticket group quantity available is less than number of tickets requested
    --return ticket sales id as sales confirmation number
    procedure purchase_tickets_reseller
    (
        p_reseller_id in number,
        p_ticket_group_id in number,
        p_customer_id in number,
        p_number_tickets in number,
        p_requested_price in number,
        p_actual_price out number,
        p_extended_price out number,
        p_ticket_sales_id out number
    );
    
    --record ticket purchased from venue directly
    --raise error if ticket group quantity available is less than number of tickets requested
    --return ticket sales id as sales confirmation number
    procedure purchase_tickets_venue
    (
        p_ticket_group_id in number,
        p_customer_id in number,
        p_number_tickets in number,
        p_requested_price in number,
        p_actual_price out number,
        p_extended_price out number,
        p_ticket_sales_id out number
    );

    procedure purchase_tickets_reseller_series
    (
        p_reseller_id in number,
        p_event_series_id in number,
        p_price_category in varchar2,
        p_customer_id in number,
        p_number_tickets in number,
        p_requested_price in number,
        p_average_price out number,
        p_total_purchase out number,
        p_total_tickets out number,        
        p_status_code out varchar2,
        p_status_message out varchar2
    );

    procedure purchase_tickets_venue_series
    (
        p_event_series_id in number,
        p_price_category in varchar2,
        p_customer_id in number,
        p_number_tickets in number,
        p_requested_price in number,
        p_average_price out number,
        p_total_purchase out number,
        p_total_tickets out number,        
        p_status_code out varchar2,
        p_status_message out varchar2
    );

    --expose purchase methods to web services using a common record type for parameters
    type r_purchase is record(
        event_id number,
        event_series_id number,
        reseller_id number,
        customer_id number,
        ticket_group_id number,
        price_category ticket_groups.price_category%type,
        tickets_requested number,
        price_requested number,
        actual_price number,
        average_price number,
        tickets_purchased number,
        purchase_amount number,
        ticket_sales_id number,
        status_code varchar2(20),
        status_message varchar2(4000));

    procedure purchase_tickets_reseller(p_purchase in out r_purchase);

    procedure purchase_tickets_venue(p_purchase in out r_purchase);

    procedure purchase_tickets_reseller_series(p_purchase in out r_purchase);

    procedure purchase_tickets_venue_series(p_purchase in out r_purchase);

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

    procedure show_customer_event_series_tickets
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_tickets out sys_refcursor
    );
    
    procedure show_customer_event_series_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number,
        p_tickets out sys_refcursor
    );
      
    --use to replace customer lost tickets
    --update ticket status to REISSUED and add R to the serial code
    --raise error if customer is not the original purchaser
    --raise error if ticket status is REISSUED or VALIDATED
    procedure ticket_reissue
    (
        p_customer_id in number,
        p_ticket_serial_code in varchar2
    );
    
    procedure ticket_reissue_using_email
    (
        p_customer_email in varchar2,
        p_ticket_serial_code in varchar2
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
        p_ticket_serial_code in varchar2
    );
    
    --used to verify that the ticket was used to enter the event
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
    procedure ticket_verify_restricted_access
    (
        p_ticket_group_id in number,
        p_serial_code in varchar2
    );

    --set ticket status to cancelled
    procedure cancel_ticket
    (
        p_event_id in number,    
        p_serial_code in varchar2
    );

end events_api;