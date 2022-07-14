set serveroutput on;
declare
    l_xml xmltype;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
    l_event_id number;
    l_event_name events.event_name%type := 'Evangeline Thorpe';
begin
    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_xml := events_xml_api.get_ticket_groups(p_event_id => l_event_id, p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*
--BEFORE CREATING TICKET GROUPS
<event_ticket_groups>
  <event>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets_available>300</event_tickets_available>
  </event>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>0</ticket_group_id>
      <price_category>UNDEFINED</price_category>
      <price>0</price>
      <tickets_available>300</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>



--AFTER CREATING TICKET GROUPS
<event_ticket_groups>
  <event>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets_available>300</event_tickets_available>
  </event>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>2483</ticket_group_id>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>50</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2484</ticket_group_id>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>50</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2485</ticket_group_id>
      <price_category>GENERAL ADMISSION</price_category>
      <price>42</price>
      <tickets_available>200</tickets_available>
      <currently_assigned>0</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>


--AFTER ASSIGNMENTS 
<event_ticket_groups>
  <event>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <event_tickets_available>300</event_tickets_available>
  </event>
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>2483</ticket_group_id>
      <price_category>SPONSOR</price_category>
      <price>120</price>
      <tickets_available>50</tickets_available>
      <currently_assigned>20</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2484</ticket_group_id>
      <price_category>VIP</price_category>
      <price>85</price>
      <tickets_available>50</tickets_available>
      <currently_assigned>40</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
    <ticket_group>
      <ticket_group_id>2485</ticket_group_id>
      <price_category>GENERAL ADMISSION</price_category>
      <price>42</price>
      <tickets_available>200</tickets_available>
      <currently_assigned>100</currently_assigned>
      <sold_by_venue>0</sold_by_venue>
    </ticket_group>
  </ticket_groups>
</event_ticket_groups>



PL/SQL procedure successfully completed.



*/