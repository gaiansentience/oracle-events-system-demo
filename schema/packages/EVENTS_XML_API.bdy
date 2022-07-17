create or replace package body events_xml_api
as

    function format_xml_clob(
        p_xml_doc in xmltype
    ) return xmltype
    is
        l_xml_clob clob;
    begin
    
        select xmlserialize(content p_xml_doc as clob indent) 
        into l_xml_clob 
        from dual;
    
        return xmltype(l_xml_clob);
    
    end format_xml_clob;
    
    function format_xml_string(
        p_xml_doc in xmltype
    ) return xmltype
    is
        l_xml_varchar varchar2(32000);
    begin
    
        select xmlserialize(content p_xml_doc as clob indent) 
        into l_xml_varchar 
        from dual;
    
        return xmltype(l_xml_varchar);
    
    end format_xml_string;

    function get_xml_error_doc
    (
        p_error_code in number,
        p_error_message in varchar2,
        p_xml_method in varchar2
    ) return xmltype
    is
        $if dbms_db_version.version >= 21 $then
        pragma suppresses_warning_6009(get_xml_error_doc);
        --pragma works for exception handlers that return get_xml_error_doc
        --pragma doesnt work for exception handlers that set in out parameter to get_xml_error_doc     
        $end
        l_xml xmltype;
        nRoot dbms_xmldom.DOMnode;
    begin
    
        --write the error message to the logs
        util_error_api.log_error(
            p_error_message => p_error_message, 
            p_error_code => p_error_code, 
            p_locale => 'events_xml_api.' || p_xml_method);
    
        util_xmldom_helper.newDoc(p_root_tag => 'service_error_report', p_root_node => nRoot);
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'xml_service_method', p_data => p_xml_method);
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'error_code', p_data => p_error_code);
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'error_message', p_data => p_error_message);
        l_xml := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;
    
        return format_xml_string(l_xml);
       
    end get_xml_error_doc;

    procedure parse_customer
    (
        p_source in out nocopy dbms_xmldom.DOMnode,
        p_customer out customers%rowtype
    )
    is
    begin
        dbms_xslprocessor.valueof(p_source, 'customer_id/text()', p_customer.customer_id);
        dbms_xslprocessor.valueof(p_source, 'customer_name/text()', p_customer.customer_name);
        dbms_xslprocessor.valueof(p_source, 'customer_email/text()', p_customer.customer_email);
    end parse_customer;
    
    procedure create_customer
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        r_customer event_system.customers%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nCustomer dbms_xmldom.DOMnode;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nCustomer := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/create_customer/customer');
        parse_customer(p_source => nCustomer, p_customer => r_customer);
        r_customer.customer_id := 0;
    
        begin                  
        
            customer_api.create_customer(
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

        util_xmldom_helper.addTextNode(p_parent => nCustomer, p_tag => 'customer_id', p_data => r_customer.customer_id);
        util_xmldom_helper.addTextNode(p_parent => nCustomer, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nCustomer, p_tag => 'status_message', p_data => l_status_message);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'create_customer');
    end create_customer;
    
    procedure update_customer
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        r_customer event_system.customers%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nCustomer dbms_xmldom.DOMnode;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nCustomer := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/update_customer/customer');
        parse_customer(p_source => nCustomer, p_customer => r_customer);
    
        begin                  
        
            customer_api.update_customer(
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

        util_xmldom_helper.addTextNode(p_parent => nCustomer, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nCustomer, p_tag => 'status_message', p_data => l_status_message);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_customer');
    end update_customer;
    
    function get_customer
    (
        p_customer_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc 
        into l_xml
        from customers_v_xml b
        where b.customer_id = p_customer_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer');
    end get_customer;

    function get_customer_id
    (
        p_customer_email in customers.customer_email%type,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
        l_customer_id number;
    begin
    
        l_customer_id := customer_api.get_customer_id(p_customer_email => p_customer_email);
        
        return get_customer(p_customer_id => l_customer_id, p_formatted => p_formatted);
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_id');
    end get_customer_id;

    procedure parse_reseller
    (
        p_source in out nocopy dbms_xmldom.DOMnode,
        p_reseller out resellers%rowtype
    )
    is
    begin
        dbms_xslprocessor.valueof(p_source, 'reseller_id/text()', p_reseller.reseller_id);
        dbms_xslprocessor.valueof(p_source, 'reseller_name/text()', p_reseller.reseller_name);
        dbms_xslprocessor.valueof(p_source, 'reseller_email/text()', p_reseller.reseller_email);
        dbms_xslprocessor.valueof(p_source, 'commission_percent/text()', p_reseller.commission_percent);        
    end parse_reseller;

    procedure create_reseller
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        r_reseller event_system.resellers%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nReseller dbms_xmldom.DOMnode;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nReseller := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/create_reseller/reseller');
        parse_reseller(p_source => nReseller, p_reseller => r_reseller);
        r_reseller.reseller_id := 0;
        
        begin         
        
            reseller_api.create_reseller(
                p_reseller_name => r_reseller.reseller_name, 
                p_reseller_email => r_reseller.reseller_email, 
                p_commission_percent => r_reseller.commission_percent, 
                p_reseller_id => r_reseller.reseller_id);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'Created reseller';
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;
        
        util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'reseller_id', p_data => r_reseller.reseller_id);
        util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'status_message', p_data => l_status_message);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;
        
    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'create_reseller');
    end create_reseller;

    procedure update_reseller
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        r_reseller event_system.resellers%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nReseller dbms_xmldom.DOMnode;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nReseller := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/update_reseller/reseller');
        parse_reseller(p_source => nReseller, p_reseller => r_reseller);
        
        begin   
        
            reseller_api.update_reseller(
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
        
        util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'status_message', p_data => l_status_message);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;
        
    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_reseller');
    end update_reseller;

    function get_reseller
    (
        p_reseller_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from resellers_v_xml b
        where b.reseller_id = p_reseller_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_reseller');
    end get_reseller;

    function get_all_resellers
    (
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from all_resellers_v_xml b;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_all_resellers');
    end get_all_resellers;
    
    procedure parse_venue
    (
        p_source in out nocopy dbms_xmldom.DOMnode,
        p_venue out venues%rowtype
    )
    is
    begin
        dbms_xslprocessor.valueof(p_source, 'venue_id/text()', p_venue.venue_id);
        dbms_xslprocessor.valueof(p_source, 'venue_name/text()', p_venue.venue_name);
        dbms_xslprocessor.valueof(p_source, 'organizer_name/text()', p_venue.organizer_name);
        dbms_xslprocessor.valueof(p_source, 'organizer_email/text()', p_venue.organizer_email);  
        dbms_xslprocessor.valueof(p_source, 'max_event_capacity/text()', p_venue.max_event_capacity);  
    end parse_venue;

    procedure create_venue
    (
       p_xml_doc in out nocopy xmltype
    )
    is
        r_venue event_system.venues%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nVenue dbms_xmldom.DOMnode;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nVenue := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/create_venue/venue');        
        parse_venue(p_source => nVenue, p_venue => r_venue);        
        r_venue.venue_id := 0;

        begin   
        
            venue_api.create_venue(
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
        
        util_xmldom_helper.addTextNode(p_parent => nVenue, p_tag => 'venue_id', p_data => r_venue.venue_id);
        util_xmldom_helper.addTextNode(p_parent => nVenue, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nVenue, p_tag => 'status_message', p_data => l_status_message);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;
        
    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'create_venue');
    end create_venue;

    procedure update_venue
    (
       p_xml_doc in out nocopy xmltype
    )
    is
        r_venue event_system.venues%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nVenue dbms_xmldom.DOMnode;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nVenue := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/update_venue/venue');                
        parse_venue(p_source => nVenue, p_venue => r_venue);
        
        begin   
        
            venue_api.update_venue(
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
        
        util_xmldom_helper.addTextNode(p_parent => nVenue, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nVenue, p_tag => 'status_message', p_data => l_status_message);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;
        
    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_venue');
    end update_venue;

    function get_venue
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc 
        into l_xml
        from venues_v_xml b
        where b.venue_id = p_venue_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_venue');
    end get_venue;

    function get_all_venues
    (
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from all_venues_v_xml b;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_all_venues');
    end get_all_venues;

    function get_venue_summary
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc 
        into l_xml
        from venues_summary_v_xml b
        where b.venue_id = p_venue_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_venue_summary');
    end get_venue_summary;

    function get_all_venues_summary
    (
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from all_venues_summary_v_xml b;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_all_venues_summary');
    end get_all_venues_summary;
               
    procedure create_event
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        r_event event_system.events%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nEvent dbms_xmldom.DOMnode;
        l_date_string varchar2(50);
        l_date_mask varchar2(20) := 'yyyy-mm-dd';
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nEvent := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/create_event/event');        
        
        
        dbms_xslprocessor.valueof(nEvent, 'venue/venue_id/text()', r_event.venue_id);
        dbms_xslprocessor.valueof(nEvent, 'event_name/text()', r_event.event_name);
        dbms_xslprocessor.valueof(nEvent, 'event_date/text()', l_date_string);
        r_event.event_date := to_date(l_date_string, l_date_mask);  
        
        dbms_xslprocessor.valueof(nEvent, 'tickets_available/text()', r_event.tickets_available);  
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
                    event_setup_api.create_event(
                        r_event.venue_id, 
                        r_event.event_name, 
                        r_event.event_date, 
                        r_event.tickets_available, 
                        r_event.event_id);
                    l_status_code := 'SUCCESS';
                    l_status_message := 'Created event';
                exception
                    when others then
                        l_status_code := 'ERROR';
                        l_status_message := sqlerrm;
                end;
        end case;

        util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'event_id', p_data => r_event.event_id);
        util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'status_message', p_data => l_status_message);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'create_event');
    end create_event;
    
    procedure create_weekly_event
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_venue_id venues.venue_id%type;
        l_event_name events.event_name%type;
        l_event_start_date date;
        l_event_end_date date;
        l_event_day varchar2(20);
        l_tickets_available events.tickets_available%type;
        
        nRoot dbms_xmldom.DOMnode;
        nEventSeries dbms_xmldom.DOMnode;
        nEventDetails dbms_xmldom.DOMnode;
        nEvent dbms_xmldom.DOMnode;
        l_date_string varchar2(50);
        l_date_mask varchar2(20) := 'yyyy-mm-dd';
        
        l_event_series_id number;        
        t_status_details event_setup_api.t_series_event;
        l_status_code varchar2(20);
        l_status_message varchar2(4000);
    begin

        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nEventSeries := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/create_event_series/event_series');        
        
        dbms_xslprocessor.valueof(nEventSeries, 'venue/venue_id/text()', l_venue_id);
        dbms_xslprocessor.valueof(nEventSeries, 'event_name/text()', l_event_name);
        
        dbms_xslprocessor.valueof(nEventSeries, 'event_start_date/text()', l_date_string);
        l_event_start_date := to_date(l_date_string, l_date_mask);  

        dbms_xslprocessor.valueof(nEventSeries, 'event_end_date/text()', l_date_string);
        l_event_end_date := to_date(l_date_string, l_date_mask);  

        dbms_xslprocessor.valueof(nEventSeries, 'event_day/text()', l_event_day);          
        dbms_xslprocessor.valueof(nEventSeries, 'tickets_available/text()', l_tickets_available);  

        event_setup_api.create_weekly_event(
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

        util_xmldom_helper.addTextNode(p_parent => nEventSeries, p_tag => 'event_series_id', p_data => l_event_series_id);
        util_xmldom_helper.addTextNode(p_parent => nEventSeries, p_tag => 'request_status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nEventSeries, p_tag => 'request_status_message', p_data => l_status_message);
        util_xmldom_helper.addNode(p_parent => nRoot, p_tag => 'event_series_details', p_node => nEventDetails);
        for i in 1..t_status_details.count loop
            util_xmldom_helper.addNode(p_parent => nEventDetails, p_tag => 'event', p_node => nEvent);

            util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'event_id', p_data => t_status_details(i).event_id);
            util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'event_date', p_data => t_status_details(i).event_date);
            util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'status_code', p_data => t_status_details(i).status_code);
            util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'status_message', p_data => t_status_details(i).status_message);            
        end loop;

        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'create_weekly_event');
    end create_weekly_event;

    procedure update_event
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        nRoot dbms_xmldom.DOMnode;
        nEvent dbms_xmldom.DOMnode;
        l_event_id events.event_series_id%type;
        l_event_name events.event_name%type;
        l_date_string varchar2(50);
        l_date_mask varchar2(20) := 'yyyy-mm-dd';        
        l_event_date events.event_date%type;
        l_tickets_available events.tickets_available%type;
        l_status_code varchar2(20);
        l_status_message varchar2(4000);
    begin

        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nEvent := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/update_event/event');  
        
        dbms_xslprocessor.valueof(nEvent, 'event_id/text()', l_event_id);
        dbms_xslprocessor.valueof(nEvent, 'event_name/text()', l_event_name);
        dbms_xslprocessor.valueof(nEvent, 'event_date/text()', l_date_string);
        l_event_date := to_date(l_date_string, l_date_mask);  
        
        dbms_xslprocessor.valueof(nEvent, 'tickets_available/text()', l_tickets_available);  

        begin
        
            event_setup_api.update_event
                (p_event_id => l_event_id,
                p_event_name => l_event_name,
                p_event_date => l_event_date,
                p_tickets_available => l_tickets_available);
            
            l_status_code := 'SUCCESS';
            l_status_message := 'Event information updated';

        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nEvent, p_tag => 'status_message', p_data => l_status_message);            
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_event');
    end update_event;

    procedure update_event_series
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        nRoot dbms_xmldom.DOMnode;
        nEventSeries dbms_xmldom.DOMnode;
        l_event_series_id events.event_series_id%type;
        l_event_name events.event_name%type;
        l_tickets_available events.tickets_available%type;
        l_status_code varchar2(20);
        l_status_message varchar2(4000);
    begin

        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);
        nEventSeries := dbms_xslprocessor.selectSingleNode(n => nRoot, pattern => '/update_event_series/event_series');        

        dbms_xslprocessor.valueof(nEventSeries, 'event_series_id/text()', l_event_series_id);    
        dbms_xslprocessor.valueof(nEventSeries, 'event_name/text()', l_event_name);        
        dbms_xslprocessor.valueof(nEventSeries, 'tickets_available/text()', l_tickets_available);  
    
        begin
        
            event_setup_api.update_event_series(
                p_event_series_id => l_event_series_id,
                p_event_name => l_event_name,
                p_tickets_available => l_tickets_available);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'All events in series that have not occurred have been updated.';
        exception
            when others then 
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;
        
        util_xmldom_helper.addTextNode(p_parent => nEventSeries, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nEventSeries, p_tag => 'status_message', p_data => l_status_message);            
    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_event_series');
    end update_event_series;

    function get_event
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from events_v_xml b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event');
    end get_event;

    function get_event_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin

        select b.xml_doc
        into l_xml
        from event_series_v_xml b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_series');
    end get_event_series;

    function get_venue_events
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from venue_events_v_xml b
        where b.venue_id = p_venue_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_venue_events');
    end get_venue_events;

    function get_venue_event_series
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from venue_event_series_v_xml b
        where b.venue_id = p_venue_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_venue_event_series');
    end get_venue_event_series;

    function get_ticket_groups
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc 
        into l_xml
        from event_ticket_groups_v_xml b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_ticket_groups');
    end get_ticket_groups;

    function get_ticket_groups_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc 
        into l_xml
        from event_series_ticket_groups_v_xml b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_ticket_groups_series');
    end get_ticket_groups_series;

