create or replace package body event_sales_api
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
            p_locale => 'event_sales_api.' || p_locale);
   
    end log_error;
    
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

    --show pricing and availability for tickets created for the event
    function show_event_ticket_prices
    (
        p_event_id in number
    ) return t_ticket_prices pipelined
    is
        t_rows t_ticket_prices;
        rc sys_refcursor;
    begin
    
        show_event_ticket_prices(p_event_id, rc);
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
    
        show_event_series_ticket_prices(p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row (t_rows(i));
        end loop;
        return;
    
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
    
    function show_event_tickets_available_all
    (
        p_event_id in number 
    ) return t_event_tickets pipelined
    is
        t_rows t_event_tickets;
        rc sys_refcursor;
    begin
    
        show_event_tickets_available_all(p_event_id, rc);
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
    
        show_event_tickets_available_reseller(p_event_id, p_reseller_id, rc);
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
    
        show_event_tickets_available_venue(p_event_id, rc);
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
    
        show_event_series_tickets_available_all(p_event_series_id, rc);
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
    
        show_event_series_tickets_available_reseller(p_event_series_id, p_reseller_id, rc);
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
    
        show_event_series_tickets_available_venue(p_event_series_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_event_series_tickets_available_venue;
            
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
        
        event_tickets_api.generate_serialized_tickets(p_sale => p_sale);
            
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
    
    
    --add methods to print_tickets by ticket_sales_id
    
    

begin
    initialize;
end event_sales_api;