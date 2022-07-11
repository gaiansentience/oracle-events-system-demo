create or replace package body events_json_api
as

    function format_json_clob
    (
        p_json_doc in clob
    ) return clob
    is
        l_json clob;
    begin
    
        select json_serialize(p_json_doc returning clob pretty) 
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
    
        select json_serialize(p_json_doc returning clob pretty) 
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
        $if dbms_db_version.version >= 21 $then
        pragma suppresses_warning_6009(get_json_error_doc);
        --pragma works for exception handlers that return get_json_error_doc
        --pragma doesnt work for exception handlers that set in out parameter to get_json_error_doc
        $end
        o_error json_object_t := new json_object_t;
        l_json varchar2(4000);
    begin
    
        o_error.put('json_method', p_json_method);
        o_error.put('error_code', p_error_code);
        o_error.put('error_message', p_error_message);
        l_json := o_error.to_string();
       
        return format_json_string(l_json);
       
    end get_json_error_doc;

    procedure parse_customer
    (
        p_source in out nocopy json_object_t,
        p_customer out customers%rowtype
    )
    is
    begin
    
        p_customer.customer_id := p_source.get_string('customer_id');    
        p_customer.customer_name := p_source.get_string('customer_name');
        p_customer.customer_email := p_source.get_string('customer_email');
    
    end parse_customer;
    
    procedure create_customer
    (
        p_json_doc in out nocopy varchar2
    )
    is
        r_customer event_system.customers%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
        
        o_request := json_object_t.parse(p_json_doc);
        parse_customer(p_source => o_request, p_customer => r_customer);
        r_customer.customer_id := 0;
        
        begin                  
        
            events_api.create_customer(
                p_customer_name => r_customer.customer_name, 
                p_customer_email => r_customer.customer_email, 
                p_customer_id => r_customer.customer_id);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'Created customer';
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;
        
        o_request.put('customer_id', r_customer.customer_id);
        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);
        
        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_customer');
    end create_customer;
    
    procedure update_customer
    (
        p_json_doc in out nocopy varchar2
    )
    is
        r_customer event_system.customers%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
        
        o_request := json_object_t.parse(p_json_doc);
        parse_customer(p_source => o_request, p_customer => r_customer);
        
        begin                  
        
            events_api.update_customer(
                p_customer_id => r_customer.customer_id,
                p_customer_name => r_customer.customer_name, 
                p_customer_email => r_customer.customer_email);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'Updated customer';
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;
        
        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);
        
        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_customer');
    end update_customer;
    
    function get_customer
    (
        p_customer_id in number,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_json varchar2(4000);
    begin
    
        select b.json_doc
        into l_json
        from customers_v_json b
        where b.customer_id = p_customer_id;
    
        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_customer');
    end get_customer;

    function get_customer_id
    (
        p_customer_email in customers.customer_email%type,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_customer_id customers.customer_id%type;
    begin
    
        l_customer_id := events_api.get_customer_id(p_customer_email => p_customer_email);
        return get_customer(p_customer_id => l_customer_id, p_formatted => p_formatted);
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_id');
    end get_customer_id;

    procedure parse_reseller
    (
        p_source in out nocopy json_object_t,
        p_reseller out resellers%rowtype
    )
    is
    begin
    
        p_reseller.reseller_id := p_source.get_number('reseller_id');
        p_reseller.reseller_name := p_source.get_string('reseller_name');
        p_reseller.reseller_email := p_source.get_string('reseller_email');
        p_reseller.commission_percent := p_source.get_number('commission_percent');
    
    end parse_reseller;
    
    procedure create_reseller
    (
        p_json_doc in out nocopy varchar2
    )
    is
        r_reseller event_system.resellers%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        parse_reseller(p_source => o_request, p_reseller => r_reseller);        
        r_reseller.reseller_id := 0;
        
        begin     
        
            events_api.create_reseller(
                r_reseller.reseller_name, 
                r_reseller.reseller_email, 
                r_reseller.commission_percent, 
                r_reseller.reseller_id);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'Created reseller';
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;
        
        o_request.put('reseller_id', r_reseller.reseller_id);
        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);
        
        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_reseller');
    end create_reseller;

    procedure update_reseller
    (
        p_json_doc in out nocopy varchar2
    )
    is
        r_reseller event_system.resellers%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        parse_reseller(p_source => o_request, p_reseller => r_reseller);
        
        begin      
        
            events_api.update_reseller(
                p_reseller_id => r_reseller.reseller_id,
                p_reseller_name => r_reseller.reseller_name, 
                p_reseller_email => r_reseller.reseller_email, 
                p_commission_percent => r_reseller.commission_percent);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'Updated reseller';
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;
        
        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);
        
        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_reseller');
    end update_reseller;

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

    procedure parse_venue
    (
        p_source in out nocopy json_object_t,
        p_venue out venues%rowtype
    )
    is
    begin

        p_venue.venue_id := p_source.get_number('venue_id');
        p_venue.venue_name := p_source.get_string('venue_name');   
        p_venue.organizer_name := p_source.get_string('organizer_name');
        p_venue.organizer_email := p_source.get_string('organizer_email');
        p_venue.max_event_capacity := p_source.get_number('max_event_capacity');
    
    end parse_venue;

    procedure create_venue
    (
        p_json_doc in out nocopy varchar2
    )
    is
        r_venue event_system.venues%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        parse_venue(p_source => o_request, p_venue => r_venue);
        r_venue.venue_id := 0;
    
        begin         
        
            events_api.create_venue(
                p_venue_name => r_venue.venue_name, 
                p_organizer_name => r_venue.organizer_name, 
                p_organizer_email => r_venue.organizer_email, 
                p_max_event_capacity => r_venue.max_event_capacity, 
                p_venue_id => r_venue.venue_id);
                
                l_status_code := 'SUCCESS';
                l_status_message := 'Created venue';
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        o_request.put('venue_id', r_venue.venue_id);
        o_request.put('status_code',l_status_code);
        o_request.put('status_message', l_status_message);

        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_venue');
    end create_venue;

    procedure update_venue
    (
        p_json_doc in out nocopy varchar2
    )
    is
        r_venue event_system.venues%rowtype;
        o_request json_object_t;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        parse_venue(p_source => o_request, p_venue => r_venue);
    
        begin         
        
            events_api.update_venue(
                p_venue_id => r_venue.venue_id,
                p_venue_name => r_venue.venue_name, 
                p_organizer_name => r_venue.organizer_name, 
                p_organizer_email => r_venue.organizer_email, 
                p_max_event_capacity => r_venue.max_event_capacity);
                
                l_status_code := 'SUCCESS';
                l_status_message := 'Updated venue';
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        o_request.put('status_code',l_status_code);
        o_request.put('status_message', l_status_message);

        p_json_doc := o_request.to_string; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_venue');
    end update_venue;

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
    
    function get_venue_summary
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return varchar2
    is
        l_json varchar2(4000);
    begin

        select b.json_doc
        into l_json
        from venues_summary_v_json b
        where b.venue_id = p_venue_id;

        if p_formatted then
            l_json := format_json_string(l_json);
        end if;
        return l_json;
   
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_venue_summary');
    end get_venue_summary;
    
    function get_all_venues_summary
    (
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from all_venues_summary_v_json b;
        
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_all_venues_summary');
    end get_all_venues_summary;

    procedure create_event
    (
        p_json_doc in out nocopy varchar2
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
        p_json_doc in out nocopy clob
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
    
    procedure update_event
    (
        p_json_doc in out nocopy varchar2
    )
    is
        o_request json_object_t;
        l_event_id events.event_series_id%type;
        l_event_name events.event_name%type;
        l_event_date events.event_date%type;
        l_tickets_available events.tickets_available%type;
        l_status_code varchar2(20);
        l_status_message varchar2(4000);
    begin
        o_request := json_object_t.parse(p_json_doc);



        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);    
        p_json_doc := o_request.to_clob; 
    
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_event');
    end update_event;

    procedure update_event_series
    (
        p_json_doc in out nocopy varchar2
    )
    is
        o_request json_object_t;
        l_event_series_id events.event_series_id%type;
        l_event_name events.event_name%type;
        l_tickets_available events.tickets_available%type;
        l_status_code varchar2(20);
        l_status_message varchar2(4000);
    begin
        o_request := json_object_t.parse(p_json_doc);


        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);        
        p_json_doc := o_request.to_clob; 
    
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_event_series');
    end update_event_series;

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

    function get_event_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return clob
    is
        l_json clob;
    begin

