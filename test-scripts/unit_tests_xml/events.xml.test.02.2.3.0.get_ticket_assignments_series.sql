declare
  p_event_series_id number := 15;
  l_xml xmltype;
begin

  l_xml := events_xml_api.get_ticket_assignments_series(p_event_series_id => p_event_series_id,p_formatted => true);

dbms_output.put_line(l_xml.getclobval());

end;

/*

<event_series_ticket_assignment>
  <event_series>
    <venue>
      <venue_id>2</venue_id>
      <venue_name>Club 11</venue_name>
      <organizer_email>Mary.Rivera@Club11.com</organizer_email>
      <organizer_name>Mary Rivera</organizer_name>
    </venue>
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
      <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>30</tickets_assigned>
          <assigned_to_others>30</assigned_to_others>
          <max_available>70</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>100</tickets_assigned>
          <assigned_to_others>200</assigned_to_others>
          <max_available>200</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>1</reseller_id>
      <reseller_name>Events For You</reseller_name>
      <reseller_email>ticket.sales@EventsForYou.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>2</reseller_id>
      <reseller_name>MaxTix</reseller_name>
      <reseller_email>ticket.sales@MaxTix.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>3</reseller_id>
      <reseller_name>Old School</reseller_name>
      <reseller_email>ticket.sales@OldSchool.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>30</tickets_assigned>
          <assigned_to_others>30</assigned_to_others>
          <max_available>70</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>200</tickets_assigned>
          <assigned_to_others>100</assigned_to_others>
          <max_available>300</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>4</reseller_id>
      <reseller_name>Source Tix</reseller_name>
      <reseller_email>ticket.sales@SourceTix.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>5</reseller_id>
      <reseller_name>The Source</reseller_name>
      <reseller_email>ticket.sales@TheSource.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>6</reseller_id>
      <reseller_name>Ticket Supply</reseller_name>
      <reseller_email>ticket.sales@TicketSupply.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>7</reseller_id>
      <reseller_name>Ticket Time</reseller_name>
      <reseller_email>ticket.sales@TicketTime.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>8</reseller_id>
      <reseller_name>Ticketron</reseller_name>
      <reseller_email>ticket.sales@Ticketron.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>9</reseller_id>
      <reseller_name>Tickets 2 Go</reseller_name>
      <reseller_email>ticket.sales@Tickets2Go.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>10</reseller_id>
      <reseller_name>Tickets R Us</reseller_name>
      <reseller_email>ticket.sales@TicketsRUs.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>11</reseller_id>
      <reseller_name>Your Ticket Supplier</reseller_name>
      <reseller_email>ticket.sales@YourTicketSupplier.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>100</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>60</assigned_to_others>
          <max_available>40</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>400</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>300</assigned_to_others>
          <max_available>100</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
  </ticket_resellers>
</event_series_ticket_assignment>



PL/SQL procedure successfully completed.



*/