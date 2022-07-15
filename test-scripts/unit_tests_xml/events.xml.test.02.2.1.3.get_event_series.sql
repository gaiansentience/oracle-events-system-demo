set serveroutput on;
declare
    l_xml xmltype;
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_xml := events_xml_api.get_event_series(p_event_series_id => l_event_series_id, p_formatted => true);
    dbms_output.put_line(l_xml.getclobval);

end;

/*
--AFTER CREATING SERIES

<event_series>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
  </venue>
  <event_series_id>82</event_series_id>
  <event_series_name>Cool Jazz Evening</event_series_name>
  <events_in_series>17</events_in_series>
  <tickets_available_all_events>3400</tickets_available_all_events>
  <tickets_remaining_all_events>3400</tickets_remaining_all_events>
  <events_sold_out>0</events_sold_out>
  <events_still_available>17</events_still_available>
  <series_events>
    <event>
      <event_id>637</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-04</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>638</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-11</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>639</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-18</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>640</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-25</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>641</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-01</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>642</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-08</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>643</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-15</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>644</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-22</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>645</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-29</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>646</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-06</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>647</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-13</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>648</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-20</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>649</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-27</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>650</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-03</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>651</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-10</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>652</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-17</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>653</event_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-24</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
  </series_events>
</event_series>

--AFTER UPDATING EVENT SERIES
<event_series>
  <venue>
    <venue_id>82</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
  </venue>
  <event_series_id>82</event_series_id>
  <event_series_name>Jazz Thurdsdays at the Pink Pony</event_series_name>
  <events_in_series>17</events_in_series>
  <tickets_available_all_events>5100</tickets_available_all_events>
  <tickets_remaining_all_events>5100</tickets_remaining_all_events>
  <events_sold_out>0</events_sold_out>
  <events_still_available>17</events_still_available>
  <series_events>
    <event>
      <event_id>637</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-05-04</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>638</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-05-11</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>639</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-05-18</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>640</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-05-25</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>641</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-06-01</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>642</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-06-08</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>643</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-06-15</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>644</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-06-22</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>645</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-06-29</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>646</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-07-06</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>647</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-07-13</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>648</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-07-20</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>649</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-07-27</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>650</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-08-03</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>651</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-08-10</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>652</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-08-17</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
    <event>
      <event_id>653</event_id>
      <event_name>Jazz Thurdsdays at the Pink Pony</event_name>
      <event_date>2023-08-24</event_date>
      <tickets_available>300</tickets_available>
      <tickets_remaining>300</tickets_remaining>
    </event>
  </series_events>
</event_series>



PL/SQL procedure successfully completed.


*/