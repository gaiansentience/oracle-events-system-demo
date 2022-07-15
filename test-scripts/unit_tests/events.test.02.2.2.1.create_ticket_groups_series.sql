--create ticket groups for the event series
--use show_ticket_groups_series to see groups that are created (test.03.00)
--total of all ticket groups created cannot exceed event size for an event in the series
set serveroutput on;
declare
    v_venue_id number;
    v_event_series_id number;
    type r_group is record(
        price_category ticket_groups.price_category%type,
        price number,
        tickets number);
    type t_groups is table of r_group index by pls_integer;
    v_groups t_groups;
    v_status_code varchar2(100);
    v_status_message varchar2(4000);
begin
    v_venue_id := venue_api.get_venue_id(p_venue_name => 'City Stadium');
    v_event_series_id := event_api.get_event_series_id(p_venue_id => v_venue_id, p_event_name => 'Hometown Hockey League');

    v_groups(1) := r_group('VIP',75,1000);
    v_groups(2) := r_group('GENERAL ADMISSION', 42, 3000);
    v_groups(3) := r_group('EARLY PURCHASE DISCOUNT', 33, 1000);
        
    for i in 1..v_groups.count loop
        event_setup_api.create_ticket_group_event_series(
             p_event_series_id => v_event_series_id,
             p_price_category => v_groups(i).price_category,
             p_price => v_groups(i).price,
             p_tickets => v_groups(i).tickets,
             p_status_code => v_status_code,
             p_status_message => v_status_message);
     
        dbms_output.put_line(v_groups(i).price_category || ' group created with status code = ' || v_status_code || ' status message = ' || v_status_message);
    end loop;
  
end;