--reissue serial number for lost ticket using customer email
set serveroutput on;
declare
    l_venue_name venues.venue_name%type := 'City Stadium';
    l_event_name events.event_name%type := 'The New Toys';
    l_customer_email customers.customer_name%type := 'Harry.Potter@example.customer.com';
    l_venue_id number;
    l_event_id number;
    l_customer_id number;
    l_serial_code tickets.serial_code%type;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := event_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);
    
    select t.serial_code 
    into l_serial_code
    from customer_event_tickets_v t
    where t.event_id = l_event_id and t.customer_id = l_customer_id
    and t.issued_to_name is null
    order by t.ticket_sales_id, t.ticket_id
    fetch first 1 row only;
    
    customer_api.ticket_assign_holder_using_email(
        p_customer_email => l_customer_email, 
        p_serial_code => l_serial_code,
        p_issued_to_name => 'Hermione Granger', 
        p_issued_to_id => 'HGW12345011');
    
end;
