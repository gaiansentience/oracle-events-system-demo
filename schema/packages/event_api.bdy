create or replace package body event_api
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
        util_error_api.log_error(
            p_error_message => p_error_message, 
            p_error_code => p_error_code, 
            p_locale => 'event_api.' || p_locale);
   
    end log_error;

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

    function show_event
    (
        p_event_id in number
    )  return t_event_info pipelined
    is
        t_rows t_event_info;
        rc sys_refcursor;
    begin
    
        show_event(p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;

    end show_event;

    function show_event_series
    (
        p_event_series_id in number
    )  return t_event_series_info pipelined
    is
        t_rows t_event_series_info;
        rc sys_refcursor;
    begin
    
        show_event_series(p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_series;
    
    function show_all_events
    (
        p_venue_id in number
    )  return t_event_info pipelined
    is
        t_rows t_event_info;
        rc sys_refcursor;
    begin
    
        show_all_events(p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_all_events;

    function show_all_event_series
    (
        p_venue_id in number
    )  return t_event_info pipelined
    is
        t_rows t_event_info;
        rc sys_refcursor;
    begin
    
        show_all_event_series(p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_all_event_series;

--package initialization
begin
    initialize;
end event_api;