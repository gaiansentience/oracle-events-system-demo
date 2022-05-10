create table error_log(
   error_id number generated always as identity,
   db_user_name varchar2(30),
   db_session_id number,
   error_locale varchar2(50),
   error_code number,
   error_message varchar2(4000),
   error_date date default sysdate
   );