create or replace package events_report_api
authid current_user
as
--expose ref cursor procedures from events_api.[show]xxx procedures
--use pipelined table functions to support applications that cannot use ref cursors







end events_report_api;
