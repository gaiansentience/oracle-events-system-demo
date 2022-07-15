create or replace package events_report_api
authid current_user
as
--expose ref cursor procedures from events_api.[show]xxx procedures
--use pipelined table functions to support applications that cannot use ref cursors


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



end events_report_api;
