create or replace package reseller_api 
authid current_user
as

    function get_reseller_id
    (
        p_reseller_name in varchar2
    ) return number;
            
    procedure create_reseller
    (
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10,
        p_reseller_id out number
    );
    
    procedure update_reseller
    (
        p_reseller_id in number,    
        p_reseller_name in varchar2,
        p_reseller_email in varchar2,
        p_commission_percent in number default 0.10    
    );
    
    procedure show_reseller
    (
        p_reseller_id in number,
        p_info out sys_refcursor
    );
        
    procedure show_all_resellers
    (
        p_resellers out sys_refcursor
    );

    type r_reseller_info is record
    (
        reseller_id         resellers.reseller_id%type
        ,reseller_name      resellers.reseller_name%type
        ,reseller_email     resellers.reseller_email%type
        ,commission_percent resellers.commission_percent%type
    );

    type t_reseller_info is table of r_reseller_info;

    function show_reseller
    (
        p_reseller_id in resellers.reseller_id%type
    ) return t_reseller_info pipelined;

    function show_all_resellers 
    return t_reseller_info pipelined;

end reseller_api;