create or replace package body events_report_api
as



    function show_event
    (
        p_event_id in number
    )  return t_event_info pipelined
    is
        t_rows t_event_info;
        rc sys_refcursor;
    begin
    
        events_api.show_event(p_event_id, rc);
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
    
        events_api.show_event_series(p_event_series_id, rc);
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
    
        events_api.show_all_events(p_venue_id, rc);
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
    
        events_api.show_all_event_series(p_venue_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_all_event_series;
    
    function show_ticket_groups
    (
        p_event_id in number
    ) return t_ticket_groups pipelined
    is
        t_rows t_ticket_groups;
        rc sys_refcursor;
    begin
    
        events_api.show_ticket_groups(p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_ticket_groups;
    
    function show_ticket_groups_event_series
    (
        p_event_series_id in number
    ) return t_ticket_groups_series pipelined
    is
        t_rows t_ticket_groups_series;
        rc sys_refcursor;
    begin
    
        events_api.show_ticket_groups_event_series(p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_ticket_groups_event_series;
    
    function show_ticket_assignments
    (
        p_event_id in number,
        p_reseller_id in number
    ) return t_ticket_assignments pipelined
    is
        t_rows t_ticket_assignments;
        rc sys_refcursor;
    begin
    
        events_api.show_ticket_assignments(p_event_id, p_reseller_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row (t_rows(i));
        end loop;
        return;
    
    end show_ticket_assignments;

    function show_ticket_assignments_event_series
    (
        p_event_series_id in number,
        p_reseller_id in number
    ) return t_ticket_assignments_series pipelined
    is
        t_rows t_ticket_assignments_series;
        rc sys_refcursor;
    begin
    
        events_api.show_ticket_assignments_event_series(p_event_series_id, p_reseller_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row (t_rows(i));
        end loop;
        return;
    
    end show_ticket_assignments_event_series;



begin
  null;
end events_report_api;
