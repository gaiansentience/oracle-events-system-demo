create or replace package venue_api 
authid definer
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
    
    procedure show_all_venues
    (
        p_venues out sys_refcursor
    );
      
    procedure show_venue_summary
    (
        p_venue_id in number,
        p_summary out sys_refcursor
    );
                  
    procedure show_all_venues_summary
    (
        p_venues out sys_refcursor
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

    type r_venue_info is record
    (
        venue_id            venues.venue_id%type
        ,venue_name         venues.venue_name%type
        ,organizer_name     venues.organizer_name%type
        ,organizer_email    venues.organizer_email%type
        ,max_event_capacity venues.max_event_capacity%type
        ,events_scheduled   number    
    );

    type t_venue_info is table of r_venue_info;

    function show_venue
    (
        p_venue_id in venues.venue_id%type
    ) return t_venue_info pipelined;

    function show_all_venues
    return t_venue_info pipelined;

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
    
    function show_venue_summary
    (
        p_venue_id in venues.venue_id%type    
    ) return t_venue_summary pipelined;

    function show_all_venues_summary 
    return t_venue_summary pipelined;
        
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

end venue_api;