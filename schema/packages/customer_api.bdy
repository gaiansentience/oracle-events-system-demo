create or replace package body customer_api 
as

    procedure initialize
    is
    begin
        null;
    end initialize;

    procedure log_error
    (
        p_error_message in varchar2,
        p_error_code in number,
        p_locale in varchar2
    )
    is
    begin

        --route to error api package
        util_error_api.log_error(
            p_error_message => p_error_message, 
            p_error_code => p_error_code, 
            p_locale => 'customer_api.' || p_locale);

    end log_error;

    function get_customer_id
    (
        p_customer_email in varchar2
    ) return number
    is
        v_customer_id number;
    begin

        select customer_id
        into v_customer_id
        from event_system.customers c
        where upper(c.customer_email) = upper(p_customer_email);

        return v_customer_id;

    exception
        when no_data_found then
            return 0;
        when others then
            log_error(sqlerrm, sqlcode, 'get_customer_id');
            raise;
    end get_customer_id;

    procedure validate_customer_record
    (
        p_customer in customers%rowtype
    )
    is
    begin
        case    
            when p_customer.customer_name is null then
                raise_application_error(-20100, 'Missing name, cannot create or update customer');
            when p_customer.customer_email is null then
                raise_application_error(-20100, 'Missing email, cannot create or update customer'); 
            else
                --record is valid
                null;
        end case;

    end validate_customer_record;

    procedure create_customer
    (
        p_customer_name in varchar2,
        p_customer_email in varchar2,
        p_customer_id out number
    )
    is
        r_customer customers%rowtype;
    begin
        --check to see if the email is already registered to a customer
        p_customer_id := get_customer_id(p_customer_email);
        r_customer.customer_name := p_customer_name;
        r_customer.customer_email := p_customer_email;
        validate_customer_record(p_customer => r_customer);

        if p_customer_id = 0 then

            insert into event_system.customers
            (
                customer_name,
                customer_email
            )
            values
            (
                r_customer.customer_name,
                r_customer.customer_email
            )
            returning customer_id 
            into p_customer_id;

        else
            if r_customer.customer_name is not null then
                update event_system.customers c
                set c.customer_name = r_customer.customer_name
                where customer_id = p_customer_id;
            end if;
        end if;

        commit;

    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_customer');
            raise;
    end create_customer;

    procedure update_customer
    (
        p_customer_id in number,
        p_customer_name in varchar2,
        p_customer_email in varchar2
    )
    is
        r_customer customers%rowtype;
    begin
        r_customer.customer_name := p_customer_name;
        r_customer.customer_email := p_customer_email;
        validate_customer_record(p_customer => r_customer);

        update event_system.customers c
        set 
            c.customer_name = r_customer.customer_name,
            c.customer_email = r_customer.customer_email
        where c.customer_id = p_customer_id;

        commit;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'update_customer');
            raise;
    end update_customer;

    procedure show_customer
    (
        p_customer_id in number,
        p_info out sys_refcursor
    )
    is
    begin

        open p_info for
        select
            c.customer_id
            ,c.customer_name
            ,c.customer_email
        from event_system.customers_v c
        where c.customer_id = p_customer_id;

    end show_customer;

    function show_customer
    (
        p_customer_id in customers.customer_id%type
    ) return t_customer_info pipelined
    is
        t_rows t_customer_info;
        rc sys_refcursor;
    begin

        show_customer(p_customer_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;

        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;

    end show_customer;
    
    
    
    procedure show_customer_events
    (
        p_customer_id in number,
        p_venue_id in number,
        p_events out sys_refcursor
    )
    is
    begin
    
        open p_events for
        select
            ct.customer_id
            ,ct.customer_name
            ,ct.customer_email
            ,ct.venue_id
            ,ct.venue_name
            ,ct.event_series_id
            ,ct.event_id
            ,ct.event_name
            ,ct.event_date
            ,ct.event_tickets
        from 
            event_system.customer_events_v ct
        where 
            ct.venue_id = p_venue_id 
            and ct.customer_id = p_customer_id
        order by 
            ct.event_date;
    
    end show_customer_events;

    procedure show_customer_events_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number,
        p_events out sys_refcursor
    )
    is
        v_customer_id number;
    begin
    
        v_customer_id := customer_api.get_customer_id(p_customer_email);
    
        show_customer_events(v_customer_id, p_venue_id, p_events);
    
    end show_customer_events_by_email;
    
    procedure show_customer_event_series
    (
        p_customer_id in number,
        p_venue_id in number,
        p_events out sys_refcursor
    )
    is
    begin
    
        open p_events for
        select
            ct.customer_id
            ,ct.customer_name
            ,ct.customer_email
            ,ct.venue_id
            ,ct.venue_name
            ,ct.event_series_id
            ,ct.event_series_name
            ,ct.first_event_date
            ,ct.last_event_date
            ,ct.series_events
            ,ct.series_tickets
        from 
            event_system.customer_event_series_v ct
        where 
            ct.venue_id = p_venue_id 
            and ct.customer_id = p_customer_id
        order by 
            ct.event_series_name;
    
    end show_customer_event_series;

    procedure show_customer_event_series_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number,
        p_events out sys_refcursor
    )
    is
        v_customer_id number;
    begin
    
        v_customer_id := customer_api.get_customer_id(p_customer_email);
    
        show_customer_event_series(v_customer_id, p_venue_id, p_events);
    
    end show_customer_event_series_by_email;
    
    
    function show_customer_events
    (
        p_customer_id in number,
        p_venue_id in number
    ) return t_customer_events pipelined
    is
        t_rows t_customer_events;
        rc sys_refcursor;
    begin
    
        show_customer_events(p_customer_id, p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_events;

    function show_customer_events_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number
    ) return t_customer_events pipelined
    is
        t_rows t_customer_events;
        rc sys_refcursor;
    begin
            
        show_customer_events_by_email(p_customer_email, p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_events_by_email;
    
    function show_customer_event_series
    (
        p_customer_id in number,
        p_venue_id in number
    ) return t_customer_event_series pipelined
    is
        t_rows t_customer_event_series;
        rc sys_refcursor;
    begin
    
        show_customer_event_series(p_customer_id, p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_series;

    function show_customer_event_series_by_email
    (
        p_customer_email in varchar2,
        p_venue_id in number
    ) return t_customer_event_series pipelined
    is
        t_rows t_customer_event_series;
        rc sys_refcursor;
    begin
        
        show_customer_event_series_by_email(p_customer_email, p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_series_by_email;
    
    procedure show_customer_event_purchases
    (
        p_customer_id in number,
        p_event_id in number,
        p_purchases out sys_refcursor
    )
    is
    begin
    
        open p_purchases for
        select
            ct.customer_id
            ,ct.customer_name
            ,ct.customer_email
            ,ct.venue_id
            ,ct.venue_name
            ,ct.event_series_id
            ,ct.event_id
            ,ct.event_name
            ,ct.event_date
            ,ct.event_tickets
            ,ct.ticket_group_id
            ,ct.price_category
            ,ct.ticket_sales_id
            ,ct.ticket_quantity
            ,ct.sales_date
            ,ct.reseller_id
            ,ct.reseller_name
        from 
            event_system.customer_event_purchases_v ct
        where 
            ct.event_id = p_event_id 
            and ct.customer_id = p_customer_id
        order by 
            ct.price_category
            ,ct.sales_date;
    
    end show_customer_event_purchases;

    procedure show_customer_event_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number,
        p_purchases out sys_refcursor
    )
    is
        v_customer_id number;
    begin
    
        v_customer_id := customer_api.get_customer_id(p_customer_email);
    
        show_customer_event_purchases(v_customer_id, p_event_id, p_purchases);
    
    end show_customer_event_purchases_by_email;
    
    procedure show_customer_event_series_purchases
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_purchases out sys_refcursor
    )
    is
    begin
    
        open p_purchases for
        select
            ct.customer_id
            ,ct.customer_name
            ,ct.customer_email
            ,ct.venue_id
            ,ct.venue_name
            ,ct.event_series_id
            ,ct.event_series_name
            ,ct.first_event_date
            ,ct.last_event_date
            ,ct.series_events
            ,ct.series_tickets
            ,ct.event_id
            ,ct.event_name
            ,ct.event_date
            ,ct.event_tickets
            ,ct.ticket_group_id
            ,ct.price_category
            ,ct.ticket_sales_id
            ,ct.ticket_quantity
            ,ct.sales_date
            ,ct.reseller_id
            ,ct.reseller_name
        from 
            event_system.customer_event_series_purchases_v ct
        where 
            ct.event_series_id = p_event_series_id 
            and ct.customer_id = p_customer_id
        order by 
            ct.price_category, 
            ct.sales_date;
    
    end show_customer_event_series_purchases;

    procedure show_customer_event_series_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number,
        p_purchases out sys_refcursor
    )
    is
        v_customer_id number;
    begin
    
        v_customer_id := customer_api.get_customer_id(p_customer_email);
    
        show_customer_event_series_purchases(v_customer_id, p_event_series_id, p_purchases);
    
    end show_customer_event_series_purchases_by_email;
    
    function show_customer_event_purchases
    (
        p_customer_id in number,
        p_event_id in number
    ) return t_customer_event_purchases pipelined
    is
        t_rows t_customer_event_purchases;
        rc sys_refcursor;
    begin
    
        show_customer_event_purchases(p_customer_id, p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_purchases;

    function show_customer_event_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number
    ) return t_customer_event_purchases pipelined
    is
        t_rows t_customer_event_purchases;
        rc sys_refcursor;
    begin
            
        show_customer_event_purchases_by_email(p_customer_email, p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_purchases_by_email;

    function show_customer_event_series_purchases
    (
        p_customer_id in number,
        p_event_series_id in number
    ) return t_customer_event_series_purchases pipelined
    is
        t_rows t_customer_event_series_purchases;
        rc sys_refcursor;
    begin
    
        show_customer_event_series_purchases(p_customer_id, p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_series_purchases;

    function show_customer_event_series_purchases_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number
    ) return t_customer_event_series_purchases pipelined
    is
        t_rows t_customer_event_series_purchases;
        rc sys_refcursor;
    begin
        
        show_customer_event_series_purchases_by_email(p_customer_email, p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_series_purchases_by_email;
    
    
    --add methods to print_tickets by ticket_sales_id
    procedure show_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number,
        p_tickets out sys_refcursor
    )
    is
    begin
    
        open p_tickets for
        select
            ct.customer_id
            ,ct.customer_name
            ,ct.customer_email
            ,ct.venue_id
            ,ct.venue_name
            ,ct.event_series_id
            ,ct.event_id
            ,ct.event_name
            ,ct.event_date
            ,ct.event_tickets
            ,ct.ticket_group_id
            ,ct.price_category
            ,ct.ticket_sales_id
            ,ct.ticket_quantity
            ,ct.sales_date
            ,ct.reseller_id
            ,ct.reseller_name
            ,ct.ticket_id
            ,ct.serial_code
            ,ct.status
            ,ct.issued_to_name
            ,ct.issued_to_id
            ,ct.assigned_section
            ,ct.assigned_row
            ,ct.assigned_seat
        from 
            event_system.customer_event_tickets_v ct
        where 
            ct.event_id = p_event_id 
            and ct.customer_id = p_customer_id
        order by 
            ct.price_category
            ,ct.sales_date;
    
    end show_customer_event_tickets;

    procedure show_customer_event_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number,
        p_tickets out sys_refcursor
    )
    is
        v_customer_id number;
    begin
    
        v_customer_id := customer_api.get_customer_id(p_customer_email);
        show_customer_event_tickets(v_customer_id, p_event_id, p_tickets);
    
    end show_customer_event_tickets_by_email;
    
    procedure show_customer_event_series_tickets
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_tickets out sys_refcursor
    )
    is
    begin
    
        open p_tickets for
        select
            ct.customer_id
            ,ct.customer_name
            ,ct.customer_email
            ,ct.venue_id
            ,ct.venue_name
            ,ct.event_series_id
            ,ct.event_series_name
            ,ct.first_event_date
            ,ct.last_event_date
            ,ct.series_events
            ,ct.series_tickets
            ,ct.event_id
            ,ct.event_name
            ,ct.event_date
            ,ct.event_tickets
            ,ct.ticket_group_id
            ,ct.price_category
            ,ct.ticket_sales_id
            ,ct.ticket_quantity
            ,ct.sales_date
            ,ct.reseller_id
            ,ct.reseller_name
            ,ct.ticket_id
            ,ct.serial_code
            ,ct.status
            ,ct.issued_to_name
            ,ct.issued_to_id
            ,ct.assigned_section
            ,ct.assigned_row
            ,ct.assigned_seat            
        from 
            event_system.customer_event_series_tickets_v ct
        where 
            ct.event_series_id = p_event_series_id 
            and ct.customer_id = p_customer_id
        order by 
            ct.price_category, 
            ct.sales_date;
    
    end show_customer_event_series_tickets;

    procedure show_customer_event_series_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number,
        p_tickets out sys_refcursor
    )
    is
        v_customer_id number;
    begin
    
        v_customer_id := customer_api.get_customer_id(p_customer_email);
    
        show_customer_event_series_tickets(v_customer_id, p_event_series_id, p_tickets);
    
    end show_customer_event_series_tickets_by_email;
    
    function show_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number
    ) return t_customer_event_tickets pipelined
    is
        t_rows t_customer_event_tickets;
        rc sys_refcursor;
    begin
    
        show_customer_event_tickets(p_customer_id, p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_tickets;

    function show_customer_event_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_id in number
    ) return t_customer_event_tickets pipelined
    is
        t_rows t_customer_event_tickets;
        rc sys_refcursor;
    begin
            
        show_customer_event_tickets_by_email(p_customer_email, p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_tickets_by_email;

    function show_customer_event_series_tickets
    (
        p_customer_id in number,
        p_event_series_id in number
    ) return t_customer_event_series_tickets pipelined
    is
        t_rows t_customer_event_series_tickets;
        rc sys_refcursor;
    begin
    
        show_customer_event_series_tickets(p_customer_id, p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_series_tickets;

    function show_customer_event_series_tickets_by_email
    (
        p_customer_email in varchar2,
        p_event_series_id in number
    ) return t_customer_event_series_tickets pipelined
    is
        t_rows t_customer_event_series_tickets;
        rc sys_refcursor;
    begin
        
        show_customer_event_series_tickets_by_email(p_customer_email, p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_series_tickets_by_email;

begin
    initialize;
end customer_api;