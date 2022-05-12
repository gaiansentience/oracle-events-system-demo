set serveroutput on;
--grant table, view and package privileges to the apex user
declare
   l_execute boolean := false;
   l_user varchar2(30) := 'OBE';
   cursor c_tables is
      select table_name
      from user_tables;

   cursor c_views is
      select object_name
      from user_objects 
      where object_type = 'VIEW';

   cursor c_packages is
      select object_name 
      from user_objects 
      where object_type = 'PACKAGE';

   v_ddl varchar2(100);

begin

   for r in c_tables loop
      v_ddl := 'grant select, insert, update, delete on event_system.' || r.table_name || ' to ' || l_user;
      dbms_output.put_line(v_ddl);
      if l_execute then
         execute immediate v_ddl;
      end if;
   end loop;

   for r in c_views loop
      v_ddl := 'grant select on event_system.' || r.object_name || ' to ' || l_user;
      dbms_output.put_line(v_ddl);
      if l_execute then
         execute immediate v_ddl;
      end if;
   end loop;

   for r in c_packages loop
      v_ddl := 'grant execute on event_system.' || r.object_name || ' to ' || l_user;
      dbms_output.put_line(v_ddl);
      if l_execute then
         execute immediate v_ddl;
      end if;
   end loop;

end;