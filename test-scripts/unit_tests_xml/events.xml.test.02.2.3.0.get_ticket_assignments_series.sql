declare
    l_xml xmltype;    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    
    l_xml := events_xml_api.get_ticket_assignments_series(p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
<event_series_ticket_assignment>
  <event_series>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
      <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
      <organizer_name>Julia Stone</organizer_name>
    </venue>
    <event_series_id>82</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <event_tickets_available>200</event_tickets_available>
  </event_series>
  <ticket_resellers>
    <reseller>
      <reseller_id>1</reseller_id>
      <reseller_name>Events For You</reseller_name>
      <reseller_email>ticket.sales@EventsForYou.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
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
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>73</reseller_id>
      <reseller_name>Easy Tickets</reseller_name>
      <reseller_email>tickets@EasyTickets.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>81</reseller_id>
      <reseller_name>Ticket Factory</reseller_name>
      <reseller_email>sales@TicketFactory.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
    <reseller>
      <reseller_id>82</reseller_id>
      <reseller_name>New Wave Tickets</reseller_name>
      <reseller_email>events@NewWaveTickets.com</reseller_email>
      <ticket_assignments>
        <ticket_group>
          <price_category>VIP</price_category>
          <price>100</price>
          <tickets_in_group>50</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>50</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
        <ticket_group>
          <price_category>GENERAL ADMISSION</price_category>
          <price>50</price>
          <tickets_in_group>150</tickets_in_group>
          <tickets_assigned>0</tickets_assigned>
          <assigned_to_others>0</assigned_to_others>
          <max_available>150</max_available>
          <min_assignment>0</min_assignment>
          <sold_by_reseller>0</sold_by_reseller>
          <sold_by_venue>0</sold_by_venue>
        </ticket_group>
      </ticket_assignments>
    </reseller>
  </ticket_resellers>
</event_series_ticket_assignment>


*/