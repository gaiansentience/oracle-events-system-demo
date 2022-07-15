create or replace package body events_api
as

    g_processing_event_series boolean := false;

    c_ticket_status_issued constant varchar2(20) := 'ISSUED';
    c_ticket_status_reissued constant varchar2(20) := 'REISSUED';
    c_ticket_status_cancelled constant varchar2(20) := 'CANCELLED';
    c_ticket_status_validated constant varchar2(20) := 'VALIDATED';
    c_ticket_status_refunded constant varchar2(20) := 'REFUNDED';

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
            p_locale => 'events_api.' || p_locale);
   
    end log_error;

----reseller api----------------------begin


    function get_reseller_id
    (
        p_reseller_name in varchar2
    ) return number
    is
        l_reseller_id number;
    begin
        
        select r.reseller_id
        into l_reseller_id
        from resellers r
        where upper(r.reseller_name) = upper(p_reseller_name);
        
        return l_reseller_id;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode,'get_reseller_id');
            raise;                        
    end get_reseller_id;
    
    procedure validate_reseller_record
    (
        p_reseller in resellers%rowtype
    )
    is
    begin
        case    
            when p_reseller.reseller_name is null then
                raise_application_error(-20100, 'Missing reseller name, cannot create or update reseller.');
            when p_reseller.reseller_email is null then
                raise_application_error(-20100, 'Missing reseller email, cannot create or update reseller.');
            when p_reseller.commission_percent is null then
                raise_application_error(-20100, 'Missing reseller commission, cannot create or update reseller.');     
            else
                --record is valid
                null;
        end case;

    end validate_reseller_record;
   
    procedure create_reseller
    (
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10,
        p_reseller_id out number
    )
    is
        r_reseller resellers%rowtype;
    begin
        r_reseller.reseller_name := p_reseller_name;
        r_reseller.reseller_email := p_reseller_email;
        r_reseller.commission_percent := p_commission_percent;
        
        validate_reseller_record(r_reseller);
    
        insert into event_system.resellers
        (
            reseller_name,
            reseller_email,
            commission_percent
        )
        values
        (
            r_reseller.reseller_name,
            r_reseller.reseller_email,
            r_reseller.commission_percent
        )
        returning reseller_id 
        into p_reseller_id;
        
        commit;
    
    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_reseller');
            raise;
    end create_reseller;

    procedure update_reseller
    (
        p_reseller_id in number,    
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10    
    )
    is
        r_reseller resellers%rowtype;
    begin
        r_reseller.reseller_name := p_reseller_name;
        r_reseller.reseller_email := p_reseller_email;
        r_reseller.commission_percent := p_commission_percent;
        
        validate_reseller_record(r_reseller);
    
        update event_system.resellers r
        set 
            r.reseller_name = r_reseller.reseller_name,
            r.reseller_email = r_reseller.reseller_email,
            r.commission_percent = r_reseller.commission_percent
        where r.reseller_id = p_reseller_id;
        
        commit;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'update_reseller');
            raise;
    end update_reseller;

    procedure show_reseller
    (
        p_reseller_id in number,
        p_info out sys_refcursor
    )
    is
    begin
    
        open p_info for
        select
            r.reseller_id,
            r.reseller_name,
            r.reseller_email,
            r.commission_percent
        from event_system.resellers_v r
        where r.reseller_id = p_reseller_id;
    
    end show_reseller;

    procedure show_all_resellers
    (
        p_resellers out sys_refcursor
    )
    is
    begin
    
        open p_resellers for
        select
            r.reseller_id,
            r.reseller_name,
            r.reseller_email,
            r.commission_percent
        from event_system.resellers r
        order by r.reseller_name;
    
    end show_all_resellers;

----reseller api----------------------end

----venue api-------------------------begin


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

----venue api-------------------------end