/*
<event_ticket_groups>
  <event>
    <event_id>420</event_id>
  </event>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>100</tickets_available>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>
*/
--create/update ticket groups using an xml document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
/*
<event_ticket_groups>
  <event>
    <event_id>420</event_id>
  </event>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>100</tickets_available>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>
*/

    procedure update_ticket_groups
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        r_group event_system.ticket_groups%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;
        l_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);

        dbms_xslprocessor.valueof(nRoot, 'event/event_id/text()', r_group.event_id);
        
        nListGroups := dbms_xslprocessor.selectNodes(n => nRoot, pattern => '/event_ticket_groups/ticket_groups/ticket_group');
        for i in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
            nGroup := dbms_xmldom.item(nListGroups, i);
        
            dbms_xslprocessor.valueof(nGroup, 'price_category/text()', r_group.price_category);
            dbms_xslprocessor.valueof(nGroup, 'price/text()', r_group.price);
            dbms_xslprocessor.valueof(nGroup, 'tickets_available/text()', r_group.tickets_available);
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
                    
                        event_setup_api.create_ticket_group(
                            p_event_id => r_group.event_id, 
                            p_price_category => r_group.price_category, 
                            p_price => r_group.price, 
                            p_tickets => r_group.tickets_available, 
                            p_ticket_group_id => r_group.ticket_group_id);
                                                
                        l_status_code := 'SUCCESS';
                        l_status_message := 'Created or updated ticket group';
                    exception
                        when others then
                            l_error_count := l_error_count + 1;
                            l_status_code := 'ERROR';
                            l_status_message := sqlerrm;
                    end;
            end case;

            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'ticket_group_id', p_data => r_group.ticket_group_id);
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_code', p_data => l_status_code);
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_message', p_data => l_status_message);            
        end loop;

        --add status information for all groups in the request
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_status', p_data => case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_errors', p_data => l_error_count);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_ticket_groups');
    end update_ticket_groups;
    
