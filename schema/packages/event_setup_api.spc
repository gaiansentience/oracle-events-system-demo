create or replace package event_setup_api 
authid current_user
as

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
        p_status_details out t_series_event,
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
    
    type r_ticket_groups is record
    (
        event_id            events.event_id%type
        ,event_name         events.event_name%type
        ,ticket_group_id    ticket_groups.ticket_group_id%type
        ,price_category     ticket_groups.price_category%type
        ,price              ticket_groups.price%type
        ,tickets_available  ticket_groups.tickets_available%type
        ,currently_assigned number
        ,sold_by_venue      number
    );
    
    type t_ticket_groups is table of r_ticket_groups;
    
    --show currently defined ticket groups for an event
    --for each group include quantity and price
    --also include an UNDEFINED group to show how many more tickets could be assigned to groups
    --the quantity of the UNDEFINED group is event capacity - sum of all current groups
    function show_ticket_groups
    (
        p_event_id in number
    ) return t_ticket_groups pipelined;

    type r_ticket_groups_series is record
    (
        event_series_id     events.event_series_id%type
        ,event_name         events.event_name%type
        ,price_category     ticket_groups.price_category%type
        ,price              ticket_groups.price%type
        ,tickets_available  ticket_groups.tickets_available%type
        ,currently_assigned number
        ,sold_by_venue      number
    );
    
    type t_ticket_groups_series is table of r_ticket_groups_series;
    
    --show currently defined ticket groups for an event series
    --for each group include quantity and price
    --also include an UNDEFINED group to show how many more tickets could be assigned to groups
    --the quantity of the UNDEFINED group is event capacity - sum of all current groups
    --PRICE is MAX for the price category across all events in the series
    --TICKETS_AVAILABLE is MAX for the price category across all events in the series
    --CURRENTLY_ASSIGNED is MAX for the price category across all events in the series
    --SOLD_BY_VENUE is MAX for the price category across all events in the series
    --CREATING/UPDATING GROUPS OR ASSIGNMENTS SHOULD GENERALLY USE EVENT SERIES METHODS
    --     if an event modifies groups or assignments using event methods 
    --     the tickets_available and currently_assigned values will not reflect all events in the group
    function show_ticket_groups_event_series
    (
        p_event_series_id in number
    ) return t_ticket_groups_series pipelined;

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

    function get_ticket_group_id
    (
        p_event_id in number,
        p_price_category in varchar2
    ) return number;

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
    
    type r_ticket_assignment is record
    (
        event_id            events.event_id%type
        ,ticket_group_id    ticket_groups.ticket_group_id%type
        ,price_category     ticket_groups.price_category%type
        ,tickets_in_group   number
        ,reseller_id        resellers.reseller_id%type
        ,reseller_name      resellers.reseller_name%type
        ,assigned_to_others number
        ,tickets_assigned   number
        ,max_available      number
        ,min_assignment     number
        ,sold_by_reseller   number
        ,sold_by_venue      number
    );
    
    type t_ticket_assignments is table of r_ticket_assignment;
    
    --show ticket groups and availability for this event and reseller
    --     tickets_in_group    tickets in group, 
    --     assigned_to_others  tickets assigned to other resellers, 
    --     currently_assigned  tickets currently assigned to reseller, 
    --     max_available       maximum tickets available for reseller (includes currently assigned)
    function show_ticket_assignments
    (
        p_event_id in number,
        p_reseller_id in number 
    ) return t_ticket_assignments pipelined;

    type r_ticket_assignment_series is record
    (
        event_series_id            events.event_series_id%type
        ,price_category     ticket_groups.price_category%type
        ,tickets_in_group   number
        ,reseller_id        resellers.reseller_id%type
        ,reseller_name      resellers.reseller_name%type
        ,assigned_to_others number
        ,tickets_assigned   number
        ,max_available      number
        ,min_assignment     number
        ,sold_by_reseller   number
        ,sold_by_venue      number
    );
    
    type t_ticket_assignments_series is table of r_ticket_assignment_series;
    
    --show ticket groups and availability for this event and reseller
    --     tickets_in_group    tickets in group, 
    --     assigned_to_others  tickets assigned to other resellers, 
    --     currently_assigned  tickets currently assigned to reseller, 
    --     max_available       maximum tickets available for reseller (includes currently assigned)
    function show_ticket_assignments_event_series
    (
        p_event_series_id in number,
        p_reseller_id in number 
    ) return t_ticket_assignments_series pipelined;
        
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


end event_setup_api;