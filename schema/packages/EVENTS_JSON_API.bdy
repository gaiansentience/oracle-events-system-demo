create or replace package body events_json_api
as

    function format_json_clob
    (
        p_json_doc in clob
    ) return clob
    is
        l_json clob;
    begin
    
        select json_serialize(p_json_doc pretty) 
        into l_json 
        from dual;
    
        return l_json;
    
    end format_json_clob;
    
    function format_json_string
    (
        p_json_doc in varchar2
    ) return varchar2
    is
        l_json varchar2(32000);
    begin
    
        select json_serialize(p_json_doc pretty) 
        into l_json 
        from dual;
    
        return l_json;
    
    end format_json_string;

    function get_json_error_doc
    (
        p_error_code in number,
        p_error_message in varchar2,
        p_json_method in varchar2
    ) return varchar2
    is
        o_error json_object_t := new json_object_t;
        l_json varchar2(4000);
    begin
    
        o_error.put('json_method', p_json_method);
        o_error.put('error_code', p_error_code);
        o_error.put('error_message', p_error_message);
        l_json := o_error.to_string();
       
        return format_json_string(l_json);
       
    end get_json_error_doc;

    function get_all_resellers
    (
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from all_resellers_v_json b;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_all_resellers');
    end get_all_resellers;

    function get_reseller
    (
        p_reseller_id in number,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_json varchar2(4000);
    begin
    
        select b.json_doc
        into l_json
        from resellers_v_json b
        where b.reseller_id = p_reseller_id;
    
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_reseller');
    end get_reseller;

    procedure create_reseller
    (
        p_json_doc in out varchar2
    )
    is
        r_reseller event_system.resellers%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        r_reseller.reseller_name := o_request.get_string('reseller_name');
        r_reseller.reseller_email := o_request.get_string('reseller_email');
        r_reseller.commission_percent := o_request.get_number('commission_percent');
        r_reseller.reseller_id := 0;
        
        case
            when r_reseller.reseller_name is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing reseller name, cannot create reseller';
            when r_reseller.reseller_email is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing reseller email, cannot create reseller';
            when r_reseller.commission_percent is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing reseller commission, cannot create reseller';      
            else
                begin         
                    events_api.create_reseller(r_reseller.reseller_name, r_reseller.reseller_email, r_reseller.commission_percent, r_reseller.reseller_id);
                    l_status_code := 'SUCCESS';
                    l_status_message := 'Created reseller';
                exception
                    when others then
                        l_status_code := 'ERROR';
                        l_status_message := sqlerrm;
                end;
        end case;
        
        o_request.put('reseller_id', r_reseller.reseller_id);
        o_request.put('status_code',l_status_code);
        o_request.put('status_message', l_status_message);
        
        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_reseller');
    end create_reseller;

    function get_all_venues
    (
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from all_venues_v_json b;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_all_venues');
    end get_all_venues;

    function get_venue
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_json varchar2(4000);
    begin

        select b.json_doc
        into l_json
        from venues_v_json b
        where b.venue_id = p_venue_id;

        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
   
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_venue');
    end get_venue;

    procedure create_venue
    (
        p_json_doc in out varchar2
    )
    is
        r_venue event_system.venues%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        r_venue.venue_name := o_request.get_string('venue_name');   
        r_venue.organizer_name := o_request.get_string('organizer_name');
        r_venue.organizer_email := o_request.get_string('organizer_email');
        r_venue.max_event_capacity := o_request.get_number('max_event_capacity');
        r_venue.venue_id := 0;
    
        case
            when r_venue.venue_name is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing venue name, cannot create venue';
            when r_venue.organizer_name is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing organizer name, cannot create venue';         
            when r_venue.organizer_email is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing organizer email, cannot create venue';
            when r_venue.max_event_capacity is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing event capacity, cannot create venue';      
            else
                begin         
                    events_api.create_venue(r_venue.venue_name, r_venue.organizer_name, r_venue.organizer_email, r_venue.max_event_capacity, r_venue.venue_id);
                        l_status_code := 'SUCCESS';
                        l_status_message := 'Created venue';
                exception
                    when others then
                        l_status_code := 'ERROR';
                        l_status_message := sqlerrm;
                end;
        end case;

        o_request.put('venue_id', r_venue.venue_id);
        o_request.put('status_code',l_status_code);
        o_request.put('status_message', l_status_message);

        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_venue');
    end create_venue;

    function get_venue_events
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from venue_events_v_json b
        where b.venue_id = p_venue_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_venue_events');
    end get_venue_events;

    function get_venue_event_series
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from venue_event_series_v_json b
        where b.venue_id = p_venue_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_venue_event_series');
    end get_venue_event_series;

    procedure create_event
    (
        p_json_doc in out varchar2
    )
    is
        r_event event_system.events%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        o_request := json_object_t.parse(p_json_doc);
    
        r_event.venue_id := o_request.get_string('venue_id');   
        r_event.event_name := o_request.get_string('event_name');
        r_event.event_date := o_request.get_date('event_date');
        r_event.tickets_available := o_request.get_number('tickets_available');
        r_event.event_id := 0;
    
        case
            when r_event.venue_id is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing venue, cannot create event';
            when r_event.event_name is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing event name, cannot create event';         
            when r_event.event_date is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing event date, cannot create event';
            when r_event.tickets_available is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing event capacity, cannot create event';      
            else
                begin
                    events_api.create_event(r_event.venue_id, r_event.event_name, r_event.event_date, r_event.tickets_available, r_event.event_id);
                    l_status_code := 'SUCCESS';
                    l_status_message := 'Created event';
                exception
                    when others then
                        l_status_code := 'ERROR';
                        l_status_message := sqlerrm;
                end;
        end case;
        
        o_request.put('event_id', r_event.event_id);
        o_request.put('status_code',l_status_code);
        o_request.put('status_message', l_status_message);
        
        p_json_doc := o_request.to_string; 
    
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_event');
    end create_event;

    procedure create_weekly_event
    (
        p_json_doc in out clob
    )
    is
        l_venue_id venues.venue_id%type;
        l_event_name events.event_name%type;
        l_event_start_date date;
        l_event_end_date date;
        l_event_day varchar2(20);
        l_tickets_available events.tickets_available%type;
        
        o_request json_object_t;
        a_eventDetails json_array_t := json_array_t;
        o_event json_object_t;
        
        l_event_series_id number;        
        t_status_details events_api.t_series_event;
        l_status_code varchar2(20);
        l_status_message varchar2(4000);
    begin
    
        o_request := json_object_t.parse(p_json_doc);
        
        l_venue_id := o_request.get_string('venue_id');   
        l_event_name := o_request.get_string('event_name');
        l_event_start_date := o_request.get_date('event_start_date');
        l_event_end_date := o_request.get_date('event_end_date');
        l_event_day := o_request.get_string('event_day');
        l_tickets_available := o_request.get_number('tickets_available');
        
        events_api.create_weekly_event(
            p_venue_id => l_venue_id,   
            p_event_name => l_event_name,
            p_event_start_date => l_event_start_date,
            p_event_end_date => l_event_end_date,
            p_event_day => l_event_day,
            p_tickets_available => l_tickets_available,
            p_event_series_id => l_event_series_id,        
            p_status_details => t_status_details,
            p_status_code => l_status_code,
            p_status_message => l_status_message);

        o_request.put('request_status_code', l_status_code);
        o_request.put('request_status_message', l_status_message);
        o_request.put('event_series_id', l_event_series_id);
        o_request.put('event_series_details', a_eventDetails);
        a_eventDetails := o_request.get_array('event_series_details');
        --create event_details elements
        for i in 1..t_status_details.count loop
            o_event := json_object_t;
            o_event.put('event_id', t_status_details(i).event_id);
            o_event.put('event_date', t_status_details(i).event_date);
            o_event.put('status_code', t_status_details(i).status_code);
            o_event.put('status_message', t_status_details(i).status_message);
            a_eventDetails.append(o_event);
        end loop;
        
        p_json_doc := o_request.to_clob; 
    
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_weekly_event');
    end create_weekly_event;

    function get_event
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_json varchar2(4000);
    begin
    
        select b.json_doc
        into l_json
        from events_v_json b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event');
    end get_event;

    procedure create_customer
    (
        p_json_doc in out varchar2
    )
    is
        r_customer event_system.customers%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
        
        o_request := json_object_t.parse(p_json_doc);
        
        r_customer.customer_name := o_request.get_string('customer_name');
        r_customer.customer_email := o_request.get_string('customer_email');
        r_customer.customer_id := 0;
        
        case
            when r_customer.customer_name is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing name, cannot create customer';
            when r_customer.customer_email is null then
                l_status_code := 'ERROR';
                l_status_message := 'Missing email, cannot create customer';         
            else
                begin                  
                    events_api.create_customer(r_customer.customer_name, r_customer.customer_email, r_customer.customer_id);
                    l_status_code := 'SUCCESS';
                    l_status_message := 'Created customer';
                exception
                    when others then
                        l_status_code := 'ERROR';
                        l_status_message := sqlerrm;
                end;
        end case;
        
        o_request.put('customer_id', r_customer.customer_id);
        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);
        
        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_customer');
    end create_customer;

    function get_ticket_groups
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_json varchar2(32000);
    begin
    
        select b.json_doc
        into l_json
        from event_ticket_groups_v_json b
        where b.event_id = p_event_id;
        
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_groups');
    end get_ticket_groups;

    function get_ticket_groups_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_json varchar2(32000);
    begin
    
        select b.json_doc
        into l_json
        from event_series_ticket_groups_v_json b
        where b.event_series_id = p_event_series_id;
        
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_groups_series');
    end get_ticket_groups_series;

--update ticket groups using a json document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
    procedure update_ticket_groups
    (
        p_json_doc in out varchar2
    )
    is
        r_group event_system.ticket_groups%rowtype;
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;
        l_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        r_group.event_id := o_request.get_number('event_id');
        a_groups := o_request.get_array('ticket_groups');
        for i in 0..a_groups.get_size - 1 loop
        
            o_group := json_object_t(a_groups.get(i));
            r_group.price_category := o_group.get_string('price_category');
            r_group.price := o_group.get_number('price');
            r_group.tickets_available := o_group.get_number('tickets_available');
            r_group.ticket_group_id := 0;
            
            case
                when r_group.price_category is null then
                    l_error_count := l_error_count + 1;
                    l_status_code := 'ERROR';
                    l_status_message := 'Missing price category, cannot set group';
                when r_group.price_category = 'UNDEFINED' then
                    l_error_count := l_error_count + 1;
                    l_status_code := 'ERROR';
                    l_status_message := 'Price category is UNDEFINED, cannot set group';
                else
                    begin
                        events_api.create_ticket_group(
                            r_group.event_id, 
                            r_group.price_category, 
                            r_group.price, 
                            r_group.tickets_available, 
                            r_group.ticket_group_id);
                        l_status_code := 'SUCCESS';
                        l_status_message := 'Created/updated ticket group';
                    exception
                        when others then
                            l_error_count := l_error_count + 1;
                            l_status_code := 'ERROR';
                            l_status_message := sqlerrm;
                    end;
            end case;
            
            o_group.put('ticket_group_id', r_group.ticket_group_id);
            o_group.put('status_code', l_status_code);
            o_group.put('status_message', l_status_message);
        
        end loop;

        o_request.put('request_status', case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        o_request.put('request_errors', l_error_count);
        
        p_json_doc := o_request.to_string; 
   
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_ticket_groups');
    end update_ticket_groups;

--return possible reseller ticket assignments for event as json document
--returns array of all resellers with ticket groups as nested array
    function get_ticket_assignments
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from reseller_ticket_assignment_v_json b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_assignments');
    end get_ticket_assignments;

--update ticket assignments for a reseller using a json document in the same format as get_event_reseller_ticket_assignments
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
--supports assignment of multiple ticket groups to multiple resellers
--WARNING:  IF MULTIPLE RESELLERS ARE SUBMITTED ASSIGNMENTS CAN EXCEED LIMITS CREATING MULTIPLE ERRORS AT THE END OF BATCH
--IT IS RECOMMENDED TO SUBMIT ASSIGNMENTS FOR ONE RESELLER AT A TIME AND REFRESH THE ASSIGNMENTS DOCUMENT TO SEE CHANGED LIMITS
--additional informational fields from get_event_reseller_ticket_assignments may be present
--if additional informational fields are present they will not be processed
    procedure update_ticket_assignments
    (
        p_json_doc in out nocopy clob
    )
    is
        l_event_id number;
        r_assignment event_system.ticket_assignments%rowtype;
        o_request json_object_t;
        a_resellers json_array_t;
        o_reseller json_object_t;
        a_groups json_array_t;
        o_group json_object_t;
        
        l_reseller_error_count number := 0;
        l_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
        
        o_request := json_object_t.parse(p_json_doc);
        l_event_id := o_request.get_number('event_id');
        
        a_resellers := o_request.get_array('ticket_resellers');
        
        for r in 0..a_resellers.get_size - 1 loop
        
            o_reseller := json_object_t(a_resellers.get(r));
            l_reseller_error_count := 0;
            r_assignment.reseller_id := o_reseller.get_number('reseller_id');
            
            a_groups := o_reseller.get_array('ticket_assignments');
            
            for g in 0..a_groups.get_size - 1 loop
            
                o_group := json_object_t(a_groups.get(g));
                r_assignment.ticket_group_id := o_group.get_number('ticket_group_id');
                r_assignment.tickets_assigned := o_group.get_number('tickets_assigned');
                r_assignment.ticket_assignment_id := 0;
                
                begin
                    events_api.create_ticket_assignment(
                        p_reseller_id => r_assignment.reseller_id,
                        p_ticket_group_id => r_assignment.ticket_group_id,
                        p_number_tickets => r_assignment.tickets_assigned,
                        p_ticket_assignment_id => r_assignment.ticket_assignment_id);
                    l_status_code := 'SUCCESS';
                    l_status_message := 'created/updated ticket group assignment';
                exception
                    when others then
                        l_status_code := 'ERROR';
                        l_reseller_error_count := l_reseller_error_count + 1;
                        l_status_message := sqlerrm;
                end;
                
                o_group.put('ticket_assignment_id', r_assignment.ticket_assignment_id);
                o_group.put('status_code', l_status_code);
                o_group.put('status_message', l_status_message);
            
            end loop;
            
            o_reseller.put('reseller_status', case when l_reseller_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
            o_reseller.put('reseller_errors', l_reseller_error_count);
            l_error_count := l_error_count + l_reseller_error_count;
        
        end loop;
        
        --add status information for all resellers in the request
        o_request.put('request_status', case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        o_request.put('request_errors', l_error_count);
        
        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_ticket_assignments');
    end update_ticket_assignments;

    function get_event_ticket_prices
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return varchar2
    is
        l_json varchar2(4000);
    begin
    
        select b.json_doc
        into l_json
        from event_ticket_prices_v_json b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_ticket_prices');
    end get_event_ticket_prices;

    function get_event_series_ticket_prices
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return varchar2
    is
        l_json varchar2(4000);
    begin
    
        select b.json_doc
        into l_json
        from event_series_ticket_prices_v_json b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_series_ticket_prices');
    end get_event_series_ticket_prices;

    function get_event_tickets_available_all
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from tickets_available_all_v_json b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
        
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_all');
    end get_event_tickets_available_all;

    function get_event_tickets_available_venue
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from tickets_available_venue_v_json b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
        
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_venue');
    end get_event_tickets_available_venue;

    function get_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from tickets_available_reseller_v_json b
        where 
            b.event_id = p_event_id
            and b.reseller_id = p_reseller_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_reseller');
    end get_event_tickets_available_reseller;

    procedure purchase_tickets_get_customer
    (
        o_request in out nocopy json_object_t, 
        p_customer_id out number
    )
    is
        l_customer_email customers.customer_email%type;
        l_customer_name customers.customer_name%type;
    begin
        
        l_customer_email := o_request.get_string('customer_email');
        l_customer_name := o_request.get_string('customer_name');
        --validate customer by email, set v_customer_id if found, else create    
        events_api.create_customer(
            p_customer_name => l_customer_name,
            p_customer_email => l_customer_email,
            p_customer_id => p_customer_id);
   
        o_request.put('customer_id', p_customer_id);
    
    end purchase_tickets_get_customer;

    procedure purchase_tickets_get_group_request(
        o_group in out nocopy json_object_t,
        p_group_id out number,
        p_quantity out number,
        p_price out number,
        p_tickets_requested_all_groups in out number
    )
    is
        l_price_category ticket_groups.price_category%type;
    begin
        
        p_group_id := o_group.get_number('ticket_group_id');
        p_quantity := o_group.get_number('ticket_quantity_requested');
        p_price := o_group.get_number('price');
        
        l_price_category := events_api.get_ticket_group_category(p_group_id);    
        o_group.put('price_category', l_price_category);
        
        p_tickets_requested_all_groups := p_tickets_requested_all_groups + p_quantity;

    end purchase_tickets_get_group_request;

    procedure purchase_tickets_verify_requested_price
    (
        p_group_id in number,
        p_requested_price in number,
        p_actual_price out number
    )
    is
        l_error varchar2(1000);
    begin

        p_actual_price := events_api.get_current_ticket_price(p_ticket_group_id => p_group_id);
        if p_actual_price > p_requested_price then
            l_error := 'INVALID TICKET PRICE: CANCELLING TRANSACTION.  Price requested is ' || p_requested_price || ', current price is ' || p_actual_price;
            raise_application_error(-20100, l_error);
        end if;
            
    end purchase_tickets_verify_requested_price;

    procedure purchase_tickets_set_group_values_success
    (
        p_qty_requested in number,
        p_price in number,
        p_qty_purchased out number,
        p_sales_date out date,
        p_extended_price out number,
        p_qty_purchased_all_groups in out number,
        p_total_purchase_amount in out number,
        p_status_code out varchar2,
        p_status_message out varchar2
    )
    is
    begin
        
        p_status_code := 'SUCCESS';
        p_status_message := 'group tickets purchased';
        p_qty_purchased := p_qty_requested;
        p_sales_date := sysdate;
        p_extended_price := p_qty_purchased * p_price;
        p_qty_purchased_all_groups := p_qty_purchased_all_groups + p_qty_purchased;
        p_total_purchase_amount := p_total_purchase_amount + p_extended_price;

    end purchase_tickets_set_group_values_success;

    procedure purchase_tickets_set_group_values_error(
        p_sqlerrm in varchar2,
        p_status_code out varchar2,
        p_status_message in out varchar2,
        p_error_count in out number,
        p_qty_purchased out number,
        p_extended_price out number,
        p_sales_date out date,
        p_sales_id out number)
    is
    begin
        p_status_code := 'ERROR';
        p_status_message := p_sqlerrm;              
        p_error_count := p_error_count + 1;
        p_qty_purchased := 0;
        p_extended_price := 0;
        p_sales_date := null;
        p_sales_id := 0;
    end purchase_tickets_set_group_values_error;

    procedure purchase_tickets_update_group
    (
        o_group in out nocopy json_object_t,
        p_sales_id in number,
        p_sales_date in date,
        p_tickets_purchased in number,
        p_actual_price in number,
        p_extended_price in number,
        p_status_code in varchar2,
        p_status_message in varchar2
    )
    is
    begin
            
        --update the array element with results (updates request object by reference)
        o_group.put('ticket_sales_id', p_sales_id);
        o_group.put('sales_date', p_sales_date);
        o_group.put('ticket_quantity_purchased', p_tickets_purchased);
        o_group.put('actual_price', p_actual_price);
        o_group.put('extended_price', p_extended_price);
        o_group.put('status_code', p_status_code);
        o_group.put('status_message', p_status_message);

    end purchase_tickets_update_group;

    procedure purchase_tickets_update_request
    (
        o_request in out nocopy json_object_t,
        p_error_count in number,
        p_qty_requested_all_groups in number,
        p_qty_purchased_all_groups in number,
        p_total_purchase_amount in number
    )
    is
    begin

        --add status information for all ticket purchases in the request
        o_request.put('request_status',case when p_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        o_request.put('request_errors', p_error_count);
        o_request.put('total_tickets_requested', p_qty_requested_all_groups);
        o_request.put('total_tickets_purchased', p_qty_purchased_all_groups);
        o_request.put('total_purchase_amount', p_total_purchase_amount);
        o_request.put('purchase_disclaimer', 'All Ticket Sales Are Final.');
        
    end purchase_tickets_update_request;

    procedure purchase_tickets_from_reseller
    (
        p_json_doc in out nocopy clob
    )
    is
        l_event_id number;
        r_sale event_system.ticket_sales%rowtype;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_tickets_purchased_in_group number;
        l_ticket_price_requested number;
        l_actual_ticket_price number;
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;
        l_group_status_code varchar2(10);
        l_group_status_message varchar2(4000);
        l_total_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        l_event_id := o_request.get_number('event_id');
        r_sale.reseller_id := o_request.get_number('reseller_id');
   
        purchase_tickets_get_customer(o_request => o_request, p_customer_id => r_sale.customer_id);

        a_groups := o_request.get_array('ticket_groups');
        for group_index in 0..a_groups.get_size - 1 loop
        
            o_group := json_object_t(a_groups.get(group_index));

            purchase_tickets_get_group_request(
                o_group => o_group, 
                p_group_id => r_sale.ticket_group_id, 
                p_quantity => r_sale.ticket_quantity, 
                p_price => l_ticket_price_requested,
                p_tickets_requested_all_groups => l_total_tickets_requested);                            
        
            begin
            
                purchase_tickets_verify_requested_price(
                    p_group_id => r_sale.ticket_group_id, 
                    p_requested_price => l_ticket_price_requested, 
                    p_actual_price => l_actual_ticket_price);
            
                --purchase the tickets, this sets v_ticket_sales_id
                --this will verify availability for the reseller and group
                --raises an exception if tickets are not available
                events_api.purchase_tickets_from_reseller(
                    p_reseller_id => r_sale.reseller_id,
                    p_ticket_group_id => r_sale.ticket_group_id,
                    p_customer_id => r_sale.customer_id,
                    p_number_tickets => r_sale.ticket_quantity,
                    p_ticket_sales_id => r_sale.ticket_sales_id);

                purchase_tickets_set_group_values_success(
                    p_qty_requested => r_sale.ticket_quantity,
                    p_price => l_actual_ticket_price,
                    p_qty_purchased => l_tickets_purchased_in_group,
                    p_sales_date => r_sale.sales_date,
                    p_extended_price => r_sale.extended_price,
                    p_qty_purchased_all_groups => l_total_tickets_purchased,
                    p_total_purchase_amount => l_total_purchase_amount,
                    p_status_code => l_group_status_code,
                    p_status_message => l_group_status_message);
            
            exception
                when others then
                    purchase_tickets_set_group_values_error(
                        p_sqlerrm => sqlerrm,
                        p_status_code => l_group_status_code,
                        p_status_message => l_group_status_message,
                        p_error_count => l_total_error_count,
                        p_qty_purchased => l_tickets_purchased_in_group,
                        p_extended_price => r_sale.extended_price,
                        p_sales_date => r_sale.sales_date,
                        p_sales_id => r_sale.ticket_sales_id);
            end;
        
            purchase_tickets_update_group(
                o_group => o_group, 
                p_sales_id => r_sale.ticket_sales_id, 
                p_sales_date => r_sale.sales_date, 
                p_tickets_purchased => l_tickets_purchased_in_group,
                p_actual_price => l_actual_ticket_price,
                p_extended_price => r_sale.extended_price,
                p_status_code => l_group_status_code,
                p_status_message => l_group_status_message);
        
        end loop;
        
        purchase_tickets_update_request(
            o_request => o_request, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);
    
        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_from_reseller');
    end purchase_tickets_from_reseller;

    --see comments above purchase tickets from reseller for restrictions and error conditions
    procedure purchase_tickets_from_venue
    (
        p_json_doc in out nocopy clob
    )
    is
        l_event_id number;
        r_sale event_system.ticket_sales%rowtype;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_tickets_purchased_in_group number;
        l_ticket_price_requested number;
        l_actual_ticket_price number;
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;
        l_group_status_code varchar2(10);
        l_group_status_message varchar2(4000);
        l_total_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        l_event_id := o_request.get_number('event_id');

        purchase_tickets_get_customer(o_request => o_request, p_customer_id => r_sale.customer_id);

        a_groups := o_request.get_array('ticket_groups');
        for group_index in 0..a_groups.get_size - 1 loop        
            o_group := json_object_t(a_groups.get(group_index));
        
            purchase_tickets_get_group_request(
                            o_group => o_group, 
                            p_group_id => r_sale.ticket_group_id, 
                            p_quantity => r_sale.ticket_quantity, 
                            p_price => l_ticket_price_requested,
                            p_tickets_requested_all_groups => l_total_tickets_requested);                            
        
            begin

                purchase_tickets_verify_requested_price(
                                p_group_id => r_sale.ticket_group_id, 
                                p_requested_price => l_ticket_price_requested, 
                                p_actual_price => l_actual_ticket_price);
            
                --purchase the tickets, this sets v_ticket_sales_id
                --this will verify availability for the reseller and group
                --raises an exception if tickets are not available
                events_api.purchase_tickets_from_venue(
                                p_ticket_group_id => r_sale.ticket_group_id,
                                p_customer_id => r_sale.customer_id,
                                p_number_tickets => r_sale.ticket_quantity,
                                p_ticket_sales_id => r_sale.ticket_sales_id);

                purchase_tickets_set_group_values_success(
                                p_qty_requested => r_sale.ticket_quantity,
                                p_price => l_actual_ticket_price,
                                p_qty_purchased => l_tickets_purchased_in_group,
                                p_sales_date => r_sale.sales_date,
                                p_extended_price => r_sale.extended_price,
                                p_qty_purchased_all_groups => l_total_tickets_purchased,
                                p_total_purchase_amount => l_total_purchase_amount,
                                p_status_code => l_group_status_code,
                                p_status_message => l_group_status_message);
            
            exception
                when others then
                    purchase_tickets_set_group_values_error(
                        p_sqlerrm => sqlerrm,
                        p_status_code => l_group_status_code,
                        p_status_message => l_group_status_message,
                        p_error_count => l_total_error_count,
                        p_qty_purchased => l_tickets_purchased_in_group,
                        p_extended_price => r_sale.extended_price,
                        p_sales_date => r_sale.sales_date,
                        p_sales_id => r_sale.ticket_sales_id);
            end;
            
            purchase_tickets_update_group(
                                    o_group => o_group, 
                                    p_sales_id => r_sale.ticket_sales_id, 
                                    p_sales_date => r_sale.sales_date, 
                                    p_tickets_purchased => l_tickets_purchased_in_group,
                                    p_actual_price => l_actual_ticket_price,
                                    p_extended_price => r_sale.extended_price,
                                    p_status_code => l_group_status_code,
                                    p_status_message => l_group_status_message);
                    
        end loop;
   
        purchase_tickets_update_request(
                        o_request => o_request, 
                        p_error_count => l_total_error_count,
                        p_qty_requested_all_groups => l_total_tickets_requested,
                        p_qty_purchased_all_groups => l_total_tickets_purchased,
                        p_total_purchase_amount => l_total_purchase_amount);

        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_from_venue');
    end purchase_tickets_from_venue;

--get customer tickets purchased for event
--used to verify customer purchases
    function get_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number,
        p_formatted in boolean default false
    ) return varchar2
    is
        l_json varchar2(4000);
    begin
    
        select b.json_doc
        into l_json
        from customer_event_tickets_v_json b
        where 
            b.event_id = p_event_id 
            and b.customer_id = p_customer_id;
    
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_event_tickets');
    end get_customer_event_tickets;

--get customer tickets purchased for event
--use email to get customer_id
    function get_customer_event_tickets_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_id in number,
        p_formatted in boolean default false
    ) return varchar2
    is
        l_customer_id number;
        l_json varchar2(4000);   
    begin
       
        l_customer_id := events_api.get_customer_id(p_customer_email);
       
        select b.json_doc
        into l_json
        from customer_event_tickets_v_json b
        where 
            b.event_id = p_event_id 
            and b.customer_id = l_customer_id;
    
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
       
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_event_tickets_by_email');
    end get_customer_event_tickets_by_email;

begin
  null;
end events_json_api;