/*
<event_series_ticket_groups>
  <event_series>
    <event_series_id>11</event_series_id>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>100</tickets_available>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_groups>
*/
    procedure update_ticket_groups_series
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_event_series_id event_system.events.event_series_id%type;
        r_group event_system.ticket_groups%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;
        l_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin

        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);

        dbms_xslprocessor.valueof(nRoot, 'event_series/event_series_id/text()', l_event_series_id);
        
        nListGroups := dbms_xslprocessor.selectNodes(n => nRoot, pattern => '/event_series_ticket_groups/ticket_groups/ticket_group');
        for i in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
            nGroup := dbms_xmldom.item(nListGroups, i);
        
            dbms_xslprocessor.valueof(nGroup, 'price_category/text()', r_group.price_category);
            dbms_xslprocessor.valueof(nGroup, 'price/text()', r_group.price);
            dbms_xslprocessor.valueof(nGroup, 'tickets_available/text()', r_group.tickets_available);
--            r_group.ticket_group_id := 0;
            
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
                                                
                        event_setup_api.create_ticket_group_event_series(
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

            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_code', p_data => l_status_code);
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_message', p_data => l_status_message);            
        end loop;

        --add status information for all groups in the request
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_status', p_data => case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_errors', p_data => l_error_count);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_ticket_groups_series');
    end update_ticket_groups_series;

