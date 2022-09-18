set serveroutput on;
declare
    p_script boolean := true;
    p_execute boolean := false;
    p_tablespace varchar2(200) := 'EVENT_INDEX';
begin

    admin$schema.move_indexes(
        p_script => p_script,
        p_execute => p_execute,
        p_tablespace => p_tablespace
    );

end;
/