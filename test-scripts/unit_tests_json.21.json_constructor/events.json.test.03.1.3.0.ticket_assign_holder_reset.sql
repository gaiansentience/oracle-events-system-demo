--reset test cases for assign ticket holder and assign ticket holder batch
set serveroutput on;
declare
    l_venue_name venues.venue_name%type := 'Another Roadside Attraction';
    l_event_name events.event_name%type := 'New Years Mischief';
    l_customer_email varchar2(50) := 'Maggie.Wayland@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_customer_id number;
begin
    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    update tickets tx
    set 
        tx.issued_to_name = null, 
        tx.issued_to_id = null
    where tx.ticket_id in
    (
    select t.ticket_id
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    and t.issued_to_name is not null
    );

    commit;
    
end;