--return possible reseller ticket assignments for event as json document
--returns array of all resellers with ticket groups as nested array
    function get_ticket_assignments
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from event_system.event_ticket_assignment_v_xml b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_ticket_assignments');
    end get_ticket_assignments;

    function get_ticket_assignments_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from event_system.event_series_ticket_assignment_v_xml b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_ticket_assignments_series');
    end get_ticket_assignments_series;

--update ticket assignments for a reseller using a xml document in the same format as get_ticket_assignments
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
--supports assignment of multiple ticket groups to multiple resellers
--WARNING:  IF MULTIPLE RESELLERS ARE SUBMITTED ASSIGNMENTS CAN EXCEED LIMITS CREATING MULTIPLE ERRORS AT THE END OF BATCH
--IT IS RECOMMENDED TO SUBMIT ASSIGNMENTS FOR ONE RESELLER AT A TIME AND REFRESH THE ASSIGNMENTS DOCUMENT TO SEE CHANGED LIMITS
--additional informational fields from get_ticket_assignments may be present
--if additional informational fields are present they will not be processed
/*
<event_ticket_assignment>
  <event>
    <event_id>15</event_id>
  </event>
  <ticket_resellers>
    <reseller>
      <reseller_id>21</reseller_id>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>953</ticket_group_id>
          <tickets_assigned>0</tickets_assigned>
        </ticket_group>
...
      </ticket_assignments>
    </reseller>
...
  </ticket_resellers>
</event_ticket_assignment>
*/
    procedure update_ticket_assignments
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_event_id number;
        r_assignment event_system.ticket_assignments%rowtype;
        nRoot dbms_xmldom.DOMnode;
        nListResellers dbms_xmldom.DOMnodeList;
        nReseller dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;
        l_reseller_error_count number := 0;
        l_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);

        dbms_xslprocessor.valueof(nRoot, 'event/event_id/text()', l_event_id);
        
        nListResellers := dbms_xslprocessor.selectNodes(n => nRoot, pattern => 'ticket_resellers/reseller');
        for r in 0..dbms_xmldom.getLength(nListResellers) - 1 loop
            nReseller := dbms_xmldom.item(nListResellers, r);
        
            dbms_xslprocessor.valueof(nReseller, 'reseller_id/text()', r_assignment.reseller_id);
            l_reseller_error_count := 0;
            
            nListGroups := dbms_xslprocessor.selectNodes(n => nReseller, pattern => 'ticket_assignments/ticket_group');
            for g in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
                nGroup := dbms_xmldom.item(nListGroups, g);
                
                dbms_xslprocessor.valueof(nGroup, 'ticket_group_id/text()', r_assignment.ticket_group_id);
                dbms_xslprocessor.valueof(nGroup, 'tickets_assigned/text()', r_assignment.tickets_assigned);
                r_assignment.ticket_assignment_id := 0;

                begin
                    event_setup_api.create_ticket_assignment(
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

                util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'ticket_assignment_id', p_data => r_assignment.ticket_assignment_id);
                util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_code', p_data => l_status_code);
                util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_message', p_data => l_status_message);

            end loop;

            --update the reseller array element
            util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'reseller_status', p_data => case when l_reseller_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
            util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'reseller_errors', p_data => l_reseller_error_count);
            l_error_count := l_error_count + l_reseller_error_count;

        end loop;
   
        --add status information for all resellers in the request
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_status', p_data => case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_errors', p_data => l_error_count);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_ticket_assignments');
    end update_ticket_assignments;
