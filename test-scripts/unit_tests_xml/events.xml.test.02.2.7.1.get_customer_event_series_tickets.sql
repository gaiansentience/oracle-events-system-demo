set serveroutput on;
declare
    l_xml xmltype;
    l_customer_email varchar2(50) := 'Gary.Walsh@example.customer.com';
    l_customer_id number;    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Cool Jazz Evening';
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'The Pink Pony Revue';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_customer_id := customer_api.get_customer_id(p_customer_email => l_customer_email);

    l_xml := events_xml_api.get_customer_event_series_tickets(p_customer_id => l_customer_id, p_event_series_id => l_event_series_id, p_formatted => true);

    dbms_output.put_line(l_xml.getclobval());

end;


/*

<customer_tickets>
  <customer>
    <customer_id>3633</customer_id>
    <customer_name>Gary Walsh</customer_name>
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
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
    <series_tickets>119</series_tickets>
  </event_series>
  <events>
    <event>
      <event_id>637</event_id>
      <event_date>2023-05-04</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2486</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80257</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2503</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80274</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>638</event_id>
      <event_date>2023-05-11</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2487</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80258</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2504</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80275</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>639</event_id>
      <event_date>2023-05-18</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2488</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80259</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2505</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80276</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>640</event_id>
      <event_date>2023-05-25</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2489</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80260</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2506</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80277</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>641</event_id>
      <event_date>2023-06-01</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2490</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80261</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2507</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80278</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>642</event_id>
      <event_date>2023-06-08</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2491</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80262</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2508</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80279</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>643</event_id>
      <event_date>2023-06-15</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2492</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80263</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2509</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80280</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>644</event_id>
      <event_date>2023-06-22</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2493</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80264</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2510</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80281</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>645</event_id>
      <event_date>2023-06-29</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2494</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80265</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2511</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80282</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>646</event_id>
      <event_date>2023-07-06</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2495</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80266</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2512</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80283</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>647</event_id>
      <event_date>2023-07-13</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2496</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80267</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2513</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80284</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>648</event_id>
      <event_date>2023-07-20</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2497</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80268</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2514</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80285</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>649</event_id>
      <event_date>2023-07-27</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2498</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80269</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2515</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80286</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>650</event_id>
      <event_date>2023-08-03</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2499</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80270</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2516</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80287</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>651</event_id>
      <event_date>2023-08-10</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2500</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80271</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2517</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80288</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>652</event_id>
      <event_date>2023-08-17</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2501</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80272</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2518</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80289</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>653</event_id>
      <event_date>2023-08-24</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2502</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>80273</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2519</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>80290</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-14</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
  </events>
</customer_tickets>



PL/SQL procedure successfully completed.


*/