create or replace package body event_tickets_api
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
            p_locale => 'event_tickets_api.' || p_locale);
   
    end log_error;
    
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
            ,event_tickets_api.c_ticket_status_issued
        from dual 
        connect by level <= p_sale.ticket_quantity;
        
    end generate_serialized_tickets;
    

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
                    l_ticket_price_category := event_setup_api.get_ticket_group_category(p_ticket_group_id => l_ticket_group_id);
                    l_price_category := event_setup_api.get_ticket_group_category(p_ticket_group_id => p_ticket_group_id);
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



begin
    initialize;
end event_tickets_api;