----event setup api-------------------begin

    function get_event_id
    (
        p_venue_id in number,
        p_event_name in varchar2
    ) return number
    is
        l_event_id number;
    begin
        
        select e.event_id
        into l_event_id
        from events e
        where 
            e.venue_id = p_venue_id
            and upper(e.event_name) = upper(p_event_name);
        
        return l_event_id;
    
    exception
        when others then
            log_error(sqlerrm, sqlcode,'get_event_id');
            raise;        
    end get_event_id;

    function get_event_series_id
    (
        p_venue_id in number,
        p_event_name in varchar2
    ) return number
    is
        l_event_series_id number;
    begin
        
        select max(e.event_series_id)
        into l_event_series_id
        from events e
        where 
            e.venue_id = p_venue_id
            and upper(e.event_name) = upper(p_event_name);
        
        return l_event_series_id;
    
    exception
        when others then
            log_error(sqlerrm, sqlcode,'get_event_series_id');
            raise;                
    end get_event_series_id;

    function get_event_series_id
    (
        p_event_id in number
    ) return number
    is
        l_event_series_id number;
    begin
    
        select e.event_series_id
        into l_event_series_id
        from event_system.events e
        where e.event_id = p_event_id;
    
        return l_event_series_id;
    exception
        when others then
            return null;
    end get_event_series_id;
   
   
    procedure verify_venue_event_capacity
    (
        p_venue_id in number,
        p_tickets in number
    )
    is
        v_capacity number;
    begin
    
        select max_event_capacity
        into v_capacity
        from event_system.venues
        where venue_id = p_venue_id;
        
        if p_tickets > v_capacity then
            raise_application_error(-20100, p_tickets || ' exceeds venue capacity of ' || v_capacity);
        end if;
    
    end verify_venue_event_capacity;
  
    procedure verify_venue_event_date_free
    (
        p_venue_id in number,
        p_event_date in date,
        p_updating_event in boolean default false,
        p_update_event_id in number default null
    )
    is
        v_count number;
        v_error_message varchar2(100);
    begin
    
        if p_event_date <= sysdate then
            raise_application_error(-20100, 'Cannot schedule event for current date or past dates');
        end if;

        if not p_updating_event then
        
        select count(*) 
        into v_count
        from event_system.events e 
        where 
            e.venue_id = p_venue_id 
            and trunc(e.event_date) = trunc(p_event_date);

        else

        select count(*) 
        into v_count
        from event_system.events e 
        where 
            e.venue_id = p_venue_id 
            and e.event_id <> p_update_event_id
            and trunc(e.event_date) = trunc(p_event_date);
        
        end if;
        
        if v_count > 0 then
            v_error_message := 'Cannot schedule event.  Venue already has event for ' || to_char(p_event_date,'MM/DD/YYYY');
            raise_application_error(-20100, v_error_message);
        end if;

    end verify_venue_event_date_free;

    procedure create_event
    (
        p_event in out events%rowtype
    )
    is
    begin

        verify_venue_event_capacity(p_event.venue_id, p_event.tickets_available);
        
        verify_venue_event_date_free(p_event.venue_id, p_event.event_date);
        
        insert into event_system.events
            (
            venue_id,
            event_name,
            event_date,
            tickets_available,
            event_series_id
            )
        values
            (
            p_event.venue_id,
            p_event.event_name,
            p_event.event_date,
            p_event.tickets_available,
            p_event.event_series_id
            )
        returning event_id 
        into p_event.event_id;
        
        commit;

    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_event');
            raise;
    end create_event;

    procedure create_event
    (
        p_venue_id in number,   
        p_event_name in varchar2,
        p_event_date in date,
        p_tickets_available in number,
        p_event_id out number
    )
    is
        r_event events%rowtype;
    begin
    
        r_event.venue_id := p_venue_id;
        r_event.event_name := p_event_name;
        r_event.event_date := p_event_date;
        r_event.tickets_available := p_tickets_available;
        r_event.event_series_id := null;
    
        create_event(p_event => r_event);
        
        p_event_id := r_event.event_id;
                
    end create_event;
    
    function get_event_venue_id
    (
        p_event_id in number
    ) return number
    is
        l_venue_id number;
    begin
        
        select e.venue_id
        into l_venue_id
        from event_system.events e
        where e.event_id = p_event_id;
        
        return l_venue_id;
        
    end get_event_venue_id;
    
    procedure update_event
    (
        p_event_id in number,   
        p_event_name in varchar2,
        p_event_date in date,
        p_tickets_available in number
    )
    is
        l_venue_id number;
        l_event_tickets_available number;
        l_all_ticket_sales number;
        l_venue_ticket_sales number;
        l_ticket_assignments number;
        l_assignments_and_venue_sales number;
        l_ticket_groups number;
        l_downsize_message varchar2(1000);
    begin
    
        l_venue_id := get_event_venue_id(p_event_id => p_event_id);
        
        verify_venue_event_date_free(
            p_venue_id => l_venue_id, 
            p_event_date => p_event_date,
            p_updating_event => true,
            p_update_event_id => p_event_id);
        
        verify_venue_event_capacity(p_venue_id => l_venue_id, p_tickets => p_tickets_available);
        
        select e.tickets_available into l_event_tickets_available
        from event_system.events e
        where e.event_id = p_event_id;
        
        if l_event_tickets_available > p_tickets_available then
            --downsizing event requested, check sales, assignments and groups
            select sum(ts.ticket_quantity)
            into l_all_ticket_sales
            from 
                event_system.ticket_groups tg
                join event_system.ticket_sales ts
                    on tg.ticket_group_id = ts.ticket_group_id
            where tg.event_id = p_event_id;
            
            select sum(ta.tickets_assigned)
            into l_ticket_assignments
            from 
                event_system.ticket_groups tg
                join event_system.ticket_assignments ta
                    on tg.ticket_group_id = ta.ticket_group_id
            where tg.event_id = p_event_id;
            
            --need to consider direct venue sales as a virtual assignment
            select sum(ts.ticket_quantity)
            into l_venue_ticket_sales
            from 
                event_system.ticket_groups tg
                join event_system.ticket_sales ts
                    on tg.ticket_group_id = ts.ticket_group_id
            where 
                tg.event_id = p_event_id
                and ts.reseller_id is null;
            
            l_assignments_and_venue_sales := l_ticket_assignments + l_venue_ticket_sales;
            
            select sum(tg.tickets_available)
            into l_ticket_groups
            from event_system.ticket_groups tg
            where tg.event_id = p_event_id;
            
            l_downsize_message := 'Cannot downsize event to ' || p_tickets_available || '.  ';
            case
                when l_all_ticket_sales > p_tickets_available then
                    raise_application_error(-20100, l_downsize_message || l_all_ticket_sales || ' tickets are already sold.');
                when l_assignments_and_venue_sales > p_tickets_available then
                    raise_application_error(-20100, l_downsize_message || l_ticket_assignments || ' tickets are assigned to resellers and ' || l_venue_ticket_sales || ' have been sold by venue.  Must change assignments first.');
                when l_ticket_groups > p_tickets_available then
                    raise_application_error(-20100, l_downsize_message || l_ticket_groups || ' tickets are defined in groups.  Must change ticket groups first.');
                else
                    --downsizing will not create issues
                    null;
            end case;
                
        end if;
        
        --passed all validation tests for the requested update
        update event_system.events e
        set
            e.event_name = p_event_name
            ,e.event_date = p_event_date
            ,e.tickets_available = p_tickets_available
        where e.event_id = p_event_id;
        
        commit;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode,'update_event');
            raise;    
    end update_event;

    procedure show_event
    (
        p_event_id in number,
        p_event_info out sys_refcursor
    )
    is
    begin
    
        open p_event_info for
        select
            ve.venue_id
            ,ve.venue_name
            ,ve.organizer_name
            ,ve.organizer_email
            ,ve.event_id
            ,ve.event_series_id
            ,ve.event_name
            ,ve.event_date
            ,ve.tickets_available
            ,ve.tickets_remaining
        from event_system.events_v ve
        where ve.event_id = p_event_id;

    end show_event;

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
    )
    is
    
        cursor d is
            with date_range as
            (
                select p_event_start_date + level - 1 as the_date
                from dual 
                connect by level <= (p_event_end_date - p_event_start_date)
            )
            select the_date
            from date_range
            where to_char(the_date,'fmDAY', 'NLS_DATE_LANGUAGE=American') = upper(p_event_day)
            order by the_date;
        
        i_event number := 0;
        r_series_event events_api.r_series_event;
        l_event events%rowtype;
        v_success_count number := 0;
        v_conflict_count number := 0;
        v_conflict_dates varchar2(32000);
        v_status varchar2(4000);
        v_success_dates varchar2(32000);
    begin
        l_event.venue_id := p_venue_id;
        l_event.event_name := p_event_name;
        l_event.tickets_available := p_tickets_available;
        l_event.event_series_id := event_series_id_seq.nextval;
        
        for r in d loop
            i_event := i_event + 1;
            r_series_event.event_date := r.the_date;
            l_event.event_date := r.the_date;
            begin
                create_event(p_event => l_event);
                
                r_series_event.event_id := l_event.event_id;    
                r_series_event.status_code := 'SUCCESS';
                r_series_event.status_message := 'Event Created';
                v_success_count := v_success_count + 1;
                v_success_dates := v_success_dates || to_char(r.the_date,'MM/DD/YYYY') || ', ';
            exception
                when others then
                    r_series_event.status_code := 'ERROR';
                    r_series_event.status_message := sqlerrm;
                    r_series_event.event_id := 0;
                    log_error(sqlerrm, sqlcode, 'create_weekly_event:  adding weekly event');
                    v_conflict_count := v_conflict_count + 1;
                    --v_conflict_dates := v_conflict_dates || to_char(r.the_date,'MM/DD/YYYY') || ', ';
            end;
            
            p_status_details(i_event) := r_series_event;

        end loop;

        v_success_dates := rtrim(v_success_dates,', ');
        --v_conflict_dates := rtrim(v_conflict_dates,', ');
        p_status_code := case when v_conflict_count > 0 then 'ERRORS' else 'SUCCESS' end;
        v_status := v_success_count || ' events for (' || p_event_name || ') created successfully. ';
        v_status := v_status || v_conflict_count || ' events could not be created because of conflicts with existing events.';
        --v_status := v_status || '  Conflicting dates are: ' || v_conflict_dates || '.';
        p_status_message := v_status;
        p_event_series_id := case when v_success_count > 0 then l_event.event_series_id else 0 end ;

    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_weekly_event');
            raise;
    end create_weekly_event;

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
    )
    is
        t_status_details events_api.t_series_event;
        v_status_code varchar2(20);
        v_status_message varchar2(4000);
    begin

        create_weekly_event(
            p_venue_id => p_venue_id,   
            p_event_name => p_event_name,
            p_event_start_date => p_event_start_date,
            p_event_end_date => p_event_end_date,
            p_event_day => p_event_day,
            p_tickets_available => p_tickets_available,
            p_event_series_id => p_event_series_id,        
            p_status_details => t_status_details,
            p_status_code => v_status_code,
            p_status_message => v_status_message);
            
            p_status := v_status_code || ' - ' || v_status_message;
            
    end create_weekly_event;
    
    function get_event_series_venue_id
    (
        p_event_series_id in number
    ) return number
    is
        l_venue_id number;
    begin
        
        select e.venue_id
        into l_venue_id
        from event_system.events e
        where e.event_series_id = p_event_series_id
        fetch first 1 row only;
        
        return l_venue_id;
        
    end get_event_series_venue_id;
    
    procedure update_event_series
    (
        p_event_series_id in number,   
        p_event_name in varchar2,
        p_tickets_available in number
    )
    is
        l_venue_id number;
        l_max_event_tickets_available number;
        l_max_event_tickets_sold number;
        l_max_event_assigned_and_venue_sales number;
        l_max_event_ticket_groups number;
        l_downsize_message varchar2(1000);
    begin
    
        l_venue_id := get_event_series_venue_id(p_event_series_id => p_event_series_id);
        verify_venue_event_capacity(p_venue_id => l_venue_id, p_tickets => p_tickets_available);
        
        --validate change in tickets available for all events in series that have not occurred
        select max(e.tickets_available)
        into l_max_event_tickets_available
        from events e
        where 
            e.event_series_id = p_event_series_id
            and e.event_date > sysdate;
        
        if p_tickets_available < l_max_event_tickets_available then
            --requested downsizing of events in series, check sales, assignments and groups
            --only verify events in series that have not already happened
            
            --validate requested size against max tickets sold per event
            with event_ticket_sales as
            (
                select 
                    e.event_series_id
                    ,e.event_id
                    ,sum(ts.ticket_quantity) as ticket_sales
                from
                    events e
                    join ticket_groups tg
                    on e.event_id = tg.event_id
                    join ticket_sales ts
                    on tg.ticket_group_id = ts.ticket_group_id
                where e.event_date > sysdate
                group by
                    e.event_series_id
                    ,e.event_id
            )
            select max(es.ticket_sales)
            into l_max_event_tickets_sold
            from event_ticket_sales es
            where es.event_series_id = p_event_series_id;            
            
            --validate requested size against max assignments per event
            --consider direct venue sales as a virtual assignment
            with event_assignments as
            (
                select 
                    e.event_series_id
                    ,e.event_id
                    ,sum(ta.tickets_assigned) as tickets_assigned
                from
                    events e
                    join ticket_groups tg
                    on e.event_id = tg.event_id
                    join ticket_assignments ta
                    on tg.ticket_group_id = ta.ticket_group_id
                where e.event_date > sysdate
                group by
                    e.event_series_id
                    ,e.event_id
            ), assigned_and_venue_sales as
            (
                select 
                    ea.event_series_id,
                    ea.event_id,
                    ea.tickets_assigned 
                    + nvl(
                        (select sum(ts.ticket_quantity)
                        from 
                            event_system.ticket_groups tg
                            join event_system.ticket_sales ts
                                on tg.ticket_group_id = ts.ticket_group_id
                        where 
                            tg.event_id = ea.event_id 
                            and ts.reseller_id is null)
                    , 0) as assigned_plus_venue_sales
                from event_assignments ea
            )
            select max(ea.assigned_plus_venue_sales) 
            into l_max_event_assigned_and_venue_sales 
            from assigned_and_venue_sales ea
            where ea.event_series_id = p_event_series_id;            
            
            --validate requested size against max ticket groups defined per event
            with event_ticket_groups as
            (
                select 
                    e.event_series_id
                    ,e.event_id
                    ,sum(tg.tickets_available) as tickets_available
                from
                    events e
                    join ticket_groups tg
                    on e.event_id = tg.event_id
                where e.event_date > sysdate
                group by
                    e.event_series_id
                    ,e.event_id
            )
            select max(ea.tickets_available) 
            into l_max_event_ticket_groups
            from event_ticket_groups ea
            where ea.event_series_id = p_event_series_id;            
            
            l_downsize_message := 'Cannot downsize events in series to ' || p_tickets_available || '.  Modify events individually or change assignments and groups.  ';
            case
                when l_max_event_tickets_sold > p_tickets_available then
                    raise_application_error(-20100, l_downsize_message || 'Some events have already sold ' || l_max_event_tickets_sold || ' tickets.');
                when l_max_event_assigned_and_venue_sales > p_tickets_available then
                    raise_application_error(-20100, l_downsize_message || 'Some events have reseller assignments and venue direct sales of ' || l_max_event_assigned_and_venue_sales || ' tickets.');
                when l_max_event_ticket_groups > p_tickets_available then
                    raise_application_error(-20100, l_downsize_message || 'Some events have ticket groups defined as ' || l_max_event_ticket_groups || '.  Modify ticket groups first.');
                else
                    --all events in the series can accept the downsizing without changes to setup
                    null;
            end case;
            
        end if;
        
        update event_system.events e
        set
            e.event_name = p_event_name
            ,e.tickets_available = p_tickets_available
        where 
            e.event_series_id = p_event_series_id
            and e.event_date > sysdate;
        
        commit;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode,'update_event_series');
            raise;    
    end update_event_series;

    procedure show_event_series
    (
        p_event_series_id in number,
        p_series_events out sys_refcursor
    )
    is
    begin
    
        open p_series_events for
        select
            ve.venue_id
            ,ve.venue_name
            ,ve.event_series_id
            ,ve.event_series_name
            ,ve.events_in_series
            ,ve.tickets_available_all_events
            ,ve.tickets_remaining_all_events
            ,ve.events_sold_out
            ,ve.events_still_available
            ,ve.event_id
            ,ve.event_name
            ,ve.event_date
            ,ve.tickets_available
            ,ve.tickets_remaining
        from event_system.event_series_v ve
        where ve.event_series_id = p_event_series_id
        order by ve.event_date;
        
    end show_event_series;
    

    --show all planned events for the venue
    --include total ticket sales to date
    procedure show_all_events
    (
        p_venue_id in number,
        p_events out sys_refcursor
    )
    is
    begin
    
        open p_events for
        select
            ve.venue_id
            ,ve.venue_name
            ,ve.organizer_name
            ,ve.organizer_email
            ,ve.event_id
            ,ve.event_series_id
            ,ve.event_name
            ,ve.event_date
            ,ve.tickets_available
            ,ve.tickets_remaining
        from event_system.venue_events_v ve
        where ve.venue_id = p_venue_id
        order by ve.event_date;
    
    end show_all_events;

    --show all planned events that are part of an event series for the venue
    --include total ticket sales to date
    procedure show_all_event_series
    (
        p_venue_id in number,
        p_events out sys_refcursor
    )
    is
    begin
    
        open p_events for
        select
            ve.venue_id
            ,ve.venue_name
            ,ve.organizer_name
            ,ve.organizer_email
            ,ve.event_id
            ,ve.event_series_id
            ,ve.event_name
            ,ve.event_date
            ,ve.tickets_available
            ,ve.tickets_remaining
        from event_system.venue_event_series_v ve
        where ve.venue_id = p_venue_id
        order by ve.event_date;
    
    end show_all_event_series;

    --show currently defined ticket groups for an event
    --for each group include quantity and price
    --also include an UNDEFINED group to show how many more tickets could be assigned to groups
    --the quantity of the UNDEFINED group is event capacity - sum of all current groups
    procedure show_ticket_groups
    (
        p_event_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin
    
        open p_ticket_groups for
        select
            etg.event_id
            ,etg.event_name
            ,etg.ticket_group_id
            ,etg.price_category
            ,etg.price
            ,etg.tickets_available
            ,etg.currently_assigned
            ,etg.sold_by_venue
        from
            event_system.event_ticket_groups_v etg
        where 
            etg.event_id = p_event_id
        order by
            etg.price_category;
    
    end show_ticket_groups;

    procedure show_ticket_groups_event_series
    (
        p_event_series_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin
    
        open p_ticket_groups for
        select
            etg.event_series_id
            ,etg.event_name
            ,etg.price_category
            ,etg.price
            ,etg.tickets_available
            ,etg.currently_assigned
            ,etg.sold_by_venue
        from
            event_system.event_series_ticket_groups_v etg
        where 
            etg.event_series_id = p_event_series_id
        order by
            etg.price_category;
    
    end show_ticket_groups_event_series;

    procedure ticket_group_available
    (
        p_event_id in number,
        p_price_category in varchar2,
        p_group_tickets in number
    )
    is
        v_event_tickets number;
        v_other_groups_tickets number;
        v_remaining_tickets number;
        v_reseller_assignments number;
        v_direct_venue_sales number;
        v_group_minimum number;
        v_message varchar2(1000);
    begin

        select e.tickets_available
        into v_event_tickets
        from event_system.events e
        where e.event_id = p_event_id;
        
        select nvl(sum(etg.tickets_available),0) as tickets_available
        into v_other_groups_tickets
        from event_system.event_ticket_groups_v etg
        where etg.price_category <> 'UNDEFINED'
            and etg.event_id = p_event_id 
            and price_category <> upper(p_price_category);
            
        select
            nvl(sum(etg.currently_assigned),0) as currently_assigned
            ,nvl(sum(etg.sold_by_venue),0) as sold_by_venue
        into
            v_reseller_assignments
            ,v_direct_venue_sales
        from event_system.event_ticket_groups_v etg
        where 
            etg.event_id = p_event_id 
            and price_category = upper(p_price_category);            
        
        v_remaining_tickets := v_event_tickets - v_other_groups_tickets;
        v_group_minimum := v_reseller_assignments + v_direct_venue_sales;

        if v_remaining_tickets < p_group_tickets then
            v_message := 'Cannot create ' || upper(p_price_category) || '  with ' || p_group_tickets 
                || ' tickets.  Only ' || v_remaining_tickets || ' are available.';
            raise_application_error(-20100, v_message);
        elsif p_group_tickets < v_group_minimum then
            v_message := 'Cannot set ' || upper(p_price_category) || ' to ' || p_group_tickets 
                || ' tickets.  Current reseller assignments and direct venue sales are ' || v_group_minimum;
            raise_application_error(-20100, v_message);
        end if;
        
    end ticket_group_available;

    procedure ticket_group_available_series
    (
        p_event_series_id in number,
        p_price_category in varchar2,
        p_group_tickets in number
    )
    is
        v_event_tickets number;
        v_other_groups_tickets number;
        v_remaining_tickets number;
        v_reseller_assignments number;
        v_direct_venue_sales number;
        v_group_minimum number;
        v_message varchar2(1000);
    begin
        --limit all groups to the smallest event in the series
        select min(e.tickets_available)
        into v_event_tickets
        from event_system.events e
        where e.event_series_id = p_event_series_id;

        --use largest tickets available of any event ticket group in the series to represent each ticket group            
        select nvl(sum(sg.tickets_available), 0)
        into v_other_groups_tickets
        from event_series_ticket_groups_v sg
        where 
            sg.event_series_id = p_event_series_id 
            and sg.price_category <> 'UNDEFINED'
            and sg.price_category <> upper(p_price_category);
            
            
        --largest assignment of event group to resellers to represent the ticket group in the series
        --group by event and ticket group get the sum of assignments
        --then take the max of this sum to represent currently assigned for the group in the series
        --venue sales for the group in the series are the max sum of sales per event in this ticket group                    
        select
            nvl(max(sg.currently_assigned), 0)
            ,nvl(max(sg.sold_by_venue),0) as sold_by_venue
        into 
            v_reseller_assignments,
            v_direct_venue_sales
        from event_series_ticket_groups_v sg
        where 
            sg.event_series_id = p_event_series_id 
            and sg.price_category = upper(p_price_category);
            
        v_remaining_tickets := v_event_tickets - v_other_groups_tickets;
        v_group_minimum := v_reseller_assignments + v_direct_venue_sales;
 
        if v_remaining_tickets < p_group_tickets then
            v_message := 'Cannot create ' || upper(p_price_category) || '  with ' || p_group_tickets 
                || ' tickets.  Only ' || v_remaining_tickets || ' are available.';
            raise_application_error(-20100, v_message);
        elsif p_group_tickets < v_group_minimum then
            v_message := 'Cannot set ' || upper(p_price_category) || ' to ' || p_group_tickets 
                || ' tickets.  Current reseller assignments and direct venue sales are ' || v_group_minimum;
            raise_application_error(-20100, v_message);
        end if;
        
    end ticket_group_available_series;

    function ticket_group_exists
    (
        p_event_id in number,
        p_price_category in varchar2
    ) return boolean
    is
        v_count number;
    begin
    
        select count(*) 
        into v_count
        from event_system.ticket_groups tg
        where 
            tg.event_id = p_event_id
            and tg.price_category = upper(p_price_category);
        
        return (v_count > 0);
    
    end ticket_group_exists;
   
    function get_ticket_group_category
    (
        p_ticket_group_id in number
    ) return varchar2
    is
        v_price_category ticket_groups.price_category%type;
    begin
    
        select tg.price_category
        into v_price_category
        from event_system.ticket_groups tg
        where tg.ticket_group_id = p_ticket_group_id;
        
        return v_price_category;
    
    exception
        when no_data_found then
            return 'Ticket category not found';
    end get_ticket_group_category;
        
    function get_ticket_group_event_series_id
    (
        p_ticket_group_id in number
    ) return number
    is
        l_event_series_id number;
    begin
        
        select e.event_series_id
        into l_event_series_id
        from
            event_system.events e
            join event_system.ticket_groups tg
                on e.event_id = tg.event_id
        where tg.ticket_group_id = p_ticket_group_id;
    
        return l_event_series_id;
    exception
        when others then
            return null;
    end get_ticket_group_event_series_id;
    
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
    )
    is
        l_event_series_id number;
    begin
        
        l_event_series_id := get_event_series_id(p_event_id);
        case
            when g_processing_event_series and l_event_series_id is null then
                raise_application_error(-20100, 'Event is not part of a series, cannot use event series methods');
            when not g_processing_event_series and l_event_series_id is not null then
                null;
                --leave this commented to allow customizing individual events in a series
                --raise_application_error(-20100, 'Event is part of a series, must use event series methods');
            else
                null;
                --not processing event series and event series id is null
                --or processing event series and event series id is not null
        end case;
        
        ticket_group_available(p_event_id, p_price_category, p_tickets);
        
        if not ticket_group_exists(p_event_id, p_price_category) then
        
            insert into event_system.ticket_groups
            (
                event_id,
                price_category,
                price,
                tickets_available
            )
            values
            (
                p_event_id,
                upper(p_price_category),
                p_price,
                p_tickets
            )
            returning ticket_group_id 
            into p_ticket_group_id;
        
        else
        
            update event_system.ticket_groups
            set 
                price = p_price,
                tickets_available = p_tickets
            where
                event_id = p_event_id
                and price_category = upper(p_price_category)
            returning ticket_group_id 
            into p_ticket_group_id;
        
        end if;
        
        commit;

    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_ticket_group');
            raise;
    end create_ticket_group;
    
    --cre ate a price category ticket group for all events in the event series
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
    )
    is
        cursor c is
            select e.event_id
            from events e
            where 
                e.event_series_id = p_event_series_id;
        v_ticket_group_id number;
        v_error_count number := 0;
        v_success_count number := 0;
    begin
    
        g_processing_event_series := true;
        
        --validate the ticket group for all events in the series
        ticket_group_available_series(
            p_event_series_id => p_event_series_id,
            p_price_category => p_price_category,
            p_group_tickets => p_tickets);
        
        for r in c loop
        
            begin

                create_ticket_group(
                    p_event_id => r.event_id,
                    p_price_category => p_price_category,
                    p_price => p_price,
                    p_tickets => p_tickets,
                    p_ticket_group_id => v_ticket_group_id);
                    
                v_success_count := v_success_count + 1;
                
            exception
                when others then
                    v_error_count := v_error_count + 1;
            end;
        
        end loop;
        
        if v_error_count = 0 then
            p_status_code := 'SUCCESS';
            p_status_message := 'Ticket group (' || upper(p_price_category) || ') created for ' || v_success_count || ' events in series';    
        else
            p_status_code := 'ERRORS';
            p_status_message := case when v_success_count > 0 then 'Ticket group (' || upper(p_price_category) || ') created for ' || v_success_count || ' events in series.  ' end
                || v_error_count || ' errors encountered, ticket group (' || upper(p_price_category) || ') not created for these events.';
        end if;
        
        g_processing_event_series := false;
    exception
        when others then
            g_processing_event_series := false;
            log_error(sqlerrm, sqlcode,'create_ticket_group_event_series');
            raise;
    end create_ticket_group_event_series;
    
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
    )
    is
    begin
    
        open p_ticket_groups for
        select
            ra.event_id,
            ra.ticket_group_id,
            ra.price_category,
            ra.tickets_in_group,
            ra.reseller_id,
            ra.reseller_name,   
            ra.assigned_to_others,
            ra.tickets_assigned,
            ra.max_available,
            ra.min_assignment,
            ra.sold_by_reseller,
            ra.sold_by_venue
        from 
            event_system.event_ticket_assignment_v ra
        where 
            ra.event_id = p_event_id 
            and ra.reseller_id = p_reseller_id;
    
    end show_ticket_assignments;

    procedure show_ticket_assignments_event_series
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin
    
        open p_ticket_groups for
        select
            ra.event_series_id,
            ra.price_category,
            ra.tickets_in_group,
            ra.reseller_id,
            ra.reseller_name,   
            ra.assigned_to_others,
            ra.tickets_assigned,
            ra.max_available,
            ra.min_assignment,
            ra.sold_by_reseller,
            ra.sold_by_venue
        from 
            event_system.event_series_ticket_assignment_v ra
        where 
            ra.event_series_id = p_event_series_id 
            and ra.reseller_id = p_reseller_id;
    
    end show_ticket_assignments_event_series;

    procedure verify_ticket_assignment
    (
        p_reseller_id in number,
        p_ticket_group_id in number,
        p_number_tickets in number
    )
    is
        v_total_group_tickets number;
        v_price_category ticket_groups.price_category%type;
        v_assigned_others number;
        v_venue_direct_sales number;
        v_reseller_sales number;
        v_available_tickets number;
        v_message varchar2(100);
    begin

        select 
            tg.tickets_available, 
            tg.price_category
        into 
            v_total_group_tickets, 
            v_price_category
        from event_system.ticket_groups tg 
        where tg.ticket_group_id = p_ticket_group_id;
        
        select nvl(sum(ta.tickets_assigned),0) 
        into v_assigned_others
        from event_system.ticket_assignments ta 
        where 
            ta.ticket_group_id = p_ticket_group_id 
            and ta.reseller_id <> p_reseller_id;
        
        select nvl(sum(ts.ticket_quantity),0) 
        into v_venue_direct_sales
        from event_system.ticket_sales ts 
        where 
            ts.ticket_group_id = p_ticket_group_id 
            and ts.reseller_id is null;
        
        select nvl(sum(ts.ticket_quantity),0) 
        into v_reseller_sales
        from event_system.ticket_sales ts 
        where 
            ts.ticket_group_id = p_ticket_group_id 
            and ts.reseller_id = p_reseller_id;
        
        v_available_tickets := v_total_group_tickets - (v_assigned_others + v_venue_direct_sales);  

        if v_available_tickets < p_number_tickets then
            v_message := 'Cannot assign ' || p_number_tickets || ' tickets for  ' || v_price_category 
                || ' to reseller, maximum available are ' || v_available_tickets;
            raise_application_error(-20100, v_message);
        elsif v_reseller_sales > p_number_tickets then
            v_message := 'Cannot set ' || v_price_category || ' to ' || p_number_tickets 
                || ' tickets for reseller, ' || v_reseller_sales || ' tickets already sold by reseller';
            raise_application_error(-20100, v_message);
        end if;

    end verify_ticket_assignment;

    function ticket_assignment_exists
    (
        p_reseller_id in number,
        p_ticket_group_id in number
    ) return boolean
    is
        v_count number;
    begin
    
        select count(*) 
        into v_count
        from event_system.ticket_assignments ta
        where 
            ta.reseller_id = p_reseller_id
            and ta.ticket_group_id = p_ticket_group_id;
        
        return (v_count > 0);
    
    end ticket_assignment_exists;

    --assign a group of tickets in a price category to a reseller
    --if the reseller already has that category assigned, update the number of tickets
    --raise an error if the ticket group doesnt have that many tickets available
    procedure create_ticket_assignment
    (
        p_reseller_id in number,
        p_ticket_group_id in number,
        p_number_tickets in number,
        p_ticket_assignment_id out number
    )
    is
        l_event_series_id number;
    begin
    
        l_event_series_id := get_ticket_group_event_series_id(p_ticket_group_id);

        case
            when g_processing_event_series and l_event_series_id is null then
                raise_application_error(-20100, 'Event is not part of a series, cannot use event series methods');
            when not g_processing_event_series and l_event_series_id is not null then
                null;
                --leave this commented to allow customizing individual events in a series
                --raise_application_error(-20100, 'Event is part of a series, must use event series methods');
            else
                null;
                --not processing event series and event series id is null
                --or processing event series and event series id is not null
        end case;

        verify_ticket_assignment(p_reseller_id, p_ticket_group_id, p_number_tickets);
        
        if not ticket_assignment_exists(p_reseller_id, p_ticket_group_id) then
        
            insert into event_system.ticket_assignments
            (
                ticket_group_id, 
                reseller_id, 
                tickets_assigned
            )
            values 
            (
                p_ticket_group_id, 
                p_reseller_id, 
                p_number_tickets
            )
            returning ticket_assignment_id 
            into p_ticket_assignment_id;
        
        else
        
            update event_system.ticket_assignments
            set tickets_assigned = p_number_tickets
            where 
                ticket_group_id = p_ticket_group_id
                and reseller_id = p_reseller_id
            returning ticket_assignment_id 
            into p_ticket_assignment_id;
        
        end if;
        
        commit;
  
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'create_ticket_assignment');
            raise;
    end create_ticket_assignment;
    
    procedure create_ticket_assignment_event_series
    (
        p_event_series_id in number,    
        p_reseller_id in number,
        p_price_category in varchar2 default 'General Admission',
        p_number_tickets in number,
        p_status_code out varchar2,
        p_status_message out varchar2
    )
    is
        cursor c is
            select
                tg.ticket_group_id
            from
            event_system.events e
            join event_system.ticket_groups tg
                on e.event_id = tg.event_id
            where
                e.event_series_id = p_event_series_id
                and e.event_date > sysdate
                and tg.price_category = upper(p_price_category);
        l_ticket_assignment_id number;
        l_error_count number := 0;
        l_success_count number := 0;        
    begin
        g_processing_event_series := true;
        --validate assignment for all events in series that have not occurred yet
        --not needed because each assignment will be validated by create_ticket_assignment
        for r in c loop
        
            begin
            
                create_ticket_assignment(
                    p_reseller_id => p_reseller_id,
                    p_ticket_group_id => r.ticket_group_id,
                    p_number_tickets => p_number_tickets,
                    p_ticket_assignment_id => l_ticket_assignment_id);
                    
                l_success_count := l_success_count + 1;               
            exception
                when others then
                    l_error_count := l_error_count + 1;
            end;
        
        end loop;
    
        if l_error_count = 0 then
            p_status_code := 'SUCCESS';
            p_status_message := 'Ticket group (' || upper(p_price_category) || ') assigned to reseller for ' || l_success_count || ' events in series';    
        else
            p_status_code := 'ERRORS';
            p_status_message := case when l_success_count > 0 then 'Ticket group (' || upper(p_price_category) || ') assigned to reseller for ' || l_success_count || ' events in series.  ' end
                || l_error_count || ' errors encountered, ticket group (' || upper(p_price_category) || ') not assigned for these events.';
        end if;
        
        g_processing_event_series := false;
    exception
        when others then
            g_processing_event_series := false;
            log_error(sqlerrm, sqlcode, 'create_ticket_assignment_event_series');
            raise;    
    end create_ticket_assignment_event_series;


