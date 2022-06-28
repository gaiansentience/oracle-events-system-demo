set serveroutput on;
declare
  p_venue_id number := 2;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_venue_event_series(p_venue_id => p_venue_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
<venue_events>
  <venue>
    <venue_id>2</venue_id>
    <venue_name>Club 11</venue_name>
    <organizer_email>Mary.Rivera@Club11.com</organizer_email>
    <organizer_name>Mary Rivera</organizer_name>
    <max_event_capacity>500</max_event_capacity>
    <venue_scheduled_events>78</venue_scheduled_events>
  </venue>
  <venue_event_listing>
    <event>
      <event_id>443</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-04-06</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>444</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-04-13</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>445</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-04-20</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>446</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-04-27</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>447</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-04</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>448</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-11</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>449</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-18</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>450</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-25</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>451</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-01</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>452</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-08</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>453</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-15</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>454</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-22</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
    <event>
      <event_id>455</event_id>
      <event_series_id>15</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-29</event_date>
      <tickets_available>500</tickets_available>
      <tickets_remaining>500</tickets_remaining>
    </event>
  </venue_event_listing>
</venue_events>



PL/SQL procedure successfully completed.


*/