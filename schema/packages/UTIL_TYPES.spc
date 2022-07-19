create or replace package util_types
authid current_user
as

type t_ids is table of integer index by pls_integer;


end util_types;
