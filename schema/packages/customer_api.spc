create or replace package customer_api 
authid current_user
as

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

    type r_customer_info is record
    (
        customer_id     customers.customer_id%type
        ,customer_name  customers.customer_name%type
        ,customer_email customers.customer_email%type
    );

    type t_customer_info is table of r_customer_info;

    function show_customer
    (
        p_customer_id in customers.customer_id%type
    ) return t_customer_info pipelined;
    
    procedure show_customer_events
    (
        p_customer_id in number,
        p_venue_id in number,
        p_events out sys_refcursor
    );
    
    procedure show_customer_events_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number,
        p_events out sys_refcursor
    );

    procedure show_customer_event_series
    (
        p_customer_id in number,
        p_venue_id in number,
        p_events out sys_refcursor
    );
    
    procedure show_customer_event_series_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number,
        p_events out sys_refcursor
    );
    
    type r_customer_events is record
    (
        customer_id      customers.customer_id%type
        ,customer_name   customers.customer_name%type
        ,customer_email  customers.customer_email%type
        ,venue_id        venues.venue_id%type
        ,venue_name      venues.venue_name%type
        ,event_series_id events.event_series_id%type
        ,event_id        events.event_id%type
        ,event_name      events.event_name%type
        ,event_date      events.event_date%type
        ,event_tickets   number
    );
       
    type t_customer_events is table of r_customer_events;
       
    --show tickets purchased by this customer for this event
    function show_customer_events
    (
        p_customer_id in number,
        p_venue_id in number
    ) return t_customer_events pipelined;
    
    function show_customer_events_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number
    ) return t_customer_events pipelined;
    
    type r_customer_event_series is record
    (
        customer_id       customers.customer_id%type
        ,customer_name    customers.customer_name%type
        ,customer_email   customers.customer_email%type
        ,venue_id         venues.venue_id%type
        ,venue_name       venues.venue_name%type
        ,event_series_id  events.event_series_id%type
        ,event_series_name       events.event_name%type
        ,first_event_date date
        ,last_event_date  date
        ,series_events    number
        ,series_tickets   number
    );
       
    type t_customer_event_series is table of r_customer_event_series;

    function show_customer_event_series
    (
        p_customer_id in number,
        p_venue_id in number
    ) return t_customer_event_series pipelined;
    
    function show_customer_event_series_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number
    ) return t_customer_event_series pipelined;
        
    procedure show_customer_event_purchases
    (
        p_customer_id in number,
        p_event_id in number,
        p_purchases out sys_refcursor
    );
    
    procedure show_customer_event_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number,
        p_purchases out sys_refcursor
    );

    procedure show_customer_event_series_purchases
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_purchases out sys_refcursor
    );
    
    procedure show_customer_event_series_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number,
        p_purchases out sys_refcursor
    );

    type r_customer_event_purchases is record
    (
        customer_id      customers.customer_id%type
        ,customer_name   customers.customer_name%type
        ,customer_email  customers.customer_email%type
        ,venue_id        venues.venue_id%type
        ,venue_name      venues.venue_name%type
        ,event_series_id events.event_series_id%type
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
       
    type t_customer_event_purchases is table of r_customer_event_purchases;
       
    --show tickets purchased by this customer for this event
    function show_customer_event_purchases
    (
        p_customer_id in number,
        p_event_id in number
    ) return t_customer_event_purchases pipelined;
    
    function show_customer_event_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number
    ) return t_customer_event_purchases pipelined;

    type r_customer_event_series_purchases is record
    (
        customer_id       customers.customer_id%type
        ,customer_name    customers.customer_name%type
        ,customer_email   customers.customer_email%type
        ,venue_id         venues.venue_id%type
        ,venue_name       venues.venue_name%type
        ,event_series_id  events.event_series_id%type
        ,event_series_name       events.event_name%type
        ,first_event_date date
        ,last_event_date  date
        ,series_events    number
        ,series_tickets   number
        ,event_id         events.event_id%type
        ,event_name       events.event_name%type
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
       
    type t_customer_event_series_purchases is table of r_customer_event_series_purchases;

    function show_customer_event_series_purchases
    (
        p_customer_id in number,
        p_event_series_id in number
    ) return t_customer_event_series_purchases pipelined;
    
    function show_customer_event_series_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number
    ) return t_customer_event_series_purchases pipelined;

    procedure show_customer_event_tickets_by_sale_id
    (
        p_customer_id in number,
        p_ticket_sale_id in number,
        p_tickets out sys_refcursor
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
        ,event_series_id events.event_series_id%type
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
        ,ticket_id        tickets.ticket_id%type
        ,serial_code      tickets.serial_code%type
        ,status           tickets.status%type
        ,issued_to_name   tickets.issued_to_name%type
        ,assigned_section tickets.assigned_section%type
        ,assigned_row     tickets.assigned_row%type
        ,assigned_seat    tickets.assigned_seat%type
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
        ,event_series_name       events.event_name%type
        ,first_event_date date
        ,last_event_date  date
        ,series_events    number
        ,series_tickets   number
        ,event_id         events.event_id%type
        ,event_name       events.event_name%type
        ,event_date       events.event_date%type
        ,event_tickets    number
        ,ticket_group_id  ticket_groups.ticket_group_id%type
        ,price_category   ticket_groups.price_category%type
        ,ticket_sales_id  ticket_sales.ticket_sales_id%type
        ,ticket_quantity  ticket_sales.ticket_quantity%type
        ,sales_date       ticket_sales.sales_date%type
        ,reseller_id      resellers.reseller_id%type
        ,reseller_name    resellers.reseller_name%type
        ,ticket_id        tickets.ticket_id%type
        ,serial_code      tickets.serial_code%type
        ,status           tickets.status%type
        ,issued_to_name   tickets.issued_to_name%type
        ,assigned_section tickets.assigned_section%type
        ,assigned_row     tickets.assigned_row%type
        ,assigned_seat    tickets.assigned_seat%type
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
    

end customer_api;