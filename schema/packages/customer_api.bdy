create or replace package body customer_api 
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
            p_locale => 'customer_api.' || p_locale);

    end log_error;

    function get_customer_id
    (
        p_customer_email in varchar2
    ) return number
    is
        v_customer_id number;
    begin

        select customer_id
        into v_customer_id
        from event_system.customers c
        where upper(c.customer_email) = upper(p_customer_email);

        return v_customer_id;

    exception
        when no_data_found then
            return 0;
        when others then
            log_error(sqlerrm, sqlcode, 'get_customer_id');
            raise;
    end get_customer_id;

    procedure validate_customer_record
    (
        p_customer in customers%rowtype
    )
    is
    begin
        case    
            when p_customer.customer_name is null then
                raise_application_error(-20100, 'Missing name, cannot create or update customer');
            when p_customer.customer_email is null then
                raise_application_error(-20100, 'Missing email, cannot create or update customer'); 
            else
                --record is valid
                null;
        end case;

    end validate_customer_record;

    procedure create_customer
    (
        p_customer_name in varchar2,
        p_customer_email in varchar2,
        p_customer_id out number
    )
    is
        r_customer customers%rowtype;
    begin
        --check to see if the email is already registered to a customer
        p_customer_id := get_customer_id(p_customer_email);
        r_customer.customer_name := p_customer_name;
        r_customer.customer_email := p_customer_email;
        validate_customer_record(p_customer => r_customer);

        if p_customer_id = 0 then

            insert into event_system.customers
            (
                customer_name,
                customer_email
            )
            values
            (
                r_customer.customer_name,
                r_customer.customer_email
            )
            returning customer_id 
            into p_customer_id;

        else
            if r_customer.customer_name is not null then
                update event_system.customers c
                set c.customer_name = r_customer.customer_name
                where customer_id = p_customer_id;
            end if;
        end if;

        commit;

    exception
        when others then
            log_error(sqlerrm, sqlcode,'create_customer');
            raise;
    end create_customer;

    procedure update_customer
    (
        p_customer_id in number,
        p_customer_name in varchar2,
        p_customer_email in varchar2
    )
    is
        r_customer customers%rowtype;
    begin
        r_customer.customer_name := p_customer_name;
        r_customer.customer_email := p_customer_email;
        validate_customer_record(p_customer => r_customer);

        update event_system.customers c
        set 
            c.customer_name = r_customer.customer_name,
            c.customer_email = r_customer.customer_email
        where c.customer_id = p_customer_id;

        commit;

    exception
        when others then
            log_error(sqlerrm, sqlcode, 'update_customer');
            raise;
    end update_customer;

    procedure show_customer
    (
        p_customer_id in number,
        p_info out sys_refcursor
    )
    is
    begin

        open p_info for
        select
            c.customer_id
            ,c.customer_name
            ,c.customer_email
        from event_system.customers_v c
        where c.customer_id = p_customer_id;

    end show_customer;

    function show_customer
    (
        p_customer_id in customers.customer_id%type
    ) return t_customer_info pipelined
    is
        t_rows t_customer_info;
        rc sys_refcursor;
    begin

        show_customer(p_customer_id, rc);
        fetch rc bulk collect into t_rows;
        close rc;

        for i in 1..t_rows.count loop
            pipe row(t_rows(i));
        end loop;
        return;

    end show_customer;

begin
    initialize;
end customer_api;