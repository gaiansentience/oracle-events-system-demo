--drop table error_log purge;
create table error_log
(
    error_id number generated always as identity
        constraint error_log_nn_error_id not null,
    error_date date default sysdate,    
    os_user_name varchar2(100 char),
    db_user_name varchar2(30 char),
    db_session_id number,
    error_locale varchar2(256 char),
    error_code number,
    error_message varchar2(4000 char)
    --error_message varchar2(4000 byte)    
);

create index error_log_idx_error_date 
    on error_log (error_date);
    
--ORACLE 19c defining error_message as varchar2(4000 CHAR) creates a system generated unique lob index    
--ORACLE 21c no system generated index is created