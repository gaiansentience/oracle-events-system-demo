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



----print serialized tickets
    

end customer_api;