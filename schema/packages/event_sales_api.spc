create or replace package event_sales_api 
authid current_user
as

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
    
    type t_event_tickets is table of r_event_tickets;

    function show_event_tickets_available_all
    (
        p_event_id in number 
    ) return t_event_tickets pipelined;
    
    function show_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number
    ) return t_event_tickets pipelined;
    
    function show_event_tickets_available_venue
    (
        p_event_id in number
    ) return t_event_tickets pipelined;

    type r_event_series_tickets is record
    (
        venue_id           venues.venue_id%type
        ,venue_name        venues.venue_name%type
        ,event_series_id   events.event_series_id%type
        ,event_name        events.event_name%type
        ,first_event_date  date
        ,last_event_date   date
        ,events_in_series  number
        ,price_category    ticket_groups.price_category%type
        ,price             ticket_groups.price%type
        ,reseller_id       resellers.reseller_id%type
        ,reseller_name     resellers.reseller_name%type
        ,tickets_available number
        ,events_available  number
        ,events_sold_out   number
    );
    
    type t_event_series_tickets is table of r_event_series_tickets;

    function show_event_series_tickets_available_all
    (
        p_event_series_id in number 
    ) return t_event_series_tickets pipelined;
    
    function show_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number
    ) return t_event_series_tickets pipelined;
    
    function show_event_series_tickets_available_venue
    (
        p_event_series_id in number
    ) return t_event_series_tickets pipelined;
    
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

    type r_customer_event_tickets is record
    (
        customer_id      customers.customer_id%type
        ,customer_name   customers.customer_name%type
        ,customer_email  customers.customer_email%type
        ,venue_id        venues.venue_id%type
        ,venue_name      venues.venue_name%type
        ,event_id        events.event_id%type
        ,event_name      events.event_name%type
        ,event_date      events.event_date%type
        ,event_tickets   number
        ,ticket_group_id ticket_groups.ticket_group_id%type
        ,price_category  ticket_groups.price_category%type
        ,ticket_sales_id ticket_sales.ticket_sales_id%type
        ,ticket_quantity ticket_sales.ticket_quantity%type
        ,sales_date      ticket_sales.sales_date%type
        ,reseller_id     resellers.reseller_id%type
        ,reseller_name   resellers.reseller_name%type
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

    type r_customer_event_series_tickets is record
    (
        customer_id       customers.customer_id%type
        ,customer_name    customers.customer_name%type
        ,customer_email   customers.customer_email%type
        ,venue_id         venues.venue_id%type
        ,venue_name       venues.venue_name%type
        ,event_series_id  events.event_series_id%type
        ,event_name       events.event_name%type
        ,first_event_date date
        ,last_event_date  date
        ,series_tickets   number
        ,event_id         events.event_id%type
        ,event_date       events.event_date%type
        ,event_tickets    number
        ,ticket_group_id  ticket_groups.ticket_group_id%type
        ,price_category   ticket_groups.price_category%type
        ,ticket_sales_id  ticket_sales.ticket_sales_id%type
        ,ticket_quantity  ticket_sales.ticket_quantity%type
        ,sales_date       ticket_sales.sales_date%type
        ,reseller_id      resellers.reseller_id%type
        ,reseller_name    resellers.reseller_name%type
    );
       
    type t_customer_event_series_tickets is table of r_customer_event_series_tickets;

    function show_customer_event_series_tickets
    (
        p_customer_id in number,
        p_event_series_id in number
    ) return t_customer_event_series_tickets pipelined;
    
    function show_customer_event_series_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number
    ) return t_customer_event_series_tickets pipelined;



----print serialized tickets

end event_sales_api;