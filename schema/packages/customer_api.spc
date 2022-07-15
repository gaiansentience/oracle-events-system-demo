create or replace package customer_api 
authid current_user
as

    function get_customer_id
    (
        p_customer_email in varchar2
    ) return number;

    procedure create_customer
    (
        p_customer_name in varchar2,
        p_customer_email in varchar2,
        p_customer_id out number
    );   

    procedure update_customer
    (
        p_customer_id in number,
        p_customer_name in varchar2,
        p_customer_email in varchar2
    );

    procedure show_customer
    (
        p_customer_id in number,
        p_info out sys_refcursor
    );    

    type r_customer_info is record
    (
        customer_id     customers.customer_id%type
        ,customer_name  customers.customer_name%type
        ,customer_email customers.customer_email%type
    );

    type t_customer_info is table of r_customer_info;

    function show_customer
    (
        p_customer_id in customers.customer_id%type
    ) return t_customer_info pipelined;

end customer_api;