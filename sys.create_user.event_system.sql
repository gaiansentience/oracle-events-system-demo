create user event_system identified by demo;

grant create session to event_system;

grant resource to event_system;

--alter user dev  default tablespace users;
--alter user dev quota unlimited on users;

alter user event_system
default tablespace users
 quota unlimited on users
container = current;

grant create table to event_system;

grant create type to event_system;

grant create view to event_system;

grant create materialized view to event_system;

grant create procedure to event_system;

grant create synonym to event_system;
