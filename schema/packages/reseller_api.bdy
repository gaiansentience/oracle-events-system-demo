create package reseller_api 
authid current_user
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







begin
    initialize;
end reseller_api;