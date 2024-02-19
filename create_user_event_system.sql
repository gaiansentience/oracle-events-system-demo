create user event_system identified by demo;

grant create session to event_system;
grant resource to event_system;

--alter user dev  default tablespace users;
--alter user dev quota unlimited on users;

alter user event_system
default tablespace users
 quota unlimited on users
container = current;

grant create synonym to event_system;
grant create public synonym to event_system;

grant create table to event_system;
grant create sequence to event_system;
grant create view to event_system;
grant create materialized view to event_system;
grant create procedure to event_system;
grant create type to event_system;

grant create role to event_system with admin option;
grant create any context to event_system with admin option;

grant alter system to event_system;
grant select on v_$sqlarea to event_system;

--grants for tracing
grant execute on dbms_monitor to event_system;
grant select on v_$diag_trace_file to event_system;
grant select on v_$diag_trace_file_contents to event_system;

