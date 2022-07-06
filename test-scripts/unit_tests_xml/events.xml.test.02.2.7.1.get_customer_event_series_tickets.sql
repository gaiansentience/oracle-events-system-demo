set serveroutput on;
declare
    l_customer_email varchar2(50) := 'Gary.Walsh@example.customer.com';
    l_customer_id number;
    l_venue_id number;
    l_event_series_id number;

  p_customer_id number;
  p_event_id number := 1;
  l_xml xmltype;
begin
    l_customer_id := events_api.get_customer_id(l_customer_email);
    
    select venue_id into l_venue_id from venues where venue_name = 'The Pink Pony Revue';
    select max(event_series_id) into l_event_series_id from events where event_name = 'Cool Jazz Evening';

    l_xml := events_xml_api.get_customer_event_series_tickets(p_customer_id => l_customer_id,p_event_series_id => l_event_series_id, p_formatted => true);

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
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <series_tickets_purchased>170</series_tickets_purchased>
  </event_series>
  <events>
    <event>
      <event_id>562</event_id>
      <event_date>2023-05-04</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2284</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71025</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2284</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71059</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2301</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71042</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2301</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71076</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>563</event_id>
      <event_date>2023-05-11</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2285</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71026</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2285</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71060</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2302</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71043</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2302</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71077</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>564</event_id>
      <event_date>2023-05-18</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2286</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71027</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2286</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71061</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2303</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71044</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2303</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71078</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>565</event_id>
      <event_date>2023-05-25</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2287</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71028</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2287</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71062</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2304</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71045</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2304</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71079</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>566</event_id>
      <event_date>2023-06-01</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2288</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71029</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2288</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71063</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2305</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71046</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2305</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71080</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>567</event_id>
      <event_date>2023-06-08</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2289</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71030</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2289</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71064</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2306</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71047</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2306</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71081</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>568</event_id>
      <event_date>2023-06-15</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2290</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71031</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2290</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71065</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2307</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71048</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2307</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71082</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>569</event_id>
      <event_date>2023-06-22</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2291</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71032</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2291</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71066</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2308</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71049</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2308</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71083</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>570</event_id>
      <event_date>2023-06-29</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2292</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71033</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2292</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71067</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2309</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71050</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2309</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71084</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>571</event_id>
      <event_date>2023-07-06</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2293</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71034</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2293</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71068</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2310</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71051</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2310</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71085</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>572</event_id>
      <event_date>2023-07-13</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2294</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71035</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2294</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71069</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2311</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71052</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2311</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71086</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>573</event_id>
      <event_date>2023-07-20</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2295</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71036</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2295</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71070</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2312</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71053</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2312</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71087</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>574</event_id>
      <event_date>2023-07-27</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2296</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71037</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2296</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71071</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2313</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71054</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2313</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71088</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>575</event_id>
      <event_date>2023-08-03</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2297</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71038</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2297</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71072</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2314</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71055</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2314</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71089</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>576</event_id>
      <event_date>2023-08-10</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2298</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71039</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2298</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71073</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2315</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71056</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2315</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71090</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>577</event_id>
      <event_date>2023-08-17</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2299</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71040</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2299</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71074</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2316</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71057</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2316</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71091</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>578</event_id>
      <event_date>2023-08-24</event_date>
      <event_tickets_purchased>10</event_tickets_purchased>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2300</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71041</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2300</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71075</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2317</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71058</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2317</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71092</ticket_sales_id>
          <ticket_quantity>3</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_id>3</reseller_id>
          <reseller_name>Old School</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
  </events>
</customer_tickets>

*/