/*
<event_series_ticket_assignment>
  <event_series>
    <event_series_id>13</event_series_id>
  </event_series>
  <ticket_resellers>
    <reseller>
      <reseller_id>21</reseller_id>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP PIT ACCESS</price_category>
          <tickets_assigned>100</tickets_assigned>
        </ticket_group>
...
      </ticket_assignments>
    </reseller>
...
  </ticket_resellers>
</event_series_ticket_assignment>
*/
    procedure update_ticket_assignments_series
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_event_series_id number;
        l_reseller_id event_system.resellers.reseller_id%type;
        l_price_category event_system.ticket_groups.price_category%type;
        l_tickets_assigned number;
        nRoot dbms_xmldom.DOMnode;
        nListResellers dbms_xmldom.DOMnodeList;
        nReseller dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;
        l_reseller_error_count number := 0;
        l_error_count number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
    begin
    
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRoot);

        dbms_xslprocessor.valueof(nRoot, 'event_series/event_series_id/text()', l_event_series_id);
        
        nListResellers := dbms_xslprocessor.selectNodes(n => nRoot, pattern => 'ticket_resellers/reseller');
        for r in 0..dbms_xmldom.getLength(nListResellers) - 1 loop
            l_reseller_id := 0;
            nReseller := dbms_xmldom.item(nListResellers, r);
        
            dbms_xslprocessor.valueof(nReseller, 'reseller_id/text()', l_reseller_id);
            l_reseller_error_count := 0;
            
            nListGroups := dbms_xslprocessor.selectNodes(n => nReseller, pattern => 'ticket_assignments/ticket_group');
            for g in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
                nGroup := dbms_xmldom.item(nListGroups, g);
                l_price_category := null;
                l_tickets_assigned := 0;
                
                dbms_xslprocessor.valueof(nGroup, 'price_category/text()', l_price_category);
                dbms_xslprocessor.valueof(nGroup, 'tickets_assigned/text()', l_tickets_assigned);

                begin

                    event_setup_api.create_ticket_assignment_event_series(
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

                util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_code', p_data => l_status_code);
                util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_message', p_data => l_status_message);

            end loop;

            --update the reseller array element
            util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'reseller_status', p_data => case when l_reseller_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
            util_xmldom_helper.addTextNode(p_parent => nReseller, p_tag => 'reseller_errors', p_data => l_reseller_error_count);
            l_error_count := l_error_count + l_reseller_error_count;

        end loop;
   
        --add status information for all resellers in the request
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_status', p_data => case when l_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        util_xmldom_helper.addTextNode(p_parent => nRoot, p_tag => 'request_errors', p_data => l_error_count);
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'update_ticket_assignments_series');
    end update_ticket_assignments_series;