/*    
        select b.json_doc
        into l_json
        from event_series_v_json b
        where b.event_series_id = p_event_series_id;
*/    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_series');    
    end get_event_series;
    
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

    function get_ticket_groups
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from event_ticket_groups_v_json b
        where b.event_id = p_event_id;
        
        if p_formatted then
            l_json := format_json_clob(l_json);
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
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from event_series_ticket_groups_v_json b
        where b.event_series_id = p_event_series_id;
        
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_groups_series');
    end get_ticket_groups_series;


/*
{
  "event_id" : 11,
  "ticket_groups" :
  [
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 100,
    }}
*/
--update ticket groups using a json document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
    procedure update_ticket_groups
    (
        p_json_doc in out nocopy clob
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
                            p_event_id => r_group.event_id, 
                            p_price_category => r_group.price_category, 
                            p_price => r_group.price, 
                            p_tickets => r_group.tickets_available, 
                            p_ticket_group_id => r_group.ticket_group_id);
                            
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
        
        p_json_doc := o_request.to_clob; 
   
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_ticket_groups');
    end update_ticket_groups;

/*
{
  "event_series_id" : 11,
  "ticket_groups" :
  [
    {
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 100,
    }}
*/

    procedure update_ticket_groups_series
    (
        p_json_doc in out nocopy clob
    )
    is
        r_group event_system.ticket_groups%rowtype;
        l_event_series_id events.event_series_id%type;
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;
        l_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        o_request := json_object_t.parse(p_json_doc);
        l_event_series_id := o_request.get_number('event_series_id');
        a_groups := o_request.get_array('ticket_groups');
        for i in 0..a_groups.get_size - 1 loop
        
            o_group := json_object_t(a_groups.get(i));
            r_group.price_category := o_group.get_string('price_category');
            r_group.price := o_group.get_number('price');
            r_group.tickets_available := o_group.get_number('tickets_available');
            
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
                    
                        events_api.create_ticket_group_event_series(
                            p_event_series_id => l_event_series_id, 
                            p_price_category => r_group.price_category, 
                            p_price => r_group.price, 
                            p_tickets => r_group.tickets_available, 
                            p_status_code => l_status_code,
                            p_status_message => l_status_message);
                            
                    exception
                        when others then
                            l_error_count := l_error_count + 1;
                            l_status_code := 'ERROR';
                            l_status_message := sqlerrm;
                    end;
            end case;
            
            o_group.put('status_code', l_status_code);
            o_group.put('status_message', l_status_message);
        
        end loop;

        o_request.put('request_status', case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        o_request.put('request_errors', l_error_count);
        
        p_json_doc := o_request.to_clob; 
   
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_ticket_groups_series');
    end update_ticket_groups_series;

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
        from event_system.event_ticket_assignment_v_json b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_assignments');
    end get_ticket_assignments;

    function get_ticket_assignments_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from event_system.event_series_ticket_assignment_v_json b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_assignments_series');
    end get_ticket_assignments_series;

--update ticket assignments for a reseller using a json document in the same format as get_ticket_assignments
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
--supports assignment of multiple ticket groups to multiple resellers
--WARNING:  IF MULTIPLE RESELLERS ARE SUBMITTED ASSIGNMENTS CAN EXCEED LIMITS CREATING MULTIPLE ERRORS AT THE END OF BATCH
--IT IS RECOMMENDED TO SUBMIT ASSIGNMENTS FOR ONE RESELLER AT A TIME AND REFRESH THE ASSIGNMENTS DOCUMENT TO SEE CHANGED LIMITS
--additional informational fields from get_event_reseller_ticket_assignments may be present
--if additional informational fields are present they will not be processed
/*
{
  "event_id" : 18,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 11,
      "ticket_assignments" :
      [
        {
          "ticket_group_id" : 27,
          "tickets_assigned" : 100
        }
      ]
    }
  ]
}
*/
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
/*
{
  "event_series_id" : 13,
  "ticket_resellers" :
  [
    {
      "reseller_id" : 21,
      "ticket_assignments" :
      [
        {
          "price_category" : "VIP PIT ACCESS",
          "tickets_assigned" : 0,
        }
      ]
    }
  ]
}
*/
    procedure update_ticket_assignments_series
    (
        p_json_doc in out nocopy clob
    )
    is
        l_event_series_id number;
        l_reseller_id event_system.resellers.reseller_id%type;
        l_price_category event_system.ticket_groups.price_category%type;
        l_tickets_assigned number;
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
        l_event_series_id := o_request.get_number('event_series_id');
        
        a_resellers := o_request.get_array('ticket_resellers');
        
        for r in 0..a_resellers.get_size - 1 loop
            l_reseller_id := 0;
            o_reseller := json_object_t(a_resellers.get(r));
            l_reseller_error_count := 0;
            l_reseller_id := o_reseller.get_number('reseller_id');
            
            a_groups := o_reseller.get_array('ticket_assignments');
            
            for g in 0..a_groups.get_size - 1 loop
                o_group := json_object_t(a_groups.get(g));
                l_price_category := null;
                l_tickets_assigned := 0;
                
                l_price_category := o_group.get_string('price_category');
                l_tickets_assigned := o_group.get_number('tickets_assigned');
                
                begin
                    events_api.create_ticket_assignment_event_series(
                        p_event_series_id => l_event_series_id,
                        p_reseller_id => l_reseller_id,
                        p_price_category => l_price_category,
                        p_number_tickets => l_tickets_assigned,
                        p_status_code => l_status_code,
                        p_status_message => l_status_message);
                exception
                    when others then
                        l_status_code := 'ERROR';
                        l_reseller_error_count := l_reseller_error_count + 1;
                        l_status_message := sqlerrm;
                end;
                
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
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_ticket_assignments_series');
    end update_ticket_assignments_series;

    function get_event_ticket_prices
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from event_ticket_prices_v_json b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
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
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from event_series_ticket_prices_v_json b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
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

    function get_event_series_tickets_available_all
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from tickets_available_series_all_v_json b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
        
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_series_tickets_available_all');
    end get_event_series_tickets_available_all;

    function get_event_series_tickets_available_venue
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from tickets_available_series_venue_v_json b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
        
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_series_tickets_available_venue');
    end get_event_series_tickets_available_venue;

    function get_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from tickets_available_series_reseller_v_json b
        where 
            b.event_series_id = p_event_series_id
            and b.reseller_id = p_reseller_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_event_series_tickets_available_reseller');
    end get_event_series_tickets_available_reseller;

    procedure purchase_get_customer
    (
        o_request in out nocopy json_object_t, 
        p_customer_id out number
    )
    is
        r_customer customers%rowtype;
    begin
        
        r_customer.customer_email := o_request.get_string('customer_email');
        r_customer.customer_name := o_request.get_string('customer_name');
        --validate customer by email, set v_customer_id if found, else create  
        
        p_customer_id := events_api.get_customer_id(r_customer.customer_email);
        if p_customer_id = 0 then
            --need to create customer, if name was not specified use email for name
            if r_customer.customer_name is null then
                r_customer.customer_name := r_customer.customer_email;
            end if;
            events_api.create_customer(
                p_customer_name => r_customer.customer_name,
                p_customer_email => r_customer.customer_email,
                p_customer_id => p_customer_id);
        end if;
   
        o_request.put('customer_id', p_customer_id);
    
    end purchase_get_customer;
        
    procedure purchase_update_group
    (
        o_group in out nocopy json_object_t,
        p_purchase in events_api.r_purchase,
        p_is_series in boolean
    )
    is
    begin

        if p_is_series then
            o_group.put('average_price', p_purchase.average_price);
        else
            o_group.put('ticket_sales_id', p_purchase.ticket_sales_id);
            o_group.put('actual_price', p_purchase.actual_price);
        end if;
        
        o_group.put('tickets_purchased', p_purchase.tickets_purchased);
        o_group.put('purchase_amount', p_purchase.purchase_amount);
        o_group.put('status_code', p_purchase.status_code);
        o_group.put('status_message', p_purchase.status_message);

    end purchase_update_group;

    procedure purchase_update_request
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
        
    end purchase_update_request;

    procedure purchase_tickets_reseller
    (
        p_json_doc in out nocopy clob
    )
    is
        l_purchase events_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
                
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;        
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_purchase.event_id := o_request.get_number('event_id');
        l_purchase.reseller_id := o_request.get_number('reseller_id');   
        purchase_get_customer(o_request => o_request, p_customer_id => l_purchase.customer_id);

        a_groups := o_request.get_array('ticket_groups');
        for group_index in 0..a_groups.get_size - 1 loop        
            o_group := json_object_t(a_groups.get(group_index));

            l_purchase.ticket_group_id := o_group.get_number('ticket_group_id');
            l_purchase.price_category := events_api.get_ticket_group_category(l_purchase.ticket_group_id);    
            o_group.put('price_category', l_purchase.price_category);
            l_purchase.tickets_requested := o_group.get_number('tickets_requested');
            l_purchase.price_requested := o_group.get_number('price');
                    
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;
        
            begin
                        
                events_api.purchase_tickets_reseller(p_purchase => l_purchase);

                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
            
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;
         
            purchase_update_group(o_group => o_group, p_purchase => l_purchase, p_is_series => false);
        
        end loop;
        
        purchase_update_request(
            o_request => o_request, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);
    
        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_reseller');
    end purchase_tickets_reseller;

    --see comments above purchase tickets from reseller for restrictions and error conditions
    procedure purchase_tickets_venue
    (
        p_json_doc in out nocopy clob
    )
    is
        l_purchase events_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
        
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;        
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_purchase.event_id := o_request.get_number('event_id');
        purchase_get_customer(o_request => o_request, p_customer_id => l_purchase.customer_id);

        a_groups := o_request.get_array('ticket_groups');
        for group_index in 0..a_groups.get_size - 1 loop        
            o_group := json_object_t(a_groups.get(group_index));
        
            l_purchase.ticket_group_id := o_group.get_number('ticket_group_id');
            l_purchase.price_category := events_api.get_ticket_group_category(l_purchase.ticket_group_id);    
            o_group.put('price_category', l_purchase.price_category);
            l_purchase.tickets_requested := o_group.get_number('tickets_requested');
            l_purchase.price_requested := o_group.get_number('price');
            
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;
        
            begin

                events_api.purchase_tickets_venue(p_purchase => l_purchase);

                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
            
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;
             
            purchase_update_group(o_group => o_group, p_purchase => l_purchase, p_is_series => false);
                    
        end loop;
   
        purchase_update_request(
            o_request => o_request, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);

        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_venue');
    end purchase_tickets_venue;

    procedure purchase_tickets_reseller_series
    (
        p_json_doc in out nocopy clob
    )
    is
        l_purchase events_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
                
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;        
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_purchase.event_series_id := o_request.get_number('event_series_id');
        l_purchase.reseller_id := o_request.get_number('reseller_id');
        purchase_get_customer(o_request => o_request, p_customer_id => l_purchase.customer_id);

        a_groups := o_request.get_array('ticket_groups');
        for group_index in 0..a_groups.get_size - 1 loop        
            o_group := json_object_t(a_groups.get(group_index));

            l_purchase.price_category := o_group.get_string('price_category');
            l_purchase.tickets_requested := o_group.get_number('tickets_requested');
            l_purchase.price_requested := o_group.get_number('price');                    
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;
        
            begin
            
                events_api.purchase_tickets_reseller_series(p_purchase => l_purchase);
                    
                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
                                
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;
         
            purchase_update_group(o_group => o_group, p_purchase => l_purchase, p_is_series => true);
        
         end loop;
        
        purchase_update_request(
            o_request => o_request, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);
    
        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_reseller_series');
    end purchase_tickets_reseller_series;

    --see comments above purchase tickets from reseller for restrictions and error conditions
    procedure purchase_tickets_venue_series
    (
        p_json_doc in out nocopy clob
    )
    is
        l_purchase events_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
        
        o_request json_object_t;
        a_groups json_array_t;
        o_group json_object_t;        
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_purchase.event_series_id := o_request.get_number('event_series_id');
        purchase_get_customer(o_request => o_request, p_customer_id => l_purchase.customer_id);

        a_groups := o_request.get_array('ticket_groups');
        for group_index in 0..a_groups.get_size - 1 loop        
            o_group := json_object_t(a_groups.get(group_index));
        
            l_purchase.price_category := o_group.get_string('price_category');
            l_purchase.tickets_requested := o_group.get_number('tickets_requested');
            l_purchase.price_requested := o_group.get_number('price');                    
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;
        
            begin
            
                events_api.purchase_tickets_venue_series(p_purchase => l_purchase);
                                    
                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
            
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;
             
            purchase_update_group(o_group => o_group, p_purchase => l_purchase, p_is_series => true);
                    
        end loop;
   
        purchase_update_request(
            o_request => o_request, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);

        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_venue_series');
    end purchase_tickets_venue_series;
    
--get customer tickets purchased for event
--used to verify customer purchases
    function get_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from customer_event_tickets_v_json b
        where 
            b.event_id = p_event_id 
            and b.customer_id = p_customer_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
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
    ) return clob
    is
        l_customer_id number;
        l_json clob;   
    begin
       
        l_customer_id := events_api.get_customer_id(p_customer_email);
        
        return get_customer_event_tickets(l_customer_id, p_event_id, p_formatted);
              
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_event_tickets_by_email');
    end get_customer_event_tickets_by_email;

    function get_customer_event_series_tickets
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_json clob;
    begin
    
        select b.json_doc
        into l_json
        from customer_event_series_tickets_v_json b
        where 
            b.event_series_id = p_event_series_id 
            and b.customer_id = p_customer_id;
    
        if p_formatted then
            l_json := format_json_clob(l_json);
        end if;
        return l_json;
    
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_event_series_tickets');
    end get_customer_event_series_tickets;

