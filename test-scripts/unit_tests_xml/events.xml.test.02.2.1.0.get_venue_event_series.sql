set serveroutput on;
declare
    l_xml xmltype;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
begin
    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);

    l_xml := events_xml_api.get_venue_event_series(p_venue_id => l_venue_id, p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
--BEFORE CREATING SERIES

<venue_events>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
    <events_scheduled>1</events_scheduled>
  </venue>
  <venue_event_listing/>
</venue_events>


--AFTER CREATING SERIES
<venue_events>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_name>Julia Stone</organizer_name>
    <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
    <max_event_capacity>400</max_event_capacity>
    <events_scheduled>18</events_scheduled>
  </venue>
  <venue_event_listing>
    <event>
      <event_id>637</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-04</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>638</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-11</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>639</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-18</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>640</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-25</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>641</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-01</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>642</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-08</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>643</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-15</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>644</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-22</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>645</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-29</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>646</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-06</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>647</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-13</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>648</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-20</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>649</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-27</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>650</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-03</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>651</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-10</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>652</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-17</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>653</event_id>
      <event_series_id>82</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-24</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
  </venue_event_listing>
</venue_events>


*/