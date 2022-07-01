set serveroutput on;
declare
p_xml_doc xmltype;
l_xml varchar2(32000);
begin

l_xml :=
'
<event_series_ticket_assignment>
  <event_series>
    <event_series_id>15</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-04-06</first_event_date>
    <last_event_date>2023-06-29</last_event_date>
    <event_tickets_available>500</event_tickets_available>
  </event_series>
  <ticket_resellers>
    <reseller>
      <reseller_id>21</reseller_id>
      <reseller_name>New Wave Tickets</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>30</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>100</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>3</reseller_id>
      <reseller_name>Old School</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>30</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>200</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
  </ticket_resellers>
</event_series_ticket_assignment>
';

p_xml_doc := xmltype(l_xml);

  events_xml_api.update_ticket_assignments_series(
    p_xml_doc => p_xml_doc
  );

dbms_output.put_line(p_xml_doc.getclobval);

end;


/*

<event_series_ticket_assignment>
  <event_series>
    <event_series_id>15</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-04-06</first_event_date>
    <last_event_date>2023-06-29</last_event_date>
    <event_tickets_available>500</event_tickets_available>
  </event_series>
  <ticket_resellers>
    <reseller>
      <reseller_id>21</reseller_id>
      <reseller_name>New Wave Tickets</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>30</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (VIP) assigned to reseller for 13 events in series</status_message>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>100</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
    <reseller>
      <reseller_id>3</reseller_id>
      <reseller_name>Old School</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <tickets_assigned>30</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (VIP) assigned to reseller for 13 events in series</status_message>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>200</tickets_assigned>
          <status_code>SUCCESS</status_code>
          <status_message>Ticket group (GENERAL ADMISSION) assigned to reseller for 13 events in series</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
  </ticket_resellers>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_series_ticket_assignment>



PL/SQL procedure successfully completed.



*/