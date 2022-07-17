create or replace package body events_test_data_api
as
    type r_customer is record(customer_id number, number_tickets number);
    type t_customers is table of r_customer;

    function get_random_customers return t_customers
    is
        l_customers t_customers;
    begin
        select customer_id, trunc(dbms_random.value(2,20)) as number_tickets
        bulk collect into l_customers
        from customers
        order by dbms_random.value()
        fetch first 50 rows only;
        return l_customers;
    end get_random_customers;

    procedure delete_test_data
    is
        procedure truncate_table(p_table in varchar2)
        is
            v_ddl varchar2(100);
        begin
            v_ddl := 'truncate table event_system.' || p_table || ' drop storage'; 
            execute immediate v_ddl;
        end truncate_table;
    begin

        truncate_table('tickets');
        truncate_table('ticket_sales');
        truncate_table('ticket_assignments');
        truncate_table('ticket_groups');
        truncate_table('events');
        truncate_table('venues');
        truncate_table('resellers');
        truncate_table('customers');
        truncate_table('error_log');

    end delete_test_data;
        
    procedure delete_customer_data(p_customer_id in number)
    is
    begin
    
        delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.customer_id = p_customer_id);
        
        delete from ticket_sales ts where ts.customer_id = p_customer_id;
        
        delete from customers c where c.customer_id = p_customer_id;
        
        commit;
    
    end delete_customer_data;

    procedure delete_reseller_data(p_reseller_id in number)
    is
    begin
    
        delete from tickets t where t.ticket_sales_id in (select ts.ticket_sales_id from ticket_sales ts where ts.reseller_id = p_reseller_id);
        
        delete from ticket_sales ts where ts.reseller_id = p_reseller_id;
        
        delete from ticket_assignments ta where ta.reseller_id = p_reseller_id;
        
        delete from resellers r where r.reseller_id = p_reseller_id;
        
        commit;
        
    end delete_reseller_data;
    
    procedure delete_venue_data(p_venue_id in number)
    is
        cursor c is
            select e.event_id
            from events e
            where e.venue_id = p_venue_id;
    begin
    
        for r in c loop
            delete_event_data(r.event_id);
        end loop;
        
        delete from venues v where v.venue_id = p_venue_id;
        
        commit;
        
    end delete_venue_data;
    
--remove all data for an event
--use during testing to repeat event creation process
    procedure delete_event_data(p_event_id in number)
    is
    begin

        delete from tickets t 
        where t.ticket_sales_id in 
            (
                select ts.ticket_sales_id 
                from ticket_sales ts 
                join ticket_groups tg 
                    on ts.ticket_group_id = tg.ticket_group_id 
                where tg.event_id = p_event_id
            );

        delete from ticket_sales ts 
        where ts.ticket_group_id in 
            (
                select tg.ticket_group_id 
                from ticket_groups tg 
                where tg.event_id = p_event_id
            );
    
        delete from ticket_assignments ta 
        where ta.ticket_group_id in 
            (
                select tg.ticket_group_id 
                from ticket_groups tg 
                where tg.event_id = p_event_id
            );
    
        delete from ticket_groups tg 
        where tg.event_id = p_event_id;

        delete from events e 
        where e.event_id = p_event_id;

        commit;

        dbms_output.put_line('all data for event ' || p_event_id || ' has been deleted');

    end delete_event_data;

