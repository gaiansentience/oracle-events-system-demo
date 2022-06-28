create or replace package events_report_api
authid current_user
as
--expose ref cursor procedures from events_api.[show]xxx procedures
--use pipelined table functions to support applications that cannot use ref cursors

    type r_venue_summary is record
    (
        venue_id            venues.venue_id%type
        ,venue_name         venues.venue_name%type
        ,organizer_name     venues.organizer_name%type
        ,organizer_email    venues.organizer_email%type
        ,max_event_capacity venues.max_event_capacity%type
        ,events_scheduled   number
        ,first_event_date   date
        ,last_event_date    date
        ,min_event_tickets  number
        ,max_event_tickets  number
    );
    
    type t_venue_summary is table of r_venue_summary;
    
    function show_venues_summary 
    return t_venue_summary pipelined;

    type r_reseller_info is record
    (
        reseller_id         resellers.reseller_id%type
        ,reseller_name      resellers.reseller_name%type
        ,reseller_email     resellers.reseller_email%type
        ,commission_percent resellers.commission_percent%type
    );
    type t_resellers_info is table of r_reseller_info;
    
    function show_resellers 
    return t_resellers_info pipelined;
    
    type r_upcoming_event is record
    (
        venue_id           venues.venue_id%type
        ,venue_name        venues.venue_name%type
        ,event_id          events.event_id%type
        ,event_series_id   events.event_series_id%type
        ,event_name        events.event_name%type
        ,event_date        events.event_date%type
        ,tickets_available events.tickets_available%type
        ,tickets_remaining events.tickets_available%type
    );
    
    type t_upcoming_events is table of r_upcoming_event;

    --show all planned events for the venue
    function show_venue_upcoming_events
    (
        p_venue_id in number
    ) return t_upcoming_events pipelined;

    --show all planned events for the venue
    function show_venue_upcoming_event_series
    (
        p_venue_id in number
    ) return t_upcoming_events pipelined;

    type r_reseller_performance is record
    (
        venue_id               venues.venue_id%type
        ,venue_name            venues.venue_name%type
        ,reseller_id           resellers.reseller_id%type
        ,reseller_name         resellers.reseller_name%type
        ,total_ticket_quantity number
        ,total_ticket_sales    number
        ,rank_by_sales         number
        ,rank_by_quantity      number
    );

    type t_reseller_performance is table of r_reseller_performance;

    --show ticket sales and ticket quantity for each reseller
    --rank resellers by total sales amount
    function show_venue_reseller_performance
    (
        p_venue_id in number
    ) return t_reseller_performance pipelined;

    type r_event_reseller_performance is record
    (
        venue_id               venues.venue_id%type
        ,venue_name            venues.venue_name%type
        ,event_id              events.event_id%type
        ,event_name            events.event_name%type
        ,event_date            events.event_date%type
        ,reseller_id           resellers.reseller_id%type
        ,reseller_name         resellers.reseller_name%type
        ,total_ticket_quantity number
        ,total_ticket_sales    number
        ,rank_by_sales         number
        ,rank_by_quantity      number
    );

    type t_event_reseller_performance is table of r_event_reseller_performance;

    --show ticket sales and ticket quantity for each reseller
    --rank resellers by total sales amount
    function show_event_reseller_performance
    (
        p_event_id in number
    ) return t_event_reseller_performance pipelined;

    type r_reseller_commission is record
    (
        reseller_id         resellers.reseller_id%type
        ,reseller_name      resellers.reseller_name%type
        ,sales_month        date
        ,sales_month_ending date
        ,event_id           events.event_id%type
        ,event_name         events.event_name%type
        ,total_sales        number
        ,commission_percent resellers.commission_percent%type
        ,total_commission   number
    );
    
    type t_reseller_commissions is table of r_reseller_commission;
    
    --show reseller commission report grouped by month and event
    --?if date is specified show that month, otherwise show all months
    --?if event is specified show that event only, otherwise show all events
    function show_venue_reseller_commissions
    (
        p_venue_id in number,
        p_reseller_id in number
    ) return t_reseller_commissions pipelined;


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


    type r_ticket_prices is record
    (
        venue_id                 venues.venue_id%type
        ,venue_name              venues.venue_name%type
        ,event_id                events.event_id%type
        ,event_name              events.event_name%type
        ,event_date              events.event_date%type
        ,event_tickets_available number
        ,ticket_group_id         ticket_groups.ticket_group_id%type
        ,price_category          ticket_groups.price_category%type
        ,price                   ticket_groups.price%type
        ,tickets_available       number
        ,tickets_sold            number
        ,tickets_remaining       number
    );
    
    type t_ticket_prices is table of r_ticket_prices;
    
    --show pricing and availability for tickets created for the event
    function show_event_ticket_prices
    (
        p_event_id in number
    ) return t_ticket_prices pipelined;
        
    type r_ticket_prices_series is record
    (
        venue_id                      venues.venue_id%type
        ,venue_name                   venues.venue_name%type
        ,event_series_id              events.event_series_id%type
        ,event_name                   events.event_name%type
        ,events_in_series             number
        ,first_event_date             date
        ,last_event_date              date
        ,event_tickets_available      number
        ,price_category               ticket_groups.price_category%type
        ,price                        ticket_groups.price%type
        ,tickets_available_all_events number
        ,tickets_sold_all_events      number
        ,tickets_remaining_all_events number
    );
    
    type t_ticket_prices_series is table of r_ticket_prices_series;
    
    --show pricing and availability of tickets created for the event series
    function show_event_series_ticket_prices
    (
        p_event_series_id in number
    ) return t_ticket_prices_series pipelined;

    type r_event_tickets is record
    (
        venue_id                 venues.venue_id%type
        ,venue_name              venues.venue_name%type
        ,event_id                events.event_id%type
        ,event_name              events.event_name%type
        ,event_date              events.event_date%type
        ,event_tickets_available number
        ,price_category          ticket_groups.price_category%type
        ,ticket_group_id         ticket_groups.ticket_group_id%type
        ,price                   ticket_groups.price%type
        ,group_tickets_available number
        ,group_tickets_sold      number
        ,group_tickets_remaining number
        ,reseller_id             resellers.reseller_id%type
        ,reseller_name           resellers.reseller_name%type
        ,tickets_available       number
        ,ticket_status           varchar2(50)
    );
    
    --show all tickets available for event (reseller or venue direct)
    --show each ticket group with availability by source (each reseller or venue)
    --include tickets available in each group by source
    --show [number] AVAILABLE or SOLD OUT as status for each group/source
    --include ticket price for each group
    --used by venue application to show overall ticket availability
    type t_event_tickets is table of r_event_tickets;

    function show_event_tickets_available_all
    (
        p_event_id in number 
    ) return t_event_tickets pipelined;
    
    --show ticket groups assigned to reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by reseller application to show available ticket groups to customers
    function show_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number
    ) return t_event_tickets pipelined;
    
    --show ticket groups not assigned to any reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by venue organizer application to show tickets available for direct purchase to customers
    function show_event_tickets_available_venue
    (
        p_event_id in number
    ) return t_event_tickets pipelined;

    type r_customer_event_tickets is record
    (
        customer_id              customers.customer_id%type
        ,customer_name           customers.customer_name%type
        ,customer_email          customers.customer_email%type
        ,venue_id                venues.venue_id%type
        ,venue_name              venues.venue_name%type
        ,event_id                events.event_id%type
        ,event_name              events.event_name%type
        ,event_date              events.event_date%type
        ,total_tickets_purchased number
        ,ticket_group_id         ticket_groups.ticket_group_id%type
        ,price_category          ticket_groups.price_category%type
        ,ticket_sales_id         ticket_sales.ticket_sales_id%type
        ,ticket_quantity         ticket_sales.ticket_quantity%type
        ,sales_date              ticket_sales.sales_date%type
        ,reseller_id             resellers.reseller_id%type
        ,reseller_name           resellers.reseller_name%type
    );
       
    type t_customer_event_tickets is table of r_customer_event_tickets;
       
    --show tickets purchased by this customer for this event
    function show_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number
    ) return t_customer_event_tickets pipelined;
    
    function show_customer_event_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number
    ) return t_customer_event_tickets pipelined;

end events_report_api;
