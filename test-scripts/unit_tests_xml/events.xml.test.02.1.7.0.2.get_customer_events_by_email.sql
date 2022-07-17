set serveroutput on;
declare
    l_customer_email varchar2(50) := 'James.Kirk@example.customer.com';
    l_venue_id number;
    l_xml xmltype;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');

    l_xml := events_xml_api.get_customer_events_by_email(p_customer_email => l_customer_email, p_venue_id => l_venue_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*

<customer_events>
  <customer>
    <customer_id>3961</customer_id>
    <customer_name>James Kirk</customer_name>
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
  </venue>
  <event_listing>
    <event>
      <event_id>636</event_id>
      <event_name>Evangeline Thorpe</event_name>
      <event_date>2023-05-01</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>637</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-04</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>638</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-11</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>639</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-18</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>640</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-25</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>641</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-01</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>642</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-08</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>643</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-15</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>644</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-22</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>645</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-29</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>646</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-06</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>647</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-13</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>648</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-20</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>649</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-27</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>650</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-03</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>651</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-10</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>652</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-17</event_date>
      <event_tickets>6</event_tickets>
    </event>
    <event>
      <event_series_id>82</event_series_id>
      <event_id>653</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-24</event_date>
      <event_tickets>6</event_tickets>
    </event>
  </event_listing>
</customer_events>



PL/SQL procedure successfully completed.


*/