--use during testing to remove a recurring venue event
    procedure delete_event_series(p_event_series_id in number)
    is
        cursor c is
            select event_id
            from events 
            where event_series_id = p_event_series_id;
    begin

        for r in c loop
            delete_event_data(r.event_id);
        end loop;

    end delete_event_series;
    
    procedure delete_venue_events_by_name(p_venue_id in number, p_event_name in varchar2)
    is
        cursor c is
            select event_id
            from events 
            where 
                venue_id = p_venue_id
                and upper(event_name) = upper(p_event_name);
    begin

        for r in c loop
            delete_event_data(r.event_id);
        end loop;

    end delete_venue_events_by_name;

    procedure create_customers
    is

        cursor customers is
        with fnames as 
        (
            select 'Albert' as fname from dual union all
            select 'April' from dual union all
            select 'Alex' from dual union all
            select 'Alexa' from dual union all
            select 'Andre' from dual union all
            select 'Andrea' from dual union all
            select 'Bert' from dual union all
            select 'Bethany' from dual union all
            select 'Celeste' from dual union all
            select 'Chris' from dual union all
            select 'Christopher' from dual union all
            select 'Edward' from dual union all
            select 'Eve' from dual union all
            select 'Gary' from dual union all 
            select 'Gene' from dual union all
            select 'Gina' from dual union all
            select 'Grace' from dual union all
            select 'Gretchen' from dual union all
            select 'Harold' from dual union all
            select 'Harry' from dual union all
            select 'Howard' from dual union all
            select 'Igor' from dual union all
            select 'Ivan' from dual union all
            select 'James' from dual union all
            select 'Jane' from dual union all
            select 'Jean' from dual union all
            select 'Jill' from dual union all
            select 'Jillian' from dual union all
            select 'Jerry' from dual union all
            select 'Jim' from dual union all
            select 'John' from dual union all
            select 'Joycelyn' from dual union all
            select 'Jules' from dual union all
            select 'Julie' from dual union all
            select 'Judy' from dual union all
            select 'June' from dual union all
            select 'Katherine' from dual union all
            select 'Kathy' from dual union all
            select 'Keanu' from dual union all
            select 'Kelly' from dual union all
            select 'Kyle' from dual union all
            select 'Maggie' from dual union all
            select 'Margaret' from dual union all
            select 'Mariko' from dual union all
            select 'Matt' from dual union all
            select 'Matthew' from dual union all
            select 'Natalia' from dual union all
            select 'Nathaniel' from dual union all
            select 'Pete' from dual union all
            select 'Paul' from dual union all
            select 'Phil' from dual union all
            select 'Phillipe' from dual union all
            select 'Ravi' from dual union all
            select 'Reese' from dual union all  
            select 'Rene' from dual union all
            select 'Richard' from dual union all
            select 'Ron' from dual union all
            select 'Ruben' from dual union all
            select 'Ryan' from dual union all
            select 'Shelly' from dual union all
            select 'Stan' from dual union all
            select 'Stanley' from dual union all
            select 'Stephen' from dual union all
            select 'Steve' from dual union all
            select 'Sunita' from dual union all
            select 'Tamiko' from dual union all
            select 'Tenzin' from dual union all
            select 'Tilly' from dual union all
            select 'Tina' from dual union all
            select 'Tomas' from dual union all
            select 'Tom' from dual union all   
            select 'Ursula' from dual union all
            select 'Virginia' from dual union all
            select 'Wayne' from dual union all
            select 'Wendy' from dual union all
            select 'Zola' from dual
        ),
        lnames as
        (
            select 'Albright' as lname from dual union all
            select 'Armstrong' as lname from dual union all
            select 'Barry' from dual union all
            select 'Baum' from dual union all
            select 'Bikram' from dual union all
            select 'Birch' from dual union all
            select 'Browning' from dual union all
            select 'Dewar' from dual union all
            select 'Dodge' from dual union all
            select 'Edmunds' from dual union all
            select 'Edwards' from dual union all
            select 'Einstein' from dual union all
            select 'Fredericks' from dual union all
            select 'Garcia' from dual union all
            select 'Gardner' from dual union all
            select 'Goddard' from dual union all
            select 'Gyaltso' from dual union all
            select 'Hall' from dual union all
            select 'Hilfiger' from dual union all
            select 'Hill' from dual union all
            select 'Hilyard' from dual union all
            select 'Hoffman' from dual union all
            select 'Jackson' from dual union all
            select 'Janeway' from dual union all
            select 'Jenkins' from dual union all
            select 'Jones' from dual union all
            select 'Keyes' from dual union all
            select 'Kensington' from dual union all
            select 'Kirby' from dual union all
            select 'Killjoy' from dual union all
            select 'Kim' from dual union all
            select 'Kirk' from dual union all
            select 'Mansfield' from dual union all
            select 'Manaben' from dual union all
            select 'Masters' from dual union all
            select 'Matsusuki' from dual union all
            select 'Miller' from dual union all
            select 'Moore' from dual union all
            select 'Park' from dual union all   
            select 'Picard' from dual union all  
            select 'Potter' from dual union all
            select 'Porter' from dual union all
            select 'Richards' from dual union all
            select 'Ridell' from dual union all
            select 'Ringen' from dual union all
            select 'Roberts' from dual union all
            select 'Robertson' from dual union all
            select 'Rodriguez' from dual union all
            select 'Shankar' from dual union all
            select 'Singer' from dual union all
            select 'Smith' from dual union all
            select 'Song' from dual union all
            select 'Star' from dual union all
            select 'Teller' from dual union all
            select 'Tennant' from dual union all
            select 'Trevors' from dual union all
            select 'Tsu' from dual union all
            select 'Vaughn' from dual union all
            select 'Wall' from dual union all
            select 'Walsh' from dual union all
            select 'Wells' from dual union all
            select 'Wayland' from dual union all
            select 'Wilson' from dual union all
            select 'Yamaguchi' from dual union all
            select 'Yogesh' from dual
        )
        select
            fname || ' ' || lname as name,
            fname || '.' || lname || '@example.customer.com' as email,
            dbms_random.value(1,100) random_sort
        from 
            fnames 
            cross join lnames
        order by random_sort;

        c_id number;
    begin

    for r in customers loop
        customer_api.create_customer(r.name, r.email, c_id);
    end loop;

    end create_customers;

    procedure create_resellers
    is
        cursor resellers is
            with name_base as
            (
                select 'Tickets R Us' as name from dual union all
                select 'Tickets 2 Go' from dual union all
                select 'Ticketron' from dual union all
                select 'Source Tix' from dual union all
                select 'Old School' from dual union all
                select 'Ticket Supply' from dual union all
                select 'Ticket Time' from dual union all
                select 'MaxTix' from dual union all
                select 'Your Ticket Supplier' from dual union all
                select 'The Source' from dual union all
                select 'Events For You' from dual
            )
            select
                n.name,
                'ticket.sales@' || replace(n.name,' ') || '.com' as email,
                round(dbms_random.value(10,15)/100,4) as commission_pct
            from name_base n
            order by n.name;
        
        r_id number;
    begin
    
    
        for r in resellers loop
            reseller_api.create_reseller(r.name, r.email, r.commission_pct, r_id);
        end loop;
    
    end create_resellers;

    procedure create_venues
    is
        cursor venues is
            with base as
            (
                select 'The Ampitheatre' as venue_name, 'Max Johnson' as organizer_name, 10000 as capacity from dual union all
                select 'City Stadium', 'Erin Johanson', 20000 from dual union all
                select 'The Right Spot', 'Carol Zaxby', 2000 from dual union all
                select 'Nick''s Place', 'Nick Tremaine', 500 from dual union all
                select 'Pearl Nightclub', 'Gina Andrews', 1000 from dual union all
                select 'Club 11', 'Mary Rivera', 500 from dual union all
                select 'Clockworks', 'Juliette Rivera', 2000 from dual union all
                select 'Cozy Spot', 'Drew Cavendish', 400 from dual union all
                select 'Crystal Ballroom', 'Rudolph Racine', 2000 from dual
            ) 
            select
                b.venue_name,
                b.organizer_name,
                replace(b.organizer_name,' ','.')|| '@' || replace(b.venue_name,' ') || '.com' as organizer_email,
                b.capacity
            from base b
            order by b.venue_name;
        
        v_id number;
    begin
    
        for r in venues loop
            venue_api.create_venue(r.venue_name, r.organizer_name, r.organizer_email,r.capacity, v_id);
        end loop;
    
    end create_venues;

    procedure create_events
    is
        cursor acts is
            with acts as
            (
                select 'Rudy and The Trees' as act_name from dual union all
                select 'A Night of Polka' from dual union all
                select 'Molly Jones and Associates' from dual union all
                select 'Rolling Thunder' from dual union all
                select 'Miles Morgan and the Undergound Jazz Trio' from dual union all
                select 'Purple Parrots' from dual union all
                select 'The Specials' from dual union all
                select 'Synthtones and Company' from dual union all
                select 'The Electric Blues Garage Band' from dual union all
                select 'Sounds of Earthlings' from dual union all
                select 'Paper Dolls' from dual
            ), acts_base as
            (
                select 
                    a.act_name,
                    rownum * 7 as act_row
                from acts a
            ), venue_base as
            (
                select 
                    v.venue_id, 
                    v.venue_name,
                    v.max_event_capacity,
                    rownum as venue_row
                from venues v
            )
            select
                v.venue_id,
                a.act_name,
                next_day( sysdate + ( (a.act_row * v.venue_row) + 60) , 'Friday') as event_date,
                v.max_event_capacity as tickets_available
            from 
                acts_base a 
                cross join venue_base v
            order by 
                event_date, 
                a.act_name, 
                v.venue_name;
    
        e_id number;
    begin
        for r in acts loop
            event_setup_api.create_event(r.venue_id, r.act_name, r.event_date, r.tickets_available, e_id);
            if mod(e_id, 3) = 0 then
                event_setup_api.create_event(r.venue_id, r.act_name, r.event_date + 1, r.tickets_available, e_id);            
            end if;
        end loop;
    end create_events;

    procedure create_weekly_events
    is
        cursor small_venues is 
            select 
                v.venue_id, 
                v.max_event_capacity as event_tickets
            from venues v
            where v.max_event_capacity <= 1000;
    
        v_status varchar2(4000);
        v_start_date date := sysdate + 45;
        v_end_date date := sysdate + 270;
        v_event_series_id number;
    begin
    
        for r in small_venues loop
            event_setup_api.create_weekly_event(r.venue_id, 'Amateur Comedy Hour', v_start_date, v_end_date, 'Thursday',r.event_tickets,v_event_series_id,v_status);
            event_setup_api.create_weekly_event(r.venue_id, 'Poetry Night', v_start_date, v_end_date, 'Tuesday',r.event_tickets,v_event_series_id,v_status);
            event_setup_api.create_weekly_event(r.venue_id, 'Open Mike Night', v_start_date, v_end_date, 'Wednesday',r.event_tickets,v_event_series_id,v_status);
        end loop;
    
    end create_weekly_events;

    procedure create_ticket_groups
    is

        cursor small_events is
            select 
                e.event_id, 
                e.tickets_available
            from events e 
            where 
                e.tickets_available <= 500
                and e.event_series_id is null;

        cursor large_events is
            select 
                e.event_id, 
                e.tickets_available
            from events e 
            where 
                e.tickets_available > 500
                and e.event_series_id is null;

        cursor series_events is
            select 
                e.event_series_id, 
                min(e.tickets_available) as tickets_available
            from events e 
            where e.event_series_id is not null
            group by e.event_series_id;

        v_group_id number;
        v_status_code varchar2(100);
        v_status_message varchar2(4000);
        
        type r_ticket_group is record
        (
            price_category ticket_groups.price_category%type,
            price ticket_groups.price%type,
            tickets number
        );

        type t_ticket_groups is table of r_ticket_group index by pls_integer;
        v_ticket_groups t_ticket_groups;
   
        procedure factor_tickets(p_total_tickets in number, p_percent in number, p_tickets out number, p_remaining in out number)
        is
        begin
            p_tickets := trunc(p_total_tickets * p_percent);
            p_remaining := p_remaining - p_tickets;
        end factor_tickets;
   
        function build_small_event(p_tickets in number) return t_ticket_groups
        is
            v_groups t_ticket_groups;
            v_tickets number;
            v_remaining_tickets number := p_tickets;
        begin
            factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
            v_groups(1) := r_ticket_group('SPONSOR',100,v_tickets);        
            factor_tickets(p_tickets, .20, v_tickets, v_remaining_tickets);
            v_groups(2) := r_ticket_group('VIP',42,v_tickets);   
            factor_tickets(p_tickets, .20, v_tickets, v_remaining_tickets);
            v_groups(3) := r_ticket_group('EARLYBIRD DISCOUNT',22,v_tickets);   
            v_groups(4) := r_ticket_group('GENERAL ADMISSION',30,v_remaining_tickets);   
            return v_groups;
        end build_small_event;

        function build_large_event(p_tickets in number) return t_ticket_groups
        is
            v_groups t_ticket_groups;
            v_tickets number;
            v_remaining_tickets number := p_tickets;
        begin
            factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
            v_groups(1) := r_ticket_group('BACKSTAGE-ALL ACCESS',150,v_tickets);        
            factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
            v_groups(2) := r_ticket_group('VIP',100,v_tickets);   
            factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
            v_groups(3) := r_ticket_group('EARLYBIRD DISCOUNT',40,v_tickets); 
            factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
            v_groups(4) := r_ticket_group('RESERVED SEATING',75,v_tickets);      
            v_groups(5) := r_ticket_group('GENERAL ADMISSION',50,v_remaining_tickets);   
            return v_groups;
        end build_large_event;

    begin

        for r in small_events loop
            v_ticket_groups := build_small_event(r.tickets_available);
            for g in 1..v_ticket_groups.count loop
                event_setup_api.create_ticket_group(
                    r.event_id, 
                    v_ticket_groups(g).price_category, 
                    v_ticket_groups(g).price, 
                    v_ticket_groups(g).tickets, 
                    v_group_id);
            end loop;
        end loop;
        
        for r in large_events loop
            v_ticket_groups := build_large_event(r.tickets_available);
            for g in 1..v_ticket_groups.count loop
                event_setup_api.create_ticket_group(
                    r.event_id, 
                    v_ticket_groups(g).price_category, 
                    v_ticket_groups(g).price, 
                    v_ticket_groups(g).tickets, 
                    v_group_id);
            end loop;
        end loop;
        
        for r in series_events loop
            v_ticket_groups := build_small_event(r.tickets_available);
            for g in 1..v_ticket_groups.count loop
                event_setup_api.create_ticket_group_event_series(
                    r.event_series_id, 
                    v_ticket_groups(g).price_category, 
                    v_ticket_groups(g).price, 
                    v_ticket_groups(g).tickets, 
                    v_status_code, 
                    v_status_message);
            end loop;
        end loop;

    end create_ticket_groups;

    procedure create_ticket_assignments
    is

        cursor event_ticket_groups is
            select 
                tg.ticket_group_id, 
                round(tg.tickets_available * 0.8) as tickets_available
            from 
                event_system.events e 
                join event_system.ticket_groups tg 
                    on e.event_id = tg.event_id
            where e.event_series_id is null
            order by 
                e.venue_id, 
                e.event_date, 
                tg.ticket_group_id;

        cursor event_series_ticket_groups is
            select 
                e.event_series_id,
                tg.price_category, 
                round(min(tg.tickets_available) * 0.8) as tickets_available
            from 
                event_system.events e 
                join event_system.ticket_groups tg 
                    on e.event_id = tg.event_id
            where e.event_series_id is not null
            group by
                e.venue_id,
                e.event_series_id,
                tg.price_category
            order by 
                tg.price_category;
        
        type t_resellers is table of number index by pls_integer;
        v_resellers t_resellers;
        v_tickets number;
        v_tickets_remaining number;
        v_assignment_id number;
        v_status_code varchar2(100);
        v_status_message varchar2(4000);
        
        function get_resellers return t_resellers
        is
            l_resellers t_resellers;
        begin
        
            with base as
            (
                select
                    reseller_id,
                    round(dbms_random.value(0,1),2) include_reseller
                from resellers
                order by dbms_random.value
            ), random_base as
            (
                select
                    reseller_id,
                    b.include_reseller
                from base b
                where b.include_reseller > .5
            )
            select reseller_id bulk collect 
            into l_resellers from random_base;   
            
            return l_resellers;
        end get_resellers;
   
        procedure factor_tickets(p_total in number, p_tickets out number, p_remaining in out number)
        is
            l_tickets number := p_total * 0.1;
        begin
            case 
                when l_tickets > 1000 then l_tickets := 1000;
                when l_tickets > 500 then l_tickets := 500;
                when l_tickets > 250 then l_tickets := 250;
                when l_tickets > 100 then l_tickets := 100;
                else l_tickets := 20;
            end case;
            if l_tickets <= p_remaining then
                p_remaining := p_remaining - l_tickets;
            else
                l_tickets := 0;
            end if;
            p_tickets := l_tickets;
        end factor_tickets;

    begin

        for etg in event_ticket_groups loop
            v_tickets_remaining := etg.tickets_available;
            --for each ticket group only assign it to some resellers
            --each ticket group may be assigned to a different group of resellers
            v_resellers := get_resellers;
            for r in 1..v_resellers.count loop
                factor_tickets(etg.tickets_available, v_tickets, v_tickets_remaining);
                if v_tickets > 0 then
                    event_setup_api.create_ticket_assignment(v_resellers(r),etg.ticket_group_id, v_tickets, v_assignment_id); 
                end if;     
            end loop;
        end loop;
          
        for etg in event_series_ticket_groups loop
            v_tickets_remaining := etg.tickets_available;
            --for each ticket group only assign it to some resellers
            --each ticket group may be assigned to a different group of resellers
            v_resellers := get_resellers;
            for r in 1..v_resellers.count loop
                factor_tickets(etg.tickets_available, v_tickets, v_tickets_remaining);
                if v_tickets > 0 then
                    event_setup_api.create_ticket_assignment_event_series(
                        etg.event_series_id, 
                        v_resellers(r),
                        etg.price_category, 
                        v_tickets, 
                        v_status_code, 
                        v_status_message); 
                end if;     
            end loop;
        end loop;

    end create_ticket_assignments;
    
    
    procedure create_event_ticket_sales(p_event_id in number)
    is
        cursor ticket_options is
            select
                e.ticket_group_id,
                e.price,
                e.reseller_id,
                trunc((trunc(dbms_random.value(30,100))/100 * e.tickets_available)) tickets_available
            from tickets_available_all_v e
            where
                e.event_id = p_event_id
                and e.tickets_available > 0;
        
        v_customers t_customers;
        v_sales_id number;
        v_tickets_available number;
        v_actual_price number;
        v_extended_price number;
        
    begin

        for r in ticket_options loop  --o.ticket_group_id o.reseller_id  o.tickets_available
            v_customers := get_random_customers;
            v_tickets_available := r.tickets_available;
            for c in 1..v_customers.count loop
                
                if v_customers(c).number_tickets > 0 and v_tickets_available > v_customers(c).number_tickets then
                    begin
                        if r.reseller_id is not null then
                        
                            event_sales_api.purchase_tickets_reseller(
                                p_reseller_id => r.reseller_id,
                                p_ticket_group_id => r.ticket_group_id,
                                p_customer_id => v_customers(c).customer_id,
                                p_number_tickets => v_customers(c).number_tickets,
                                p_requested_price => r.price,
                                p_actual_price => v_actual_price,
                                p_extended_price => v_extended_price,
                                p_ticket_sales_id => v_sales_id);
                        
                        else
                        
                            event_sales_api.purchase_tickets_venue(
                                p_ticket_group_id => r.ticket_group_id,
                                p_customer_id => v_customers(c).customer_id,
                                p_number_tickets => v_customers(c).number_tickets,
                                p_requested_price => r.price,
                                p_actual_price => v_actual_price,
                                p_extended_price => v_extended_price,
                                p_ticket_sales_id => v_sales_id);
                        
                        end if;
                        v_tickets_available := v_tickets_available - v_customers(c).number_tickets;
                    exception
                        when others then
                            null;
                    end;
                end if;
            end loop;
        end loop;

    end create_event_ticket_sales;

    procedure create_event_series_ticket_sales(p_event_series_id in number)
    is
        cursor ticket_options is
            select
                e.price_category,
                e.price,
                e.reseller_id,
                trunc((trunc(dbms_random.value(30,100))/100 * e.tickets_available)) tickets_available
            from tickets_available_series_all_v e
            where
                e.event_series_id = p_event_series_id
                and e.tickets_available > 0;
        
        v_customers t_customers;
        v_sales_id number;
        v_tickets_available number;
        v_average_price number;
        v_total_purchase number;
        v_total_tickets number;
        v_status_code varchar2(25);
        v_status_message varchar2(4000);
    begin

        for r in ticket_options loop  --o.ticket_group_id o.reseller_id  o.tickets_available
            v_customers := get_random_customers;
            v_tickets_available := r.tickets_available;
            for c in 1..v_customers.count loop
                
                if v_customers(c).number_tickets > 0 and v_tickets_available > v_customers(c).number_tickets then
                    begin
                        if r.reseller_id is not null then

                            event_sales_api.purchase_tickets_reseller_series(
                                p_reseller_id => r.reseller_id,
                                p_event_series_id => p_event_series_id,
                                p_price_category => r.price_category,
                                p_customer_id => v_customers(c).customer_id,
                                p_number_tickets => v_customers(c).number_tickets,
                                p_requested_price => r.price,
                                p_average_price => v_average_price,
                                p_total_purchase => v_total_purchase,
                                p_total_tickets => v_total_tickets,
                                p_status_code => v_status_code,
                                p_status_message => v_status_message);
                                                
                        else

                            event_sales_api.purchase_tickets_venue_series(
                                p_event_series_id => p_event_series_id,
                                p_price_category => r.price_category,
                                p_customer_id => v_customers(c).customer_id,
                                p_number_tickets => v_customers(c).number_tickets,
                                p_requested_price => r.price,
                                p_average_price => v_average_price,
                                p_total_purchase => v_total_purchase,
                                p_total_tickets => v_total_tickets,
                                p_status_code => v_status_code,
                                p_status_message => v_status_message);
                                                
                        end if;
                        v_tickets_available := v_tickets_available - v_customers(c).number_tickets;
                    exception
                        when others then
                            null;
                    end;
                end if;
            end loop;
        end loop;

    end create_event_series_ticket_sales;


    procedure create_ticket_sales
    is
        type r_event is record(event_id number, generate_sales number);
        type t_events is table of r_event;
        v_events t_events;
        type r_event_series is record(event_series_id number, generate_sales number);
        type t_event_series is table of r_event_series;
        v_event_series t_event_series;
        i number := 0;
    begin
    
        select event_id, sign(trunc(dbms_random.value(-3,3))) as generate_sales 
        bulk collect into v_events
        from events
        order by dbms_random.value;
    
        for e in 1..v_events.count loop
            if v_events(e).generate_sales = 1 then
                create_event_ticket_sales(v_events(e).event_id);
                i := i + 1;
            end if;   
        end loop;
    
        dbms_output.put_line('created sales for ' || i || ' events.');
        i := 0;

        select event_series_id, sign(trunc(dbms_random.value(-3,3))) as generate_sales 
        bulk collect into v_event_series
        from (select e.event_series_id from events e where e.event_series_id is not null group by e.event_series_id)
        order by dbms_random.value;

        for e in 1..v_event_series.count loop
            if v_events(e).generate_sales = 1 then
                create_event_series_ticket_sales(v_event_series(e).event_series_id);
                i := i + 1;
            end if;   
        end loop;
        dbms_output.put_line('created sales for ' || i || ' event series.');


    end create_ticket_sales;

    procedure create_test_data
    is
    begin
    
        --clear previous test data
        delete_test_data;
        
        create_customers;
        create_resellers;
        create_venues;
        create_events;
        create_weekly_events;
        create_ticket_groups;
        create_ticket_assignments;
        
        for i in 1..3 loop
            create_ticket_sales;
        end loop;
    
    end create_test_data;
    
    procedure output_put_clob
    (
        p_doc in out nocopy clob, 
        p_chunksize in number default 32000
    )
    is
        l_chunck clob;
        l_length number;
        l_offset number := 1;
        l_amount number := p_chunksize;
    begin
    
        l_length := dbms_lob.getlength(p_doc);
        dbms_output.put_line('Document is ' || l_length || ' characters, outputting in ' || p_chunksize || ' character chunks');
        if l_amount > l_length then 
            l_amount := l_length;
        end if;
    
        loop
                  
            dbms_lob.read(p_doc, l_amount, l_offset, l_chunck);
            dbms_output.put_line(l_chunck);
            --set the offset past the last read
            l_offset := l_offset + l_amount;
            --adjust the amount to read based on total length
            if (l_offset + l_amount) > l_length then
                l_amount := (l_length - l_offset) + 1;
            end if;
            --exit if there is nothing to read or offset would exceed length
            if (l_amount <= 0) or (l_offset >= l_length) then
                exit;
            end if;
        
        end loop;
    
    exception
        when others then
            raise;
    end output_put_clob;


begin
    dbms_random.seed('Albert Einstein');
end events_test_data_api;
