--assign ticket groups to a reseller for an event
set serveroutput on;
declare
    v_old_school_id     number;
    v_tickets_r_us_id number;
    v_event_series_id number;

    type r_assign is record(reseller_id number, reseller_name varchar2(100),price_category ticket_groups.price_category%type, tickets number);
    type t_assign is table of r_assign index by pls_integer;
    v_assign t_assign;
    v_status_code varchar2(100);
    v_status_message varchar2(4000);
begin

    select reseller_id into v_old_school_id from resellers where reseller_name = 'Old School';
    select reseller_id into v_tickets_r_us_id from resellers where reseller_name = 'Tickets R Us';

    v_assign(1) := r_assign(v_old_school_id, 'Old School','GENERAL ADMISSION', 1000);
    v_assign(2) := r_assign(v_old_school_id, 'Old School', 'VIP', 250);
    v_assign(3) := r_assign(v_old_school_id, 'Old School', 'EARLY PURCHASE DISCOUNT', 250);
    v_assign(4) := r_assign(v_tickets_r_us_id, 'Tickets R Us', 'GENERAL ADMISSION', 1000);
    v_assign(5) := r_assign(v_tickets_r_us_id, 'Tickets R Us', 'VIP', 250);
    v_assign(6) := r_assign(v_tickets_r_us_id, 'Tickets R Us', 'EARLY PURCHASE DISCOUNT', 250);

    select max(event_series_id) 
    into v_event_series_id 
    from events 
    where event_name = 'Hometown Hockey League';
  
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