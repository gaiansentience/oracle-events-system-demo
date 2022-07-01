--create schema objects for event platform projects
--tables and views
prompt creating events schema tables
@@table.venues.sql;
@@table.resellers.sql;
@@table.customers.sql;
@@table.events.sql;
@@table.ticket_groups.sql;
@@table.ticket_assignments.sql;
@@table.ticket_sales.sql;
@@table.tickets.sql;
@@table.error_log.sql;
prompt all events tables created

