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

    --show pricing and availability for tickets created for the event
    function show_event_ticket_prices
    (
        p_event_id in number
    ) return t_ticket_prices pipelined
    is
        t_rows t_ticket_prices;
        rc sys_refcursor;
    begin
    
        events_api.show_event_ticket_prices(p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row (t_rows(i));
        end loop;
        return;
    
    end show_event_ticket_prices;
    
    function show_event_series_ticket_prices
    (
        p_event_series_id in number
    ) return t_ticket_prices_series pipelined
    is
        t_rows t_ticket_prices_series;
        rc sys_refcursor;
    begin
    
        events_api.show_event_series_ticket_prices(p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row (t_rows(i));
        end loop;
        return;
    
    end show_event_series_ticket_prices;
    
    function show_event_tickets_available_all
    (
        p_event_id in number 
    ) return t_event_tickets pipelined
    is
        t_rows t_event_tickets;
        rc sys_refcursor;
    begin
    
        events_api.show_event_tickets_available_all(p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_tickets_available_all;

    function show_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number  
    ) return t_event_tickets pipelined
    is
        t_rows t_event_tickets;
        rc sys_refcursor;
    begin
    
        events_api.show_event_tickets_available_reseller(p_event_id, p_reseller_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_tickets_available_reseller;
    
    function show_event_tickets_available_venue
    (
        p_event_id in number
    ) return t_event_tickets pipelined
    is
        t_rows t_event_tickets;
        rc sys_refcursor;
    begin
    
        events_api.show_event_tickets_available_venue(p_event_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_tickets_available_venue;

    function show_event_series_tickets_available_all
    (
        p_event_series_id in number 
    ) return t_event_series_tickets pipelined
    is
        t_rows t_event_series_tickets;
        rc sys_refcursor;
    begin
    
        events_api.show_event_series_tickets_available_all(p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_series_tickets_available_all;    
    
    function show_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number
    ) return t_event_series_tickets pipelined
    is
        t_rows t_event_series_tickets;
        rc sys_refcursor;
    begin
    
        events_api.show_event_series_tickets_available_reseller(p_event_series_id, p_reseller_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_series_tickets_available_reseller;
    
    function show_event_series_tickets_available_venue
    (
        p_event_series_id in number
    ) return t_event_series_tickets pipelined
    is
        t_rows t_event_series_tickets;
        rc sys_refcursor;
    begin
    
        events_api.show_event_series_tickets_available_venue(p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_series_tickets_available_venue;

    function show_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number
    ) return t_customer_event_tickets pipelined
    is
        t_rows t_customer_event_tickets;
        rc sys_refcursor;
    begin
    
        events_api.show_customer_event_tickets(p_customer_id, p_event_id, rc);
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
            
        events_api.show_customer_event_tickets_by_email(p_customer_email, p_event_id, rc);
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
    
        events_api.show_customer_event_series_tickets(p_customer_id, p_event_series_id, rc);
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
        
        events_api.show_customer_event_series_tickets_by_email(p_customer_email, p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_customer_event_series_tickets_by_email;


begin
  null;
end events_report_api;
