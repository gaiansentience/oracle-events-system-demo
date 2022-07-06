set serveroutput on;
declare
    l_customer_email varchar2(50) := 'James.Kirk@example.customer.com';
    l_venue_id number;
    l_event_series_id number;
    l_xml xmltype;
begin

    l_venue_id := events_api.get_venue_id(p_venue_name => 'The Pink Pony Revue');
    l_event_series_id := events_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => 'Cool Jazz Evening');
    
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
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_series_id>21</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <first_event_date>2023-05-04</first_event_date>
    <last_event_date>2023-08-24</last_event_date>
    <series_tickets>119</series_tickets>
  </event_series>
  <events>
    <event>
      <event_id>562</event_id>
      <event_date>2023-05-04</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2284</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71093</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2301</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71110</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>563</event_id>
      <event_date>2023-05-11</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2285</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71094</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2302</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71111</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>564</event_id>
      <event_date>2023-05-18</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2286</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71095</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2303</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71112</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>565</event_id>
      <event_date>2023-05-25</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2287</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71096</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2304</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71113</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>566</event_id>
      <event_date>2023-06-01</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2288</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71097</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2305</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71114</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>567</event_id>
      <event_date>2023-06-08</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2289</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71098</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2306</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71115</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>568</event_id>
      <event_date>2023-06-15</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2290</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71099</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2307</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71116</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>569</event_id>
      <event_date>2023-06-22</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2291</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71100</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2308</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71117</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>570</event_id>
      <event_date>2023-06-29</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2292</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71101</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2309</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71118</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>571</event_id>
      <event_date>2023-07-06</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2293</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71102</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2310</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71119</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>572</event_id>
      <event_date>2023-07-13</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2294</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71103</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2311</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71120</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>573</event_id>
      <event_date>2023-07-20</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2295</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71104</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2312</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71121</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>574</event_id>
      <event_date>2023-07-27</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2296</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71105</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2313</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71122</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>575</event_id>
      <event_date>2023-08-03</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2297</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71106</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2314</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71123</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>576</event_id>
      <event_date>2023-08-10</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2298</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71107</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2315</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71124</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>577</event_id>
      <event_date>2023-08-17</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2299</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71108</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2316</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71125</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
    <event>
      <event_id>578</event_id>
      <event_date>2023-08-24</event_date>
      <event_tickets>7</event_tickets>
      <event_ticket_purchases>
        <ticket_purchase>
          <ticket_group_id>2300</ticket_group_id>
          <price_category>VIP</price_category>
          <ticket_sales_id>71109</ticket_sales_id>
          <ticket_quantity>2</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
        <ticket_purchase>
          <ticket_group_id>2317</ticket_group_id>
          <price_category>GENERAL ADMISSION</price_category>
          <ticket_sales_id>71126</ticket_sales_id>
          <ticket_quantity>5</ticket_quantity>
          <sales_date>2022-07-04</sales_date>
          <reseller_name>VENUE DIRECT SALES</reseller_name>
        </ticket_purchase>
      </event_ticket_purchases>
    </event>
  </events>
</customer_tickets>


*/