--get pricing and availability for tickets created for the event
    function get_event_ticket_prices
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
        
        select b.xml_doc
        into l_xml
        from event_ticket_prices_v_xml b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_ticket_prices');
    end get_event_ticket_prices;

    function get_event_series_ticket_prices
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
        
        select b.xml_doc
        into l_xml
        from event_series_ticket_prices_v_xml b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_series_ticket_prices');
    end get_event_series_ticket_prices;

    function get_event_tickets_available_all
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from tickets_available_all_v_xml b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_all');
    end get_event_tickets_available_all;

    function get_event_tickets_available_venue
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from tickets_available_venue_v_xml b
        where b.event_id = p_event_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_venue');
    end get_event_tickets_available_venue;

    function get_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from tickets_available_reseller_v_xml b
        where 
            b.event_id = p_event_id
            and b.reseller_id = p_reseller_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_reseller');
    end get_event_tickets_available_reseller;

    function get_event_series_tickets_available_all
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from tickets_available_series_all_v_xml b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_series_tickets_available_all');
    end get_event_series_tickets_available_all;

    function get_event_series_tickets_available_venue
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from tickets_available_series_venue_v_xml b
        where b.event_series_id = p_event_series_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_series_tickets_available_venue');
    end get_event_series_tickets_available_venue;

    function get_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from tickets_available_series_reseller_v_xml b
        where 
            b.event_series_id = p_event_series_id
            and b.reseller_id = p_reseller_id;
    
        if p_formatted then
            l_xml := format_xml_clob(l_xml);
        end if;
        return l_xml;
        
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_event_series_tickets_available_reseller');
    end get_event_series_tickets_available_reseller;

    procedure purchase_get_customer
    (
        nRequest in out nocopy dbms_xmldom.DOMnode, 
        p_customer_id out number
    )
    is
        r_customer event_system.customers%rowtype;
        nCustomer dbms_xmldom.DOMnode;
        v_customer_email customers.customer_email%type;
        v_customer_name customers.customer_name%type;
    begin
        nCustomer := dbms_xslprocessor.selectSingleNode(n => nRequest, pattern => 'customer');
        dbms_xslprocessor.valueof(nCustomer, 'customer_email/text()', r_customer.customer_email);
        dbms_xslprocessor.valueof(nCustomer, 'customer_name/text()', r_customer.customer_name);

        --validate customer by email, create if not found
        p_customer_id := customer_api.get_customer_id(r_customer.customer_email);
        if p_customer_id = 0 then
            --need to create customer, if name was not specified use email for name
            if r_customer.customer_name is null then
                r_customer.customer_name := r_customer.customer_email;
            end if;
            customer_api.create_customer(
                p_customer_name => r_customer.customer_name,
                p_customer_email => r_customer.customer_email,
                p_customer_id => p_customer_id);
        end if;
        util_xmldom_helper.addTextNode(p_parent => nCustomer, p_tag => 'customer_id', p_data => p_customer_id);

    end purchase_get_customer;

    procedure purchase_update_group
    (
        nGroup in out nocopy dbms_xmldom.DOMnode,
        p_purchase in event_sales_api.r_purchase,
        p_is_series in boolean

    )
    is
    begin

        if p_is_series then
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'average_price', p_data => p_purchase.average_price);    
        else
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'ticket_sales_id', p_data => p_purchase.ticket_sales_id);
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'actual_price', p_data => p_purchase.actual_price);
        end if;
        util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'tickets_purchased', p_data => p_purchase.tickets_purchased);
        util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'purchase_amount', p_data => p_purchase.purchase_amount);
        util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_code', p_data => p_purchase.status_code);
        util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'status_message', p_data => p_purchase.status_message);
        
    end purchase_update_group;
    
    procedure purchase_update_request
    (
        nRequest in out nocopy dbms_xmldom.DOMnode,
        p_error_count in number,
        p_qty_requested_all_groups in number,
        p_qty_purchased_all_groups in number,
        p_total_purchase_amount in number
    )
    is
    begin
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'request_status', p_data => case when p_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'request_errors', p_data => p_error_count);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'total_tickets_requested', p_data => p_qty_requested_all_groups);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'total_tickets_purchased', p_data => p_qty_purchased_all_groups);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'total_purchase_amount', p_data => p_total_purchase_amount);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'purchase_disclaimer', p_data => 'All Ticket Sales Are Final.');
                
    end purchase_update_request;

    procedure purchase_tickets_reseller
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_purchase event_sales_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
        
        nRequest dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;        
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'event/event_id/text()', l_purchase.event_id);
        dbms_xslprocessor.valueof(nRequest, 'reseller/reseller_id/text()', l_purchase.reseller_id);
        purchase_get_customer(nRequest => nRequest, p_customer_id => l_purchase.customer_id);

        nListGroups := dbms_xslprocessor.selectNodes(n => nRequest, pattern => 'ticket_groups/ticket_group');
        for i in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
            nGroup := dbms_xmldom.item(nListGroups, i);
        
            dbms_xslprocessor.valueof(nGroup, 'ticket_group_id/text()', l_purchase.ticket_group_id);
            l_purchase.price_category := event_setup_api.get_ticket_group_category(l_purchase.ticket_group_id);    
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'price_category', p_data => l_purchase.price_category);
            dbms_xslprocessor.valueof(nGroup, 'tickets_requested/text()', l_purchase.tickets_requested);
            dbms_xslprocessor.valueof(nGroup, 'price/text()', l_purchase.price_requested);
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;

            begin
            
                event_sales_api.purchase_tickets_reseller(p_purchase => l_purchase);
 
                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
            
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;
        
            purchase_update_group(nGroup => nGroup, p_purchase => l_purchase, p_is_series => false);
        
        end loop;
        
        purchase_update_request(
            nRequest => nRequest, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);
    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'purchase_tickets_reseller');
    end purchase_tickets_reseller;

    --see comments above purchase_tickets_reseller for request format, restrictions and error conditions
    procedure purchase_tickets_venue
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_purchase event_sales_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;        
        l_status_code varchar2(10);
        l_status_message varchar2(4000);

        nRequest dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'event/event_id/text()', l_purchase.event_id);
        purchase_get_customer(nRequest => nRequest, p_customer_id => l_purchase.customer_id);

        nListGroups := dbms_xslprocessor.selectNodes(n => nRequest, pattern => 'ticket_groups/ticket_group');
        for i in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
            nGroup := dbms_xmldom.item(nListGroups, i);
    
            dbms_xslprocessor.valueof(nGroup, 'ticket_group_id/text()', l_purchase.ticket_group_id);
            l_purchase.price_category := event_setup_api.get_ticket_group_category(l_purchase.ticket_group_id);    
            util_xmldom_helper.addTextNode(p_parent => nGroup, p_tag => 'price_category', p_data => l_purchase.price_category);            
            dbms_xslprocessor.valueof(nGroup, 'tickets_requested/text()', l_purchase.tickets_requested);
            dbms_xslprocessor.valueof(nGroup, 'price/text()', l_purchase.price_requested);
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;
                        
            begin
            
                event_sales_api.purchase_tickets_venue(p_purchase => l_purchase);
                                    
                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
            
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;
        
            purchase_update_group(nGroup => nGroup, p_purchase => l_purchase, p_is_series => false);
        
        end loop;
        
        purchase_update_request(
            nRequest => nRequest, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);
    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'purchase_tickets_venue');
    end purchase_tickets_venue;

    procedure purchase_tickets_reseller_series
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_purchase event_sales_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
        nRequest dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;        
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'event_series/event_series_id/text()', l_purchase.event_series_id);
        dbms_xslprocessor.valueof(nRequest, 'reseller/reseller_id/text()', l_purchase.reseller_id);
        purchase_get_customer(nRequest => nRequest, p_customer_id => l_purchase.customer_id);

        nListGroups := dbms_xslprocessor.selectNodes(n => nRequest, pattern => 'ticket_groups/ticket_group');
        for i in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
            nGroup := dbms_xmldom.item(nListGroups, i);
                    
            dbms_xslprocessor.valueof(nGroup, 'price_category/text()', l_purchase.price_category);
            dbms_xslprocessor.valueof(nGroup, 'tickets_requested/text()', l_purchase.tickets_requested);
            dbms_xslprocessor.valueof(nGroup, 'price/text()', l_purchase.price_requested);            
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;
                
            begin
            
                event_sales_api.purchase_tickets_reseller_series(p_purchase => l_purchase);
                    
                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
                                
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;

            purchase_update_group(nGroup => nGroup, p_purchase => l_purchase, p_is_series => true);

        end loop;
        
        purchase_update_request(
            nRequest => nRequest, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);
    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'purchase_tickets_reseller_series');
    end purchase_tickets_reseller_series;

    --see comments above purchase_tickets_reseller_series for request format, restrictions and error conditions
    procedure purchase_tickets_venue_series
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_purchase event_sales_api.r_purchase;
        l_total_error_count number := 0;
        l_total_tickets_requested number := 0;
        l_total_tickets_purchased number := 0;
        l_total_purchase_amount number := 0;
        l_status_code varchar2(10);
        l_status_message varchar2(4000);
        nRequest dbms_xmldom.DOMnode;
        nListGroups dbms_xmldom.DOMnodeList;
        nGroup dbms_xmldom.DOMnode;
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'event_series/event_series_id/text()', l_purchase.event_series_id);
        purchase_get_customer(nRequest => nRequest, p_customer_id => l_purchase.customer_id);

        nListGroups := dbms_xslprocessor.selectNodes(n => nRequest, pattern => 'ticket_groups/ticket_group');
        for i in 0..dbms_xmldom.getLength(nListGroups) - 1 loop
            nGroup := dbms_xmldom.item(nListGroups, i);

            dbms_xslprocessor.valueof(nGroup, 'price_category/text()', l_purchase.price_category);
            dbms_xslprocessor.valueof(nGroup, 'tickets_requested/text()', l_purchase.tickets_requested);
            dbms_xslprocessor.valueof(nGroup, 'price/text()', l_purchase.price_requested);            
            l_total_tickets_requested := l_total_tickets_requested + l_purchase.tickets_requested;
        
            begin
            
                event_sales_api.purchase_tickets_venue_series(p_purchase => l_purchase);
                                    
                l_total_tickets_purchased := l_total_tickets_purchased + l_purchase.tickets_purchased;
                l_total_purchase_amount := l_total_purchase_amount + l_purchase.purchase_amount;
            
            exception
                when others then
                    l_total_error_count := l_total_error_count + 1;
            end;

            purchase_update_group(nGroup => nGroup, p_purchase => l_purchase, p_is_series => true);

        end loop;
        
        purchase_update_request(
            nRequest => nRequest, 
            p_error_count => l_total_error_count,
            p_qty_requested_all_groups => l_total_tickets_requested,
            p_qty_purchased_all_groups => l_total_tickets_purchased,
            p_total_purchase_amount => l_total_purchase_amount);
    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'purchase_tickets_venue_series');
    end purchase_tickets_venue_series;

