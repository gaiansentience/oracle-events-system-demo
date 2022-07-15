create or replace package body event_setup_api
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
            p_locale => 'event_setup_api.' || p_locale);
   
    end log_error;




begin
    initialize;
end event_setup_api;