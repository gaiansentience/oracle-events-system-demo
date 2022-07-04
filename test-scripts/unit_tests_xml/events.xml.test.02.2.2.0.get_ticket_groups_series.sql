set serveroutput on;
declare
    l_venue_id number;
    l_event_series_id number;
    l_xml xmltype;
begin
    select venue_id into l_venue_id from venues where venue_name = 'The Pink Pony Revue';
    
    select max(event_series_id) into l_event_series_id from events where venue_id = l_venue_id and event_name = 'Cool Jazz Evening';
    
    l_xml := events_xml_api.get_ticket_groups_series(p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
--BEFORE CREATING TICKET GROUPS
<event_series_ticket_groups>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>17</events_in_series>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <event_tickets_available>200</event_tickets_available>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>UNDEFINED</price_category>
      <price>0</price>
      <tickets_available>200</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_groups>

--AFTER CREATING TICKET GROUPS

<event_series_ticket_groups>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <events_in_series>17</events_in_series>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <event_tickets_available>200</event_tickets_available>
  </event_series>
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>100</price>
      <tickets_available>50</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <price_category>GENERAL ADMISSION</price_category>
      <price>50</price>
      <tickets_available>150</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_series_ticket_groups>


*/