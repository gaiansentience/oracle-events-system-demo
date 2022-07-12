--assign ticket groups to a reseller for an event
set serveroutput on;
declare
    v_old_school varchar2(50) := 'Old School';
    v_old_school_id   number;
    v_tickets_r_us varchar2(50) := 'Tickets R Us';
    v_tickets_r_us_id number;
    v_venue_id number;
    v_event_series_id number;
    
    v_category_general varchar2(50) := 'GENERAL ADMISSION';
    v_category_vip     varchar2(50) := 'VIP';
    v_category_early   varchar2(50) := 'EARLY PURCHASE DISCOUNT';

    type r_assign is record(reseller_id number, reseller_name varchar2(100), price_category ticket_groups.price_category%type, tickets number);
    type t_assign is table of r_assign index by pls_integer;
    v_assign t_assign;
    v_status_code varchar2(100);
    v_status_message varchar2(4000);
begin

    v_venue_id := events_api.get_venue_id(p_venue_name => 'City Stadium');
    v_event_series_id := events_api.get_event_series_id(p_venue_id => v_venue_id, p_event_name => 'Hometown Hockey League');

    v_old_school_id := events_api.get_reseller_id(p_reseller_name => v_old_school);
    v_tickets_r_us_id := events_api.get_reseller_id(p_reseller_name => 'Tickets R Us');
    
    v_assign(1) := r_assign(v_old_school_id, v_old_school, v_category_general, 1000);
    v_assign(2) := r_assign(v_old_school_id, v_old_school, v_category_vip, 300);
    v_assign(3) := r_assign(v_old_school_id, v_old_school, v_category_early, 100);
    v_assign(4) := r_assign(v_tickets_r_us_id, v_tickets_r_us, v_category_general, 1000);
    v_assign(5) := r_assign(v_tickets_r_us_id, v_tickets_r_us, v_category_vip, 100);
    v_assign(6) := r_assign(v_tickets_r_us_id, v_tickets_r_us, v_category_early, 500);
  
    for i in 1..v_assign.count loop
        events_api.create_ticket_assignment_event_series(
            p_event_series_id => v_event_series_id,
            p_reseller_id => v_assign(i).reseller_id,
            p_price_category => v_assign(i).price_category,
            p_number_tickets => v_assign(i).tickets,
            p_status_code => v_status_code,
            p_status_message => v_status_message);
        dbms_output.put_line(v_assign(i).price_category || ' assigned to ' || v_assign(i).reseller_name || ' status code = ' || v_status_code || ' status message = ' || v_status_message);
    end loop;
    
end;