--get customer tickets purchased for event
--use email to get customer_id
    function get_customer_event_series_tickets_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return clob
    is
        l_customer_id number;
        l_json clob;   
    begin
       
        l_customer_id := events_api.get_customer_id(p_customer_email);
        
        return get_customer_event_series_tickets(l_customer_id, p_event_series_id, p_formatted);
              
    exception
        when others then
            return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_event_series_tickets_by_email');
    end get_customer_event_series_tickets_by_email;

--print tickets by ticket_sales_id

--reissue tickets



    procedure ticket_validate
    (
        p_json_doc in out nocopy clob
    )
    is
        l_event_id events.event_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        o_request json_object_t;
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_event_id := o_request.get_number('event_id');
        l_serial_code := o_request.get_string('serial_code');   

        begin
        
            events_api.ticket_validate(
                p_event_id => l_event_id,
                p_serial_code => l_serial_code);
            
            l_status_code := 'SUCCESS';
            l_status_message := 'VALIDATED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);

        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'ticket_validate');
    end ticket_validate;

    procedure ticket_verify_validation
    (
        p_json_doc in out nocopy clob
    )
    is
        l_event_id events.event_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        o_request json_object_t;
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_event_id := o_request.get_number('event_id');
        l_serial_code := o_request.get_string('serial_code');   

        begin
            
            events_api.ticket_verify_validation(
                p_event_id => l_event_id,
                p_serial_code => l_serial_code);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'VERIFIED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);

        p_json_doc := o_request.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'ticket_verify_validation');    
    end ticket_verify_validation;
    
    procedure ticket_verify_restricted_access
    (
        p_json_doc in out nocopy clob
    )
    is
        l_ticket_group_id ticket_groups.ticket_group_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        o_request json_object_t;
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_ticket_group_id := o_request.get_number('ticket_group_id');
        l_serial_code := o_request.get_string('serial_code');   

        begin
            
            events_api.ticket_verify_restricted_access(
                p_ticket_group_id => l_ticket_group_id,
                p_serial_code => l_serial_code);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'ACCESS VERIFIED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);

        p_json_doc := o_request.to_clob; 
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'ticket_verify_restricted_access');    
    end ticket_verify_restricted_access;
    
    procedure ticket_cancel
    (
        p_json_doc in out nocopy clob
    )
    is
        l_event_id events.event_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        o_request json_object_t;
    begin
        o_request := json_object_t.parse(p_json_doc);
        l_event_id := o_request.get_number('event_id');
        l_serial_code := o_request.get_string('serial_code');   

        begin
            
            events_api.ticket_cancel(
                p_event_id => l_event_id,
                p_serial_code => l_serial_code);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'CANCELLED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        o_request.put('status_code', l_status_code);
        o_request.put('status_message', l_status_message);

        p_json_doc := o_request.to_clob; 
    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'ticket_cancel');
    end ticket_cancel;

begin
  null;
end events_json_api;