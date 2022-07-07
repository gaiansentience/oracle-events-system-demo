create or replace package error_api
authid current_user
as

    procedure log_error
    (
        p_error_message in varchar2,
        p_error_code in number,
        p_locale in varchar2
    );
    
    procedure purge_error_logs;
    
end error_api;