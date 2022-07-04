set serveroutput on;
declare
  l_venue_id number;
  l_xml xmltype;
begin

    select venue_id into l_venue_id from venues where venue_name = 'The Pink Pony Revue';

    l_xml := events_xml_api.get_venue_event_series(p_venue_id => l_venue_id, p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
--BEFORE CREATING SERIES

<venue_events>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
    <max_event_capacity>200</max_event_capacity>
    <venue_scheduled_events>1</venue_scheduled_events>
  </venue>
  <venue_event_listing/>
</venue_events>

--AFTER CREATING SERIES
<venue_events>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
    <max_event_capacity>200</max_event_capacity>
    <venue_scheduled_events>18</venue_scheduled_events>
  </venue>
  <venue_event_listing>
    <event>
      <event_id>562</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-04</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>563</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-11</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>564</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-18</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>565</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-05-25</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>566</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-01</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>567</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-08</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>568</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-15</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>569</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-22</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>570</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-06-29</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>571</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-06</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>572</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-13</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>573</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-20</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>574</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-07-27</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>575</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-03</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>576</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-10</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>577</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-17</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
    <event>
      <event_id>578</event_id>
      <event_series_id>21</event_series_id>
      <event_name>Cool Jazz Evening</event_name>
      <event_date>2023-08-24</event_date>
      <tickets_available>200</tickets_available>
      <tickets_remaining>200</tickets_remaining>
    </event>
  </venue_event_listing>
</venue_events>


*/