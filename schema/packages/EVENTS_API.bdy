create or replace package body events_api
as

    g_processing_event_series boolean := false;


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



--package initialization
begin
    initialize;
end events_api;