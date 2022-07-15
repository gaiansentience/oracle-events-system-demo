create or replace package body reseller_api 
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
        error_api.log_error(
            p_error_message => p_error_message, 
            p_error_code => p_error_code, 
            p_locale => 'reseller_api.' || p_locale);
   
    end log_error;

    function get_reseller_id
    (
        p_reseller_name in varchar2
    ) return number
    is
        l_reseller_id number;
    begin
        
        select r.reseller_id
        into l_reseller_id
        from resellers r
        where upper(r.reseller_name) = upper(p_reseller_name);
        
        return l_reseller_id;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode,'get_reseller_id');
            raise;                        
    end get_reseller_id;
    
    procedure validate_reseller_record
    (
        p_reseller in resellers%rowtype
    )
    is
    begin
        case    
            when p_reseller.reseller_name is null then
                raise_application_error(-20100, 'Missing reseller name, cannot create or update reseller.');
            when p_reseller.reseller_email is null then
                raise_application_error(-20100, 'Missing reseller email, cannot create or update reseller.');
            when p_reseller.commission_percent is null then
                raise_application_error(-20100, 'Missing reseller commission, cannot create or update reseller.');     
            else
                --record is valid
                null;
        end case;

    end validate_reseller_record;
   
    procedure create_reseller
    (
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10,
        p_reseller_id out number
    )
    is
        r_reseller resellers%rowtype;
    begin
        r_reseller.reseller_name := p_reseller_name;
        r_reseller.reseller_email := p_reseller_email;
        r_reseller.commission_percent := p_commission_percent;
        
        validate_reseller_record(r_reseller);
    
        insert into event_system.resellers
        (
            reseller_name,
            reseller_email,
            commission_percent
        )
        values
        (
            r_reseller.reseller_name,
            r_reseller.reseller_email,
            r_reseller.commission_percent
        )
        returning reseller_id 
        into p_reseller_id;
        
        commit;
    
    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_reseller');
            raise;
    end create_reseller;

    procedure update_reseller
    (
        p_reseller_id in number,    
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10    
    )
    is
        r_reseller resellers%rowtype;
    begin
        r_reseller.reseller_name := p_reseller_name;
        r_reseller.reseller_email := p_reseller_email;
        r_reseller.commission_percent := p_commission_percent;
        
        validate_reseller_record(r_reseller);
    
        update event_system.resellers r
        set 
            r.reseller_name = r_reseller.reseller_name,
            r.reseller_email = r_reseller.reseller_email,
            r.commission_percent = r_reseller.commission_percent
        where r.reseller_id = p_reseller_id;
        
        commit;
        
    exception
        when others then
            log_error(sqlerrm, sqlcode, 'update_reseller');
            raise;
    end update_reseller;

    procedure show_reseller
    (
        p_reseller_id in number,
        p_info out sys_refcursor
    )
    is
    begin
    
        open p_info for
        select
            r.reseller_id,
            r.reseller_name,
            r.reseller_email,
            r.commission_percent
        from event_system.resellers_v r
        where r.reseller_id = p_reseller_id;
    
    end show_reseller;

    procedure show_all_resellers
    (
        p_resellers out sys_refcursor
    )
    is
    begin
    
        open p_resellers for
        select
            r.reseller_id,
            r.reseller_name,
            r.reseller_email,
            r.commission_percent
        from event_system.resellers r
        order by r.reseller_name;
    
    end show_all_resellers;

    function show_reseller
    (
        p_reseller_id in resellers.reseller_id%type
    ) return t_reseller_info pipelined
    is
        t_rows t_reseller_info;
        rc sys_refcursor;
    begin
    
        show_reseller(p_reseller_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_reseller;
    
    function show_all_resellers 
    return t_reseller_info pipelined
    is
        t_rows t_reseller_info;
        rc sys_refcursor;
    begin
    
        show_all_resellers(rc);
        fetch rc bulk collect into t_rows;
        close rc;
        
        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;
    
    end show_all_resellers;   

begin
    initialize;
end reseller_api;