----event setup api-------------------end

----event sales api-------------------begin

    
    procedure show_event_ticket_prices
    (
        p_event_id in number,
        p_ticket_prices out sys_refcursor
    )
    is
    begin
    
        open p_ticket_prices for
        select
            tp.venue_id
            ,tp.venue_name
            ,tp.event_id
            ,tp.event_name
            ,tp.event_date
            ,tp.event_tickets_available
            ,tp.ticket_group_id
            ,tp.price_category
            ,tp.price
            ,tp.tickets_available
            ,tp.tickets_sold
            ,tp.tickets_remaining
        from event_ticket_prices_v tp
        where tp.event_id = p_event_id;
    
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_ticket_prices');
            raise;
    end show_event_ticket_prices;

    procedure show_event_series_ticket_prices
    (
        p_event_series_id in number,
        p_ticket_prices out sys_refcursor
    )
    is
    begin
    
        open p_ticket_prices for
        select
            tp.venue_id
            ,tp.venue_name
            ,tp.event_series_id
            ,tp.event_name
            ,tp.events_in_series
            ,tp.first_event_date
            ,tp.last_event_date
            ,tp.event_tickets_available
            ,tp.price_category
            ,tp.price
            ,tp.tickets_available_all_events
            ,tp.tickets_sold_all_events
            ,tp.tickets_remaining_all_events
        from event_series_ticket_prices_v tp
        where tp.event_series_id = p_event_series_id;
    
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_series_ticket_prices');
            raise;
    end show_event_series_ticket_prices;


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
    )
    is
    begin

        open p_ticket_groups for
        select
             venue_id
             ,venue_name
             ,event_id
             ,event_name
             ,event_date
             ,event_tickets_available
             ,price_category
             ,ticket_group_id
             ,price
             ,group_tickets_available
             ,group_tickets_sold
             ,group_tickets_remaining
             ,reseller_id
             ,reseller_name
             ,tickets_available
             ,ticket_status
        from event_system.tickets_available_all_v
        where event_id = p_event_id;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_tickets_available_all');
            raise;
    end show_event_tickets_available_all;

    --show ticket groups assigned to reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by reseller application to show available ticket groups to customers
    procedure show_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin

        open p_ticket_groups for
        select
             venue_id
             ,venue_name
             ,event_id
             ,event_name
             ,event_date
             ,event_tickets_available
             ,price_category
             ,ticket_group_id
             ,price
             ,group_tickets_available
             ,group_tickets_sold
             ,group_tickets_remaining
             ,reseller_id
             ,reseller_name
             ,tickets_available
             ,ticket_status
        from event_system.tickets_available_reseller_v
        where 
            event_id = p_event_id
            and reseller_id = p_reseller_id;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_tickets_available_reseller');
            raise;
    end show_event_tickets_available_reseller;

    --show ticket groups not assigned to any reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by venue organizer application to show tickets available for direct purchase to customers
    procedure show_event_tickets_available_venue
    (
        p_event_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin

        open p_ticket_groups for
        select
             venue_id
             ,venue_name
             ,event_id
             ,event_name
             ,event_date
             ,event_tickets_available
             ,price_category
             ,ticket_group_id
             ,price
             ,group_tickets_available
             ,group_tickets_sold
             ,group_tickets_remaining
             ,reseller_id
             ,reseller_name
             ,tickets_available
             ,ticket_status
        from event_system.tickets_available_venue_v
        where event_id = p_event_id;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_tickets_available_venue');
            raise;
    end show_event_tickets_available_venue;

    procedure show_event_series_tickets_available_all
    (
        p_event_series_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin
    
        open p_ticket_groups for
        select
            venue_id
            ,venue_name
            ,event_series_id
            ,event_name
            ,first_event_date
            ,last_event_date
            ,events_in_series
            ,price_category
            ,price
            ,reseller_id
            ,reseller_name
            ,tickets_available
            ,events_available
            ,events_sold_out
        from event_system.tickets_available_series_all_v
        where event_series_id = p_event_series_id;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_series_tickets_available_all');
            raise;    
    end show_event_series_tickets_available_all;

    --show ticket groups assigned to reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by reseller application to show available ticket groups to customers
    procedure show_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin
    
        open p_ticket_groups for
        select
            venue_id
            ,venue_name
            ,event_series_id
            ,event_name
            ,first_event_date
            ,last_event_date
            ,events_in_series
            ,price_category
            ,price
            ,reseller_id
            ,reseller_name
            ,tickets_available
            ,events_available
            ,events_sold_out
        from event_system.tickets_available_series_reseller_v
        where 
            event_series_id = p_event_series_id
            and reseller_id = p_reseller_id;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_series_tickets_available_reseller');
            raise;    
    end show_event_series_tickets_available_reseller;

    --show ticket groups not assigned to any reseller for this event
    --include tickets available in each group
    --show [number] AVAILABLE or SOLD OUT as status for each group
    --include ticket price for each group
    --used by venue organizer application to show tickets available for direct purchase to customers
    procedure show_event_series_tickets_available_venue
    (
        p_event_series_id in number,
        p_ticket_groups out sys_refcursor
    )
    is
    begin

        open p_ticket_groups for
        select
            venue_id
            ,venue_name
            ,event_series_id
            ,event_name
            ,first_event_date
            ,last_event_date
            ,events_in_series
            ,price_category
            ,price
            ,reseller_id
            ,reseller_name
            ,tickets_available
            ,events_available
            ,events_sold_out
        from event_system.tickets_available_series_venue_v
        where event_series_id = p_event_series_id;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'show_event_series_tickets_available_venue');
            raise;
    end show_event_series_tickets_available_venue;
    
    procedure generate_serialized_tickets
    (
        p_sale in event_system.ticket_sales%rowtype
    )
    is
        l_serialization tickets.serial_code%type;
    begin
        l_serialization := 
            'G' || to_char(p_sale.ticket_group_id)
            || 'C' || to_char(p_sale.customer_id)
            || 'S' || to_char(p_sale.ticket_sales_id)
            || 'D' || to_char(p_sale.sales_date,'YYYYMMDDHH24MISS')
            || 'Q' || to_char(p_sale.ticket_quantity,'fm0999') || 'I';
            
        insert into event_system.tickets
        (
            ticket_sales_id 
            ,serial_code
            ,status
        )
        select 
            p_sale.ticket_sales_id
            ,l_serialization || to_char(level,'fm0999')
            ,c_ticket_status_cancelled
        from dual 
        connect by level <= p_sale.ticket_quantity;
        
    end generate_serialized_tickets;
    
    procedure create_ticket_sale
    (
        p_sale in out event_system.ticket_sales%rowtype
    )
    is
    begin
    
        insert into event_system.ticket_sales
        (
            ticket_group_id, 
            customer_id, 
            reseller_id, 
            ticket_quantity,
            extended_price,
            reseller_commission,
            sales_date
        )
        values 
        (
            p_sale.ticket_group_id,
            p_sale.customer_id,
            p_sale.reseller_id,
            p_sale.ticket_quantity,
            p_sale.extended_price,
            p_sale.reseller_commission,
            p_sale.sales_date
        )
        returning ticket_sales_id 
        into p_sale.ticket_sales_id;
        
        generate_serialized_tickets(p_sale => p_sale);
            
        commit;
    
    exception
        when others then
            rollback;
            log_error(sqlerrm, sqlcode, 'create_ticket_sale');
            raise;
    end create_ticket_sale;
    
    function get_current_ticket_price
    (
        p_ticket_group_id in number
    ) return number
    is
        v_price number;
    begin

        select tg.price 
        into v_price
        from event_system.ticket_groups tg
        where tg.ticket_group_id = p_ticket_group_id;
   
        return v_price;

    exception
        when no_data_found then
            raise_application_error(-20100, 'Ticket Category Not Found, Cannot Verify Pricing');
        when others then
            raise;
    end get_current_ticket_price;

    procedure verify_requested_price
    (
        p_ticket_group_id in number,
        p_requested_price in number,
        p_actual_price out number
    )
    is
        l_error varchar2(1000);
    begin

        p_actual_price := get_current_ticket_price(p_ticket_group_id => p_ticket_group_id);
        if p_actual_price > p_requested_price then
            l_error := 'INVALID TICKET PRICE: CANCELLING TRANSACTION.  Price requested is ' || p_requested_price || ', current price is ' || p_actual_price;
            raise_application_error(-20100, l_error);
        end if;
            
    end verify_requested_price;

    procedure verify_tickets_available_reseller
    (
        p_reseller_id in number,
        p_ticket_group_id in number,
        p_number_tickets in number
    )
    is
        v_available_reseller number;
        v_available_venue number;
        v_available_other_resellers number;
        v_price_category ticket_groups.price_category%type;
        v_message varchar2(1000);
    begin

        with base as
        (
            select
                ticket_group_id
                ,price_category
                ,case when reseller_id is null then tickets_available else 0 end as available_venue
                ,case when reseller_id is not null and reseller_id = p_reseller_id then tickets_available else 0 end as available_reseller
                ,case when reseller_id is not null and reseller_id <> p_reseller_id then tickets_available else 0 end as available_other_resellers
            from tickets_available_all_v
        )
        select
            min(b.price_category) as price_category
            ,sum(b.available_venue) as available_venue
            ,sum(b.available_reseller) as available_reseller
            ,sum(b.available_other_resellers) as available_other_resellers
        into
            v_price_category
            ,v_available_venue
            ,v_available_reseller
            ,v_available_other_resellers
        from base b
        where 
            b.ticket_group_id = p_ticket_group_id;

        if v_available_reseller < p_number_tickets then
            
            v_message := 'Cannot purchase ' || p_number_tickets || ' ' || v_price_category || ' tickets from reseller.  ';
            v_message := v_message || case when v_available_reseller > 0 then to_char(v_available_reseller) else 'No' end || ' tickets are available from reseller.  ';
            
            if (v_available_reseller + v_available_other_resellers + v_available_venue) = 0 then
                v_message := v_message || v_price_category || ' tickets are SOLD OUT.';
            else
                null;
                --open issue:  should reseller purchase error give availability from other resellers or venue?
                v_message := v_message || case when v_available_venue > 0 then to_char(v_available_venue) else 'No' end || ' tickets are available directly from venue.  ';
                v_message := v_message || case when v_available_other_resellers > 0 then to_char(v_available_other_resellers) else 'No' end || ' tickets are available through other resellers.';
            end if;
            
            raise_application_error(-20100,v_message);
        end if;

    exception
        when no_data_found then
            raise_application_error(-20100, 'Tickets in this category are not available from this reseller');
        when others then
            raise;
    end verify_tickets_available_reseller;

    function get_reseller_commission_percent
    (
        p_reseller_id in number
    ) return number
    is
        v_commission_pct number;
    begin
    
        select r.commission_percent
        into v_commission_pct
        from event_system.resellers r
        where r.reseller_id = p_reseller_id;
        
        return v_commission_pct;
    
    end get_reseller_commission_percent;

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
    )
    is
        --l_price number;
        l_commission_pct number;        
        r_sale event_system.ticket_sales%rowtype;
    begin
        verify_tickets_available_reseller(p_reseller_id, p_ticket_group_id, p_number_tickets);
        
        verify_requested_price(p_ticket_group_id => p_ticket_group_id, p_requested_price => p_requested_price, p_actual_price => p_actual_price);

        l_commission_pct := get_reseller_commission_percent(p_reseller_id);
        
        r_sale.ticket_group_id := p_ticket_group_id;
        r_sale.customer_id := p_customer_id;
        r_sale.reseller_id := p_reseller_id;
        r_sale.ticket_quantity := p_number_tickets;
        r_sale.extended_price := p_actual_price * p_number_tickets;
        r_sale.reseller_commission := round(r_sale.extended_price * l_commission_pct, 2);
        r_sale.sales_date := sysdate;

        create_ticket_sale(p_sale => r_sale);
        
        p_ticket_sales_id := r_sale.ticket_sales_id;
        p_extended_price := r_sale.extended_price;

    exception
        when others then
            log_error(sqlerrm, sqlcode,'purchase_tickets_reseller');
            raise;
    end purchase_tickets_reseller;

    procedure verify_tickets_available_venue
    (
        p_ticket_group_id in number,
        p_number_tickets in number
    )
    is
        v_price_category ticket_groups.price_category%type;
        v_available_venue number;
        v_available_resellers number;
        v_message varchar2(1000);
    begin
    
    
        with base as
        (
            select
                ticket_group_id
                ,price_category
                ,case when reseller_id is null then tickets_available else 0 end as available_venue
                ,case when reseller_id is not null then tickets_available else 0 end as available_reseller
            from tickets_available_all_v
        )
        select
            min(b.price_category) as price_category
            ,sum(b.available_venue) as available_venue
            ,sum(b.available_reseller) as available_reseller
        into
            v_price_category
            ,v_available_venue
            ,v_available_resellers
        from base b
        where b.ticket_group_id = p_ticket_group_id;
            
        if v_available_venue < p_number_tickets then
        
            v_message := 'Cannot purchase ' || p_number_tickets || ' ' || v_price_category || ' tickets from venue.  ';
        
            if v_available_venue = 0 and v_available_resellers = 0 then
                v_message := v_message || 'All '||  v_price_category || ' tickets are SOLD OUT.';
            else
                v_message := v_message || case when v_available_venue > 0 then to_char(v_available_venue) else 'No' end 
                || ' tickets are available directly from venue.  '
                || case 
                    when v_available_resellers > 0 then v_available_resellers || ' tickets are available through resellers.' 
                    else 'All resellers are SOLD OUT.' 
                end;
            end if;
            raise_application_error(-20100,v_message);
        end if;

    exception
        when no_data_found then
            raise_application_error(-20100, 'Tickets in this category are not available from the venue');
        when others then
            raise;
    end verify_tickets_available_venue;

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
    )
    is
        r_sale event_system.ticket_sales%rowtype;
    begin
        verify_tickets_available_venue(p_ticket_group_id, p_number_tickets);        

        verify_requested_price(p_ticket_group_id => p_ticket_group_id, p_requested_price => p_requested_price, p_actual_price => p_actual_price);

        r_sale.ticket_group_id := p_ticket_group_id;
        r_sale.customer_id := p_customer_id;
        r_sale.reseller_id := NULL;
        r_sale.ticket_quantity := p_number_tickets;
        r_sale.extended_price := p_actual_price * p_number_tickets;
        r_sale.reseller_commission := 0;
        r_sale.sales_date := sysdate;

        create_ticket_sale(p_sale => r_sale);
        
        p_ticket_sales_id := r_sale.ticket_sales_id;
        p_extended_price := r_sale.extended_price;
            
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'purchase_tickets_venue');
            raise;
    end purchase_tickets_venue;
        
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
    )
    is
        cursor c is
            select tg.ticket_group_id
            from 
                events e 
                join ticket_groups tg
                    on e.event_id = tg.event_id
            where
                e.event_date >= sysdate
                and e.event_series_id = p_event_series_id
                and tg.price_category = upper(p_price_category);

        l_ticket_sales_id number;
        l_actual_price number;
        l_extended_price number;
        l_success_count number := 0;
        l_error_count number := 0;
    begin
        p_total_tickets := 0;
        p_total_purchase := 0;
    
        for r in c loop
        
            begin
            
                purchase_tickets_reseller(
                    p_reseller_id => p_reseller_id,
                    p_ticket_group_id => r.ticket_group_id,
                    p_customer_id => p_customer_id,
                    p_number_tickets => p_number_tickets,
                    p_requested_price => p_requested_price,
                    p_actual_price => l_actual_price,
                    p_extended_price => l_extended_price,
                    p_ticket_sales_id => l_ticket_sales_id);
                    
                p_total_purchase := p_total_purchase + l_extended_price;      
                p_total_tickets := p_total_tickets + p_number_tickets;
                l_success_count := l_success_count + 1;
            exception
                when others then
                    l_error_count := l_error_count + 1;
            end;
        
        end loop;
        
        p_average_price := case when p_total_tickets = 0 then 0 else round(p_total_purchase/p_total_tickets,2) end;        
        p_status_code := case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end;
        p_status_message := case when l_success_count > 0 then 'Tickets purchased for ' || l_success_count || ' events in the series.' end
            || case when l_error_count > 0 then '  Tickets could not be purchased for ' || l_error_count || ' events in the series.' end;
    
    end purchase_tickets_reseller_series;


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
    )
    is
        cursor c is
            select tg.ticket_group_id
            from 
                events e 
                join ticket_groups tg
                    on e.event_id = tg.event_id
            where
                e.event_date >= sysdate
                and e.event_series_id = p_event_series_id
                and tg.price_category = upper(p_price_category);
                
        l_ticket_sales_id number;
        l_actual_price number;
        l_extended_price number;
        l_success_count number := 0;
        l_error_count number := 0;    
    begin
        p_total_tickets := 0;
        p_total_purchase := 0;
    --validate price category and price requested
        for r in c loop
        
            begin
            
                purchase_tickets_venue(
                    p_ticket_group_id => r.ticket_group_id,
                    p_customer_id => p_customer_id,
                    p_number_tickets => p_number_tickets,
                    p_requested_price => p_requested_price,
                    p_actual_price => l_actual_price,
                    p_extended_price => l_extended_price,
                    p_ticket_sales_id => l_ticket_sales_id);
                    
                p_total_purchase := p_total_purchase + l_extended_price;    
                p_total_tickets := p_total_tickets + p_number_tickets;
                l_success_count := l_success_count + 1;
            exception
                when others then
                    l_error_count := l_error_count + 1;
            end;
        
        end loop;
        
        p_average_price := case when p_total_tickets = 0 then 0 else round(p_total_purchase/p_total_tickets,2) end;
        p_status_code := case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end;
        p_status_message := case when l_success_count > 0 then 'Tickets purchased for ' || l_success_count || ' events in the series.' end
            || case when l_error_count > 0 then '  Tickets could not be purchased for ' || l_error_count || ' events in the series.' end;
        
    end purchase_tickets_venue_series;
    
    procedure purchase_tickets_set_error_values(
        p_sqlerrm in varchar2, 
        p_purchase in out r_purchase)
    is
    begin

        p_purchase.status_code := 'ERROR';
        p_purchase.status_message := sqlerrm;
        p_purchase.tickets_purchased := 0;
        p_purchase.purchase_amount := 0;
    
        --for event
        p_purchase.ticket_sales_id := 0;
    
        --for series
        p_purchase.average_price := 0;
    
    end purchase_tickets_set_error_values;
    
    --expose purchase methods to web services with shared record type for parameters
    procedure purchase_tickets_reseller(p_purchase in out r_purchase)
    is
    begin
        purchase_tickets_reseller(
            p_reseller_id => p_purchase.reseller_id,
            p_ticket_group_id => p_purchase.ticket_group_id,
            p_customer_id => p_purchase.customer_id,
            p_number_tickets => p_purchase.tickets_requested,
            p_requested_price => p_purchase.price_requested,
            p_actual_price => p_purchase.actual_price,
            p_extended_price => p_purchase.purchase_amount,                    
            p_ticket_sales_id => p_purchase.ticket_sales_id);

            p_purchase.status_code := 'SUCCESS';
            p_purchase.status_message := 'group tickets purchased';
            p_purchase.tickets_purchased := p_purchase.tickets_requested;
        
    exception
        when others then
            purchase_tickets_set_error_values(p_sqlerrm => sqlerrm, p_purchase => p_purchase);
            raise;
    end purchase_tickets_reseller;

    procedure purchase_tickets_venue(p_purchase in out r_purchase)
    is
    begin
        purchase_tickets_venue(
            p_ticket_group_id => p_purchase.ticket_group_id,
            p_customer_id => p_purchase.customer_id,
            p_number_tickets => p_purchase.tickets_requested,
            p_requested_price => p_purchase.price_requested,
            p_actual_price => p_purchase.actual_price,
            p_extended_price => p_purchase.purchase_amount,                    
            p_ticket_sales_id => p_purchase.ticket_sales_id);
            
            p_purchase.status_code := 'SUCCESS';
            p_purchase.status_message := 'group tickets purchased';
            p_purchase.tickets_purchased := p_purchase.tickets_requested;
            
    exception
        when others then
            purchase_tickets_set_error_values(p_sqlerrm => sqlerrm, p_purchase => p_purchase);
            raise;    
    end purchase_tickets_venue;

    procedure purchase_tickets_reseller_series(p_purchase in out r_purchase)
    is
    begin
    
        purchase_tickets_reseller_series(
            p_reseller_id => p_purchase.reseller_id,
            p_event_series_id => p_purchase.event_series_id,
            p_price_category => p_purchase.price_category,
            p_customer_id => p_purchase.customer_id,
            p_number_tickets => p_purchase.tickets_requested,
            p_requested_price => p_purchase.price_requested,
            p_average_price => p_purchase.average_price,
            p_total_purchase => p_purchase.purchase_amount,    
            p_total_tickets => p_purchase.tickets_purchased,
            p_status_code => p_purchase.status_code,
            p_status_message => p_purchase.status_message);
        
    exception
        when others then
            purchase_tickets_set_error_values(p_sqlerrm => sqlerrm, p_purchase => p_purchase);
            raise;        
    end purchase_tickets_reseller_series;

    procedure purchase_tickets_venue_series(p_purchase in out r_purchase)
    is
    begin
        purchase_tickets_venue_series(
            p_event_series_id => p_purchase.event_series_id,
            p_price_category => p_purchase.price_category,
            p_customer_id => p_purchase.customer_id,
            p_number_tickets => p_purchase.tickets_requested,
            p_requested_price => p_purchase.price_requested,
            p_average_price => p_purchase.average_price,
            p_total_purchase => p_purchase.purchase_amount,    
            p_total_tickets => p_purchase.tickets_purchased,
            p_status_code => p_purchase.status_code,
            p_status_message => p_purchase.status_message);
    
    exception
        when others then
            purchase_tickets_set_error_values(p_sqlerrm => sqlerrm, p_purchase => p_purchase);
            raise;    
    end purchase_tickets_venue_series;
    

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
            ct.customer_id,
            ct.customer_name,
            ct.customer_email,   
            ct.venue_id,
            ct.venue_name,
            ct.event_id,
            ct.event_name,
            ct.event_date,
            ct.event_tickets,
            ct.ticket_group_id,
            ct.price_category,
            ct.ticket_sales_id,
            ct.ticket_quantity,
            ct.sales_date,
            ct.reseller_id,
            ct.reseller_name
        from 
            event_system.customer_event_tickets_v ct
        where 
            ct.event_id = p_event_id 
            and ct.customer_id = p_customer_id
        order by 
            ct.price_category, 
            ct.sales_date;
    
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
            ,ct.event_name
            ,ct.first_event_date
            ,ct.last_event_date
            ,ct.series_tickets
            ,ct.event_id
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
    
    --add methods to print_tickets by ticket_sales_id
    
    
