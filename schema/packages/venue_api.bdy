create or replace package body venue_api 
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
        error_api.log_error(
            p_error_message => p_error_message, 
            p_error_code => p_error_code, 
            p_locale => 'venue_api.' || p_locale);
   
    end log_error;

    function get_venue_id
    (
        p_venue_name in varchar2
    ) return number
    is
        l_venue_id number;
    begin
        
        select v.venue_id
        into l_venue_id
        from venues v
        where upper(v.venue_name) = upper(p_venue_name);
        
        return l_venue_id;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode,'get_venue_id');
            raise;                                
    end get_venue_id;

    procedure validate_venue_record
    (
        p_venue in venues%rowtype
    )
    is
    begin

        case
            when p_venue.venue_name is null then
                raise_application_error(-20100, 'Missing venue name, cannot create or update venue');
            when p_venue.organizer_name is null then
                raise_application_error(-20100, 'Missing organizer name, cannot create or update venue');         
            when p_venue.organizer_email is null then
                raise_application_error(-20100, 'Missing organizer email, cannot create or update venue');
            when p_venue.max_event_capacity is null then
                raise_application_error(-20100, 'Missing event capacity, cannot create or update venue');      
            else
                --record is valid
                null;
        end case;
        
    end validate_venue_record;

    procedure create_venue
    (
        p_venue_name in varchar2,
        p_organizer_name in varchar2,
        p_organizer_email in varchar2,   
        p_max_event_capacity in number,
        p_venue_id out number
    )
    is
        r_venue venues%rowtype;
    begin
        r_venue.venue_name := p_venue_name;
        r_venue.organizer_name := p_organizer_name;
        r_venue.organizer_email := p_organizer_email;
        r_venue.max_event_capacity := p_max_event_capacity;
        
        validate_venue_record(p_venue => r_venue);
    
        insert into event_system.venues
        (
            venue_name, 
            organizer_name, 
            organizer_email, 
            max_event_capacity
        )
        values
        (
            r_venue.venue_name, 
            r_venue.organizer_name, 
            r_venue.organizer_email, 
            r_venue.max_event_capacity
        )
        returning venue_id 
        into p_venue_id;
        
        commit;
    
    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_venue');
            raise;
    end create_venue;

    procedure update_venue
    (
        p_venue_id in number,
        p_venue_name in varchar2,
        p_organizer_name in varchar2,
        p_organizer_email in varchar2,   
        p_max_event_capacity in number  
    )
    is
        r_venue venues%rowtype;
    begin
        r_venue.venue_name := p_venue_name;
        r_venue.organizer_name := p_organizer_name;
        r_venue.organizer_email := p_organizer_email;
        r_venue.max_event_capacity := p_max_event_capacity;
        
        validate_venue_record(p_venue => r_venue);
    
        update event_system.venues v
        set
            v.venue_name = r_venue.venue_name,
            v.organizer_name = r_venue.organizer_name,
            v.organizer_email = r_venue.organizer_email,
            v.max_event_capacity = r_venue.max_event_capacity
        where v.venue_id = p_venue_id;
        
        commit;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'update_venue');
            raise;    
    end update_venue;
    
    procedure show_venue
    (
        p_venue_id in number,
        p_info out sys_refcursor
    )
    is
    begin
    
        open p_info for
        select
            v.venue_id
            ,v.venue_name
            ,v.organizer_name
            ,v.organizer_email
            ,v.max_event_capacity
            ,v.events_scheduled
        from event_system.venues_v v
        where v.venue_id = p_venue_id;
    
    end show_venue;

    procedure show_all_venues
    (
        p_venues out sys_refcursor
    )
    is
    begin
    
        open p_venues for
        select
            v.venue_id
            ,v.venue_name
            ,v.organizer_name
            ,v.organizer_email
            ,v.max_event_capacity
            ,v.events_scheduled
        from event_system.venues_v v
        order by v.venue_name;
    
    end show_all_venues;

    procedure show_venue_summary
    (
        p_venue_id in number,
        p_summary out sys_refcursor
    )
    is
    begin
    
        open p_summary for
        select
            vs.venue_id,
            vs.venue_name,
            vs.organizer_name,
            vs.organizer_email,
            vs.max_event_capacity,
            vs.events_scheduled,
            vs.first_event_date,
            vs.last_event_date,
            vs.min_event_tickets,
            vs.max_event_tickets
        from event_system.venues_summary_v vs
        where vs.venue_id = p_venue_id;
    
    end show_venue_summary;

    procedure show_all_venues_summary
    (
        p_venues out sys_refcursor
    )
    is
    begin
    
        open p_venues for
        select
            vs.venue_id,
            vs.venue_name,
            vs.organizer_name,
            vs.organizer_email,
            vs.max_event_capacity,
            vs.events_scheduled,
            vs.first_event_date,
            vs.last_event_date,
            vs.min_event_tickets,
            vs.max_event_tickets
        from event_system.venues_summary_v vs
        order by vs.venue_name;
    
    end show_all_venues_summary;

    --show ticket sales and ticket quantity for each reseller
    --rank resellers by total sales amount
    procedure show_venue_reseller_performance
    (
        p_venue_id in number,
        p_reseller_sales out sys_refcursor
    )
    is
    begin
    
        open p_reseller_sales for
        select
            rp.venue_id,
            rp.venue_name,
            rp.reseller_id,
            rp.reseller_name,
            rp.total_ticket_quantity,
            rp.total_ticket_sales,
            rp.rank_by_sales,
            rp.rank_by_quantity
        from event_system.venue_reseller_performance_v rp
        where rp.venue_id = p_venue_id
        order by
            rp.rank_by_sales, 
            rp.reseller_name;
    
    end show_venue_reseller_performance;

    --show ticket sales and ticket quantity for each reseller
    --rank resellers by total sales amount
    procedure show_event_reseller_performance
    (
        p_event_id in number,
        p_reseller_sales out sys_refcursor
    )
    is
    begin
    
        open p_reseller_sales for
        select
            rp.venue_id,
            rp.venue_name,
            rp.event_id,
            rp.event_name,
            rp.event_date,
            rp.reseller_id,
            rp.reseller_name,
            rp.total_ticket_quantity,
            rp.total_ticket_sales,
            rp.rank_by_sales,
            rp.rank_by_quantity
        from event_system.event_reseller_performance_v rp
        where rp.event_id = p_event_id
        order by
            rp.rank_by_sales, 
            rp.reseller_name;
    
    end show_event_reseller_performance;

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
    )
    is
    begin
    
        open p_commissions for
        select
            rc.reseller_id,
            rc.reseller_name,
            rc.sales_month,
            rc.sales_month_ending,
            rc.event_id,
            rc.event_name,
            rc.total_sales,
            rc.commission_percent,
            rc.total_commission
        from event_system.venue_reseller_commission_v rc
        where 
            rc.venue_id = p_venue_id
            and rc.reseller_id = p_reseller_id
        order by
            rc.sales_month,
            rc.event_name;
    
    end show_venue_reseller_commissions;

    function show_venue
    (
        p_venue_id in venues.venue_id%type
    ) return t_venue_info pipelined
    is
        t_rows t_venue_info;
        rc sys_refcursor;
    begin
    
        show_venue(p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_venue;

    function show_all_venues
    return t_venue_info pipelined
    is
        t_rows t_venue_info;
        rc sys_refcursor;
    begin
    
        show_all_venues(rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_all_venues;

    function show_venue_summary(
        p_venue_id in venues.venue_id%type    
    ) return t_venue_summary pipelined
    is
        t_rows t_venue_summary;
        rc sys_refcursor;
    begin
    
        show_venue_summary(p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_venue_summary;
    
    function show_all_venues_summary
    return t_venue_summary pipelined
    is
        t_rows t_venue_summary;
        rc sys_refcursor;
    begin
    
        show_all_venues_summary(rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_all_venues_summary;

    function show_venue_reseller_performance
    (
        p_venue_id in number
    ) return t_reseller_performance pipelined
    is
        t_rows t_reseller_performance;
        rc sys_refcursor;
    begin
    
        show_venue_reseller_performance(p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row (t_rows(i));
        end loop;
        return;
    
    end show_venue_reseller_performance;

    function show_event_reseller_performance
    (
        p_event_id in number
    ) return t_event_reseller_performance pipelined
    is
        t_rows t_event_reseller_performance;
        rc sys_refcursor;
    begin
       
        show_event_reseller_performance(p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
       
        for i in 1..t_rows.count loop
            pipe row (t_rows(i));
        end loop;
        return;
       
    end show_event_reseller_performance;

    function show_venue_reseller_commissions
    (
        p_venue_id in number,
        p_reseller_id in number
    ) return t_reseller_commissions pipelined
    is
        t_rows t_reseller_commissions;
        rc sys_refcursor;
    begin
    
        show_venue_reseller_commissions(p_venue_id, p_reseller_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;   
        return;
    
    end show_venue_reseller_commissions;

begin
    initialize;
end venue_api;