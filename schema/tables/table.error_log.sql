create table error_log
    (
   error_id number generated always as identity,
   os_user_name varchar2(100 char),
   db_user_name varchar2(30 char),
   db_session_id number,
   error_locale varchar2(256 char),
   error_code number,
   error_message varchar2(4000 char),
   error_date date default sysdate
   );