----event sales api-------------------end


----event manage api------------------begin
    
    
    
    function get_ticket_status
    (
        p_serial_code in tickets.serial_code%type
    ) return varchar2
    is
        l_status tickets.status%type;
    begin
    
        select t.status
        into l_status
        from tickets t
        where t.serial_code = p_serial_code;
    
        return l_status;
        
    exception
        when others then
            return null;
    end get_ticket_status;
    
    procedure get_ticket_information
    (
        p_serial_code in tickets.serial_code%type,
        p_status out tickets.status%type,
        p_ticket_group_id out ticket_sales.ticket_group_id%type,
        p_customer_id out ticket_sales.customer_id%type,
        p_event_id out ticket_groups.event_id%type
    )
    is
    begin
    
        select tg.event_id, ts.ticket_group_id, ts.customer_id, t.status
        into p_event_id, p_ticket_group_id, p_customer_id, p_status
        from
            event_system.ticket_groups tg
            join event_system.ticket_sales ts
                on tg.ticket_group_id = ts.ticket_group_id
            join event_system.tickets t
                on ts.ticket_sales_id = t.ticket_sales_id
        where t.serial_code = upper(p_serial_code);
        
    end get_ticket_information;
                               
    procedure ticket_reissue
    (
        p_customer_id in number,
        p_serial_code in varchar2
    )
    is
        l_status tickets.status%type;
        l_customer_id number;
        l_ticket_group_id number;
        l_event_id number;
    begin
        
        get_ticket_information(
            p_serial_code => p_serial_code, 
            p_status => l_status, 
            p_ticket_group_id => l_ticket_group_id, 
            p_customer_id => l_customer_id, 
            p_event_id => l_event_id);
        
        case
            when l_customer_id <> p_customer_id then
                raise_application_error(-20100, 'Tickets can only be reissued to original purchasing customer, cannot reissue.');
            when l_status = c_ticket_status_issued then
        
                update tickets t
                set 
                    t.status = c_ticket_status_reissued, 
                    t.serial_code = t.serial_code || 'R'
                where t.serial_code = upper(p_serial_code);
            
                commit;
        
            when l_status = c_ticket_status_reissued then
                raise_application_error(-20100, 'Ticket has already been reissued, cannot reissue twice.');
            when l_status = c_ticket_status_validated then
                raise_application_error(-20100, 'Ticket has been validated for event entry, cannot reissue.');
            when l_status = c_ticket_status_cancelled then
                raise_application_error(-20100, 'Ticket has been cancelled, cannot reissue.');
            when l_status = c_ticket_status_refunded then
                raise_application_error(-20100, 'Ticket has been refunded, cannot reissue.');                
        end case;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'ticket_reissue');
            raise;
    end ticket_reissue;
    
    procedure ticket_reissue_using_email
    (
        p_customer_email in varchar2,
        p_serial_code in varchar2
    )
    is
        l_customer_id customers.customer_id%type;
    begin
    
        l_customer_id := customer_api.get_customer_id(p_customer_email => p_customer_email);
        
        ticket_reissue(
            p_customer_id => l_customer_id, 
            p_serial_code => p_serial_code);
            
    end ticket_reissue_using_email;    
    
    procedure ticket_reissue_batch
    (
        p_tickets in out t_ticket_reissues
    )
    is
    begin
 
        for i in 1..p_tickets.count loop
            
            begin
            
                ticket_reissue(
                    p_customer_id => p_tickets(i).customer_id, 
                    p_serial_code => p_tickets(i).serial_code);
                    
                p_tickets(i).status := 'SUCCESS';
                p_tickets(i).status_message := 'Reissued ticket serial code.  Previous ticket is unusable for event.  Please reprint ticket.';
            exception
                when others then
                    p_tickets(i).status := 'ERROR';
                    p_tickets(i).status_message := sqlerrm;
            end;
        
        end loop;
    
    end ticket_reissue_batch;

    procedure ticket_reissue_using_email_batch
    (
        p_tickets in out t_ticket_reissues
    )
    is
    begin
 
        for i in 1..p_tickets.count loop
            
            begin
            
                ticket_reissue_using_email(
                    p_customer_email => p_tickets(i).customer_email, 
                    p_serial_code => p_tickets(i).serial_code);
                
                p_tickets(i).status := 'SUCCESS';
                p_tickets(i).status_message := 'Reissued ticket serial code.  Previous ticket is unusable for event.  Please reprint ticket.';
            exception
                when others then
                    p_tickets(i).status := 'ERROR';
                    p_tickets(i).status_message := sqlerrm;
            end;
        
        end loop;
    
    end ticket_reissue_using_email_batch;

    procedure update_ticket_status
    (
        p_serial_code in tickets.serial_code%type,
        p_status in tickets.status%type
    )
    is
    begin
        
        update tickets t
        set t.status = p_status
        where t.serial_code = upper(p_serial_code);
        
    end update_ticket_status;

    procedure ticket_validate
    (
        p_event_id in number,
        p_serial_code in varchar2
    )
    is
        i number;
        l_status tickets.status%type;
        l_event_id number;
        l_ticket_group_id number;
        l_customer_id number;
    begin
    
        select count(*)
        into i
        from
            event_system.ticket_groups tg
            join event_system.ticket_sales ts
                on tg.ticket_group_id = ts.ticket_group_id
            join event_system.tickets t
                on ts.ticket_sales_id = t.ticket_sales_id
            where
                tg.event_id = p_event_id
                and t.serial_code = upper(p_serial_code)
                and t.status in (c_ticket_status_issued, c_ticket_status_reissued);
                
        if i = 1 then
            
            --ticket is valid for the event and has not already been used for entry, update status to validated
            update_ticket_status(p_serial_code => p_serial_code, p_status => c_ticket_status_validated);
            
            commit;
            
        else
        
            get_ticket_information(
                p_serial_code => p_serial_code, 
                p_status => l_status, 
                p_ticket_group_id => l_ticket_group_id, 
                p_customer_id => l_customer_id, 
                p_event_id => l_event_id);
                    
            case
                when l_event_id <> p_event_id then
                    raise_application_error(-20100, 'Ticket is for a different event, cannot validate.');
                when l_status = c_ticket_status_validated then
                    raise_application_error(-20100, 'Ticket has already been used for event entry, cannot revalidate.');
                when l_status = c_ticket_status_cancelled then
                    raise_application_error(-20100, 'Ticket has been cancelled.  Cannot validate.');      
                when l_status = c_ticket_status_refunded then
                    raise_application_error(-20100, 'Ticket has been refunded.  Cannot validate.');                          
                else
                    raise_application_error(-20100, 'Cannot validate ticket with serial code ' || p_serial_code || ' current status is ' || l_status);
            end case;
                
        end if;
    
    exception
        when no_data_found then
            log_error('TICKET SERIAL CODE (' || p_serial_code || ') NOT FOUND FOR EVENT_ID ' || p_event_id, sqlcode, 'ticket_validate');
            raise_application_error(-20100, 'Ticket serial code not found for event, cannot validate');
        when others then
            log_error(sqlerrm, sqlcode, 'ticket_validate');
            raise;
    end ticket_validate;
        
    procedure ticket_verify_validation
    (
        p_event_id in number,    
        p_serial_code in varchar2
    )
    is
        l_status tickets.status%type;
        l_event_id number;
        l_ticket_group_id number;
        l_customer_id number;
    begin
    
        get_ticket_information(
            p_serial_code => p_serial_code, 
            p_status => l_status, 
            p_ticket_group_id => l_ticket_group_id, 
            p_customer_id => l_customer_id, 
            p_event_id => l_event_id);
            
        case
            when l_event_id <> p_event_id then
                raise_application_error(-20100, 'Ticket is for different event, cannot verify.');
            when l_status <> c_ticket_status_validated then
                raise_application_error(-20100, 'Ticket has not been validated for event entry.');
            else
                --SUCCESS: ticket is for the event and has been validated
                null;
        end case;
        
    exception
        when no_data_found then
            log_error('TICKET SERIAL CODE (' || p_serial_code || ') NOT FOUND FOR EVENT_ID ' || p_event_id, sqlcode, 'ticket_verify_validation');
            raise_application_error(-20100, 'Ticket serial code not found for event, cannot verify');            
        when others then
            log_error('SERIAL CODE ' || p_serial_code || ': ' || sqlerrm, sqlcode, 'ticket_verify_validation');
            raise;
    end ticket_verify_validation;
    
    procedure ticket_verify_restricted_access
    (
        p_ticket_group_id in number,
        p_serial_code in varchar2
    )
    is
        i number;
        l_price_category ticket_groups.price_category%type;
        l_event_id number;
        l_ticket_group_id number;
        l_customer_id number;
        l_status tickets.status%type;
        l_ticket_event_id number;
        l_ticket_price_category ticket_groups.price_category%type;
    begin
    
        select count(*)
        into i
        from 
            event_system.tickets t 
            join event_system.ticket_sales ts
                on t.ticket_sales_id = ts.ticket_sales_id
        where
            ts.ticket_group_id = p_ticket_group_id
            and t.serial_code = upper(p_serial_code)
            and t.status = c_ticket_status_validated;
            
        if i <> 1 then
            get_ticket_information(
                p_serial_code => p_serial_code, 
                p_status => l_status, 
                p_ticket_group_id => l_ticket_group_id, 
                p_customer_id => l_customer_id, 
                p_event_id => l_ticket_event_id);
            
            select tg.event_id
            into l_event_id
            from event_system.ticket_groups tg
            where tg.ticket_group_id = p_ticket_group_id;
            
            case
                when l_event_id <> l_ticket_event_id then
                    raise_application_error(-20100, 'Ticket is for a different event, cannot verify access');
                when l_status <> c_ticket_status_validated then
                    raise_application_error(-20100, 'Ticket has not been validated for event entry, cannot verify access for status ' || l_status);
                when l_ticket_group_id <> p_ticket_group_id then
                    l_ticket_price_category := get_ticket_group_category(p_ticket_group_id => l_ticket_group_id);
                    l_price_category := get_ticket_group_category(p_ticket_group_id => p_ticket_group_id);
                    raise_application_error(-20100, 'Ticket is for ' || l_ticket_price_category || ', ticket not valid for ' || l_price_category);
                else
                    raise_application_error(-20100, 'An unexpected error has occurred, cannot verify access');
            end case;
        end if;
    
    exception
        when others then
            log_error('SERIAL CODE ' || p_serial_code || ': ' || sqlerrm, sqlcode, 'ticket_verify_restricted_access');
            raise;    
    end ticket_verify_restricted_access;
    
    procedure ticket_cancel
    (
        p_event_id in number,    
        p_serial_code in varchar2
    )
    is
        l_event_id number;
        l_ticket_group_id number;
        l_customer_id number;
        l_status tickets.status%type;
    begin

        get_ticket_information(
            p_serial_code => p_serial_code, 
            p_status => l_status, 
            p_ticket_group_id => l_ticket_group_id, 
            p_customer_id => l_customer_id, 
            p_event_id => l_event_id);
            
        case
            when l_event_id <> p_event_id then
                raise_application_error(-20100, 'Ticket is for different event, cannot cancel');
            when l_status = c_ticket_status_validated then
                raise_application_error(-20100, 'Ticket has been validated for event entry, cannot cancel');
            else
                update_ticket_status(p_serial_code => p_serial_code, p_status => c_ticket_status_cancelled);
        
                commit;
        end case;
        
    exception
        when no_data_found then
            log_error('TICKET SERIAL CODE (' || p_serial_code || ') NOT FOUND FOR EVENT_ID ' || p_event_id, sqlcode, 'ticket_cancel');
            raise_application_error(-20100, 'Ticket serial code not found for event, cannot cancel');        
        when others then
            log_error(sqlerrm, sqlcode, 'ticket_cancel');
            raise;
    end ticket_cancel;

--package initialization
begin
    initialize;
end events_api;