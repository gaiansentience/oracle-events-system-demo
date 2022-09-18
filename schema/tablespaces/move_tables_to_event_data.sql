set serveroutput on;
declare
      p_update_indexes boolean := false;
      p_move_online boolean := false;
      p_script boolean := true;
      p_execute boolean := false;
      p_tablespace varchar2(200) := 'EVENT_DATA';
      cursor c_tables is
        select table_name
        from user_tables
        where partitioned = 'NO'
        and tablespace_name <> p_tablespace;
begin
  
    for r_t in c_tables loop
        admin$schema.move_table(
            p_table => r_t.table_name,
            p_update_indexes => p_update_indexes,
            p_move_online => p_move_online,
            p_script => p_script,
            p_execute => p_execute,
            p_tablespace => p_tablespace
        );
      
    end loop;

end;
/