--get customer purchases for event
--used to verify customer purchases
    function get_customer_events
    (
        p_customer_id in number,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from customer_events_v_xml b
        where 
            b.venue_id = p_venue_id 
            and b.customer_id = p_customer_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_events');
    end get_customer_events;

    function get_customer_events_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        v_customer_id number;
    begin
       
        v_customer_id := customer_api.get_customer_id(p_customer_email);
        
        return get_customer_events(v_customer_id, p_venue_id, p_formatted);
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_events_by_email');
    end get_customer_events_by_email;

--get all event series the customer has purhased tickets for
    function get_customer_event_series
    (
        p_customer_id in number,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from customer_event_series_v_xml b
        where 
            b.venue_id = p_venue_id 
            and b.customer_id = p_customer_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_event_series');
    end get_customer_event_series;

--use email to get customer_id
    function get_customer_event_series_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        v_customer_id number;
    begin
       
        v_customer_id := customer_api.get_customer_id(p_customer_email);
        
        return get_customer_event_series(v_customer_id, p_venue_id, p_formatted);
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_event_series_by_email');
    end get_customer_event_series_by_email;




--get customer purchases for event
--used to verify customer purchases
    function get_customer_event_purchases
    (
        p_customer_id in number,
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from customer_event_purchases_v_xml b
        where 
            b.event_id = p_event_id 
            and b.customer_id = p_customer_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_event_purchases');
    end get_customer_event_purchases;


--get customer tickets purchased for event
--use email to get customer_id
    function get_customer_event_purchases_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        v_customer_id number;
    begin
       
        v_customer_id := customer_api.get_customer_id(p_customer_email);
        
        return get_customer_event_purchases(v_customer_id, p_event_id, p_formatted);
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_event_purchases_by_email');
    end get_customer_event_purchases_by_email;

    function get_customer_event_series_purchases
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        l_xml xmltype;
    begin
    
        select b.xml_doc
        into l_xml
        from customer_event_series_purchases_v_xml b
        where 
            b.event_series_id = p_event_series_id 
            and b.customer_id = p_customer_id;
    
        if p_formatted then
            l_xml := format_xml_string(l_xml);
        end if;
        return l_xml;
    
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_event_series_purchases');
    end get_customer_event_series_purchases;


--get customer tickets purchased for event
--use email to get customer_id
    function get_customer_event_series_purchases_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype
    is
        v_customer_id number;
    begin
       
        v_customer_id := customer_api.get_customer_id(p_customer_email);
        
        return get_customer_event_series_purchases(v_customer_id, p_event_series_id, p_formatted);
       
    exception
        when others then
            return get_xml_error_doc(sqlcode, sqlerrm, 'get_customer_event_series_purchases_by_email');
    end get_customer_event_series_purchases_by_email;

--print tickets

--ticket_reissue


    procedure ticket_validate
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_event_id events.event_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        nRequest dbms_xmldom.DOMnode;
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'event/event_id/text()', l_event_id);
        dbms_xslprocessor.valueof(nRequest, 'ticket/serial_code/text()', l_serial_code);

        begin
            
            event_tickets_api.ticket_validate(
                p_event_id => l_event_id,
                p_serial_code => l_serial_code);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'VALIDATED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_message', p_data => l_status_message);
                    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;
    
    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'ticket_validate');
    end ticket_validate;

    procedure ticket_verify_validation
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_event_id events.event_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        nRequest dbms_xmldom.DOMnode;
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'event/event_id/text()', l_event_id);
        dbms_xslprocessor.valueof(nRequest, 'ticket/serial_code/text()', l_serial_code);

        begin
            
            event_tickets_api.ticket_verify_validation(
                p_event_id => l_event_id,
                p_serial_code => l_serial_code);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'VERIFIED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_message', p_data => l_status_message);
                    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'ticket_verify_validation');
    end ticket_verify_validation;
    
    procedure ticket_verify_restricted_access
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_ticket_group_id ticket_groups.ticket_group_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        nRequest dbms_xmldom.DOMnode;
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'ticket_group/ticket_group_id/text()', l_ticket_group_id);
        dbms_xslprocessor.valueof(nRequest, 'ticket/serial_code/text()', l_serial_code);

        begin
            
            event_tickets_api.ticket_verify_restricted_access(
                p_ticket_group_id => l_ticket_group_id,
                p_serial_code => l_serial_code);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'ACCESS VERIFIED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;

        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_message', p_data => l_status_message);
                    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;

    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'ticket_verify_restricted_access');    
    end ticket_verify_restricted_access;
        
    procedure ticket_cancel
    (
        p_xml_doc in out nocopy xmltype
    )
    is
        l_event_id events.event_id%type;
        l_serial_code tickets.serial_code%type;
        l_status_code varchar2(50);
        l_status_message varchar2(4000);
        nRequest dbms_xmldom.DOMnode;
    begin
        util_xmldom_helper.newDocFromXML(p_xml => p_xml_doc, p_root_node => nRequest);

        dbms_xslprocessor.valueof(nRequest, 'event/event_id/text()', l_event_id);
        dbms_xslprocessor.valueof(nRequest, 'ticket/serial_code/text()', l_serial_code);

        begin
            
            event_tickets_api.ticket_cancel(
                p_event_id => l_event_id,
                p_serial_code => l_serial_code);
                
            l_status_code := 'SUCCESS';
            l_status_message := 'CANCELLED';        
        exception
            when others then
                l_status_code := 'ERROR';
                l_status_message := sqlerrm;
        end;
        
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_code', p_data => l_status_code);
        util_xmldom_helper.addTextNode(p_parent => nRequest, p_tag => 'status_message', p_data => l_status_message);
                    
        p_xml_doc := util_xmldom_helper.docToXMLtype;
        util_xmldom_helper.freeDoc;
                    
    exception
        when others then
            util_xmldom_helper.freeDoc;
            p_xml_doc := get_xml_error_doc(sqlcode, sqlerrm, 'ticket_cancel');
    end ticket_cancel;

begin
  null;
end events_xml_api;