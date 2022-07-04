set serveroutput on;
declare
    l_customer_email varchar2(50) := 'Gary.Walsh@example.customer.com';
    l_customer_id number;
    l_venue_id number;
    l_event_series_id number;

  p_customer_id number;
  p_event_id number := 1;
  l_xml xmltype;
begin
    l_customer_id := events_api.get_customer_id(l_customer_email);
    
    select venue_id into l_venue_id from venues where venue_name = 'The Pink Pony Revue';
    select max(event_series_id) into l_event_series_id from events where event_name = 'Cool Jazz Evening';

    l_xml := events_xml_api.get_customer_event_series_tickets(p_customer_id => l_customer_id,p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;


/*
<service_error_report>
  <xml_service_method>get_customer_event_series_tickets</xml_service_method>
  <error_code>-1422</error_code>
  <error_message>ORA-01422: exact fetch returns more than requested number of rows</error_message>
</service_error_report>



PL/SQL procedure successfully completed.


*/