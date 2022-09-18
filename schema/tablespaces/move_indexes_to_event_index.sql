set serveroutput on;
declare
    p_script boolean := true;
    p_execute boolean := false;
    p_tablespace varchar2(200) := 'EVENT_INDEX';
    cursor c_indexes is
        select index_name
        from user_indexes
        where 
        partitioned = 'NO'
        and index_type <> 'LOB'
        and tablespace_name <> p_tablespace
        order by table_name, index_name;
begin
  
    for r_i in c_indexes loop
        admin$schema.move_index(
            p_index => r_i.index_name,
            p_script => p_script,
            p_execute => p_execute,
            p_tablespace => p_tablespace
        );
      
    end loop;

end;
/