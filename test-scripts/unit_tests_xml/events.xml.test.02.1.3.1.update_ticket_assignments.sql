set serveroutput on;
declare
l_xml_doc xmltype;
l_xml clob;

    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
    l_event_id number;
    l_event_name events.event_name%type := 'Evangeline Thorpe';
    l_reseller_id_1 number;
    l_reseller_name_1 resellers.reseller_name%type := 'New Wave Tickets';
    l_reseller_id_2 number;
    l_reseller_name_2 resellers.reseller_name%type := 'Old School';

begin
    l_venue_id := events_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_id := events_api.get_event_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_reseller_id_1 := events_api.get_reseller_id(p_reseller_name => l_reseller_name_1);
    l_reseller_id_2 := events_api.get_reseller_id(p_reseller_name => l_reseller_name_2);
    
    
l_xml :=
'
<event_ticket_assignment>
  <event>
    <event_id>$$EVENT_ID$$</event_id>
    <event_name>$$EVENT_NAME$$</event_name>
  </event>
  <ticket_resellers>
    <reseller>
      <reseller_id>$$RESELLER_ID_1$$</reseller_id>
      <reseller_name>$$RESELLER_NAME_1$$</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>2485</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <price>42</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>50</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>2484</ticket_group_id>
          <price_category>VIP</price_category>
          <tickets_assigned>20</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>$$RESELLER_ID_2$$</reseller_id>
      <reseller_name>$$RESELLER_NAME_2$$</reseller_name>
      <reseller_email>ticket.sales@OldSchool.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>2485</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>50</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>2483</ticket_group_id>
          <price_category>SPONSOR</price_category>
          <tickets_assigned>20</tickets_assigned>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>2484</ticket_group_id>
          <price_category>VIP</price_category>
          <tickets_assigned>20</tickets_assigned>
        </ticket_group>
      </ticket_assignments>
    </reseller>
  </ticket_resellers>
</event_ticket_assignment>
';

    l_xml := replace(l_xml, '$$EVENT_ID$$', l_event_id);
    l_xml := replace(l_xml, '$$EVENT_NAME$$', l_event_name);
    l_xml := replace(l_xml, '$$RESELLER_ID_1$$', l_reseller_id_1);
    l_xml := replace(l_xml, '$$RESELLER_NAME_1$$', l_reseller_name_1);
    l_xml := replace(l_xml, '$$RESELLER_ID_2$$', l_reseller_id_2);
    l_xml := replace(l_xml, '$$RESELLER_NAME_2$$', l_reseller_name_2);


    l_xml_doc := xmltype(l_xml);

    events_xml_api.update_ticket_assignments(p_xml_doc => l_xml_doc);
    dbms_output.put_line(l_xml_doc.getclobval);

end;


/*

<event_ticket_assignment>
  <event>
    <event_id>636</event_id>
    <event_name>Evangeline Thorpe</event_name>
  </event>
  <ticket_resellers>
    <reseller>
      <reseller_id>82</reseller_id>
      <reseller_name>New Wave Tickets</reseller_name>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>2485</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <price>42</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>50</tickets_assigned>
          <ticket_assignment_id>10284</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>2484</ticket_group_id>
          <price_category>VIP</price_category>
          <tickets_assigned>20</tickets_assigned>
          <ticket_assignment_id>10285</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
    <reseller>
      <reseller_id>3</reseller_id>
      <reseller_name>Old School</reseller_name>
      <reseller_email>ticket.sales@OldSchool.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <ticket_group_id>2485</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <tickets_assigned>50</tickets_assigned>
          <ticket_assignment_id>10286</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>2483</ticket_group_id>
          <price_category>SPONSOR</price_category>
          <tickets_assigned>20</tickets_assigned>
          <ticket_assignment_id>10287</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
        <ticket_group>
          <ticket_group_id>2484</ticket_group_id>
          <price_category>VIP</price_category>
          <tickets_assigned>20</tickets_assigned>
          <ticket_assignment_id>10288</ticket_assignment_id>
          <status_code>SUCCESS</status_code>
          <status_message>created/updated ticket group assignment</status_message>
        </ticket_group>
      </ticket_assignments>
      <reseller_status>SUCCESS</reseller_status>
      <reseller_errors>0</reseller_errors>
    </reseller>
  </ticket_resellers>
  <request_status>SUCCESS</request_status>
  <request_errors>0</request_errors>
</event_ticket_assignment>



PL/SQL procedure successfully completed.



*/