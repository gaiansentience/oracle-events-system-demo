set serveroutput on;
declare
    l_xml xmltype;
    l_customer_email varchar2(50) := 'James.Kirk@example.customer.com';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);

    l_xml := events_xml_api.get_customer_event_series_by_email(p_customer_email => l_customer_email, p_venue_id => l_venue_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
<customer_event_series>
  <customer>
    <customer_id>3961</customer_id>
    <customer_name>James Kirk</customer_name>
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
  </venue>
  <event_series_listing>
    <event_series>
      <event_series_id>82</event_series_id>
      <event_series_name>Cool Jazz Evening</event_series_name>
      <first_event_date>2023-05-04</first_event_date>
      <last_event_date>2023-08-24</last_event_date>
      <series_events>17</series_events>
      <series_tickets>102</series_tickets>
    </event_series>
  </event_series_listing>
</customer_event_series>



PL/SQL procedure successfully completed.



*/