set serveroutput on;
declare
    l_xml xmltype;
    l_customer_email varchar2(50) := 'James.Kirk@example.customer.com';
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    
    l_xml := events_xml_api.get_customer_event_series_tickets_by_email(p_customer_email => l_customer_email, p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;

/*
<customer_tickets>
  <customer>
    <customer_id>3961</customer_id>
    <customer_name>James Kirk</customer_name>
    <customer_email>James.Kirk@example.customer.com</customer_email>
  </customer>
  <event_series>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>82</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <series_tickets>102</series_tickets>
  </event_series>
  <events>
    <event>
      <event_id>637</event_id>
      <event_date>2023-05-04</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2486</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80291</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2503</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80308</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>638</event_id>
      <event_date>2023-05-11</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2487</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80292</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2504</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80309</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>639</event_id>
      <event_date>2023-05-18</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2488</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80293</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2505</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80310</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>640</event_id>
      <event_date>2023-05-25</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2489</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80294</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2506</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80311</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>641</event_id>
      <event_date>2023-06-01</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2490</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80295</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2507</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80312</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>642</event_id>
      <event_date>2023-06-08</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2491</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80296</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2508</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80313</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>643</event_id>
      <event_date>2023-06-15</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2492</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80297</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2509</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80314</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>644</event_id>
      <event_date>2023-06-22</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2493</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80298</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2510</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80315</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>645</event_id>
      <event_date>2023-06-29</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2494</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80299</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2511</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80316</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>646</event_id>
      <event_date>2023-07-06</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2495</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80300</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2512</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80317</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>647</event_id>
      <event_date>2023-07-13</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2496</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80301</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2513</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80318</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>648</event_id>
      <event_date>2023-07-20</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2497</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80302</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2514</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80319</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>649</event_id>
      <event_date>2023-07-27</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2498</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80303</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2515</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80320</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>650</event_id>
      <event_date>2023-08-03</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2499</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80304</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2516</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80321</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>651</event_id>
      <event_date>2023-08-10</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2500</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80305</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2517</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80322</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>652</event_id>
      <event_date>2023-08-17</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2501</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80306</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2518</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80323</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>653</event_id>
      <event_date>2023-08-24</event_date>
      <event_tickets>6</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2502</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80307</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2519</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80324</ticket_sales_id>
          <ticket_quantity>4</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
  </events>
</customer_tickets>



PL/SQL procedure successfully completed.



*/