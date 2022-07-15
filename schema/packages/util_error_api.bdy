create or replace package body util_error_api as

    g_db_user varchar2(30);
    g_os_user varchar2(100);
    g_db_sid number;

    procedure initialize
    is
    begin

        g_db_user := user;
        g_os_user := sys_context('userenv', 'os_user');
        g_db_sid := sys_context('userenv','sid');

    end initialize;

    procedure log_error
    (
        p_error_message in varchar2,
        p_error_code in number,
        p_locale in varchar2
    )
    is
        pragma autonomous_transaction;
    begin

        insert into event_system.error_log
        (
            os_user_name,
            db_user_name,
            db_session_id,
            error_locale,
            error_code,
            error_message,
            error_date
        )
        values
        (
            g_os_user,
            g_db_user,
            g_db_sid,
            p_locale,
            p_error_code,
            p_error_message,
            sysdate
        );
      
        commit;
   
    exception
        when others then
            --do not raise errors from logging routine
            rollback;
    end log_error;

    procedure purge_error_logs
    is
    begin
    
        execute immediate 'truncate table events_system.error_log drop storage';
        
    end purge_error_logs;

begin
    initialize;
end util_error_api;