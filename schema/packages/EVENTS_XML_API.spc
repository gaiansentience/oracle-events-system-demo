create or replace package events_xml_api
authid definer
as

    function format_xml_clob(
        p_xml_doc in xmltype
    ) return xmltype;

    function format_xml_string(
        p_xml_doc in xmltype
    ) return xmltype;

/*
<create_customer>
  <customer>
    <customer_name>Kathy Barry</customer_name>
    <customer_email>Kathy.Barry@example.customer.com</customer_email>
  </customer>
</create_customer>    
*/
    procedure create_customer
    (
        p_xml_doc in out nocopy xmltype
    );
/*
<update_customer>
  <customer>
    <customer_id>4</customer_id>
    <customer_name>Kathy Barry</customer_name>
    <customer_email>Kathy.Barry@example.customer.com</customer_email>
  </customer>
</update_customer>    
*/
    procedure update_customer
    (
        p_xml_doc in out nocopy xmltype
    );
    
    function get_customer
    (
        p_customer_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_customer_id
    (
        p_customer_email in customers.customer_email%type,
        p_formatted in boolean default false
    ) return xmltype;

/*
<create_reseller>
  <reseller>
    <reseller_name>New Wave Tickets</reseller_name>
    <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
    <commission_percent>.1111</commission_percent>
  </reseller>
</create_reseller>
*/
    procedure create_reseller
    (
        p_xml_doc in out nocopy xmltype
    );
/*
<update_reseller>
  <reseller>
    <reseller_id>21</reseller_id>
    <reseller_name>New Wave Tickets</reseller_name>
    <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
    <commission_percent>.1313</commission_percent>
  </reseller>
</update_reseller>
*/
    procedure update_reseller
    (
        p_xml_doc in out nocopy xmltype
    );
    
    function get_reseller
    (
        p_reseller_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    function get_all_resellers
    (
        p_formatted in boolean default false
    ) return xmltype;
    
/*
<create_venue>
  <venue>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
    <max_event_capacity>200</max_event_capacity>
  </venue>
</create_venue>
*/
    procedure create_venue
    (
        p_xml_doc in out nocopy xmltype
    );
/*
<update_venue>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Revue</venue_name>
    <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
    <organizer_name>Julia Stein</organizer_name>
    <max_event_capacity>350</max_event_capacity>
  </venue>  
</update_venue>
*/
    procedure update_venue
    (
        p_xml_doc in out nocopy xmltype
    );

    function get_venue
    (
        p_venue_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_all_venues
    (
        p_formatted in boolean default false
    ) return xmltype;

    function get_venue_summary
    (
        p_venue_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_all_venues_summary
    (
        p_formatted in boolean default false
    ) return xmltype;

/*
<create_event>
  <event>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Review</venue_name>
    </venue>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <tickets_available>200</tickets_available>
  </event>
</create_event>
*/
    procedure create_event
    (
        p_xml_doc in out nocopy xmltype
    );
/*
<create_event_series>
  <event_series>
    <venue>
      <venue_id>21</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
    </venue>
    <event_name>Cool Jazz Evening</event_name>
    <event_start_date>2023-05-01</event_start_date>
    <event_end_date>2023-08-31</event_end_date>
    <event_day>Thursday</event_day>
    <tickets_available>200</tickets_available>
  </event_series>
</create_event_series>
*/    
    procedure create_weekly_event
    (
        p_xml_doc in out nocopy xmltype
    );

/*
<update_event>
  <event>
    <event_name>Evangeline Thorpe</event_name>
    <event_date>2023-05-01</event_date>
    <tickets_available>200</tickets_available>
  </event>
</update_event>
*/
    procedure update_event
    (
        p_xml_doc in out nocopy xmltype
    );

/*
<update_event_series>
  <event_series>
    <event_series_id>13</event_series_id>
    <event_name>Cool Jazz Evening</event_name>
    <tickets_available>200</tickets_available>
  </event_series>
</update_event_series>
*/
    procedure update_event_series
    (
        p_xml_doc in out nocopy xmltype
    );

    function get_event
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    function get_event_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    function get_venue_events
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    function get_venue_event_series
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    function get_ticket_groups
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_ticket_groups_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype;

--update ticket groups using an xml document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
    procedure update_ticket_groups
    (
        p_xml_doc in out nocopy xmltype
    );

    procedure update_ticket_groups_series
    (
        p_xml_doc in out nocopy xmltype
    );

--return possible reseller ticket assignments for event as xml document
--returns array of all resellers with ticket groups as nested array
    function get_ticket_assignments
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_ticket_assignments_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype;

--update ticket assignments for a reseller using an xml document in the same format as get_event_reseller_ticket_assignments
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
--supports assignment of multiple ticket groups to multiple resellers
--WARNING:  IF MULTIPLE RESELLERS ARE SUBMITTED ASSIGNMENTS CAN EXCEED LIMITS CREATING MULTIPLE ERRORS AT THE END OF BATCH
--IT IS RECOMMENDED TO SUBMIT ASSIGNMENTS FOR ONE RESELLER AT A TIME AND REFRESH THE ASSIGNMENTS DOCUMENT TO SEE CHANGED LIMITS
--additional informational fields from get_event_reseller_ticket_assignments may be present
--if additional informational fields are present they will not be processed
    procedure update_ticket_assignments
    (
        p_xml_doc in out nocopy xmltype
    );

    procedure update_ticket_assignments_series
    (
        p_xml_doc in out nocopy xmltype
    );

--get pricing and availability for tickets created for the event
    function get_event_ticket_prices
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_event_series_ticket_prices
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_event_tickets_available_all
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_event_tickets_available_venue
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_event_series_tickets_available_all
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_event_series_tickets_available_venue
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return xmltype;


--xml input for purchase tickets from xxxx is modifed from xml format from get_event_tickets_available_[venue|reseller]
--customer format is same as get_customer_tickets

/*
<ticket_purchase_request>
  <purchase_channel>reseller name|VENUE</purchase_channel>
  <event>
    <event_id>2</event_id>
  </event>
  <customer>
    <**customer_id>1438</customer_id>
    <*customer_name>Gary Walsh</customer_name> used to create customer record if customer email is not on file
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
  </customer>
  <*reseller> optional if purchase channel is VENUE
    <reseller_id>3</reseller_id>
  </reseller>  
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>922</ticket_group_id>
      <**price_category>VIP</price_category>
      <price>50</price>
      <tickets_requested>6</tickets_requested>
      <**tickets_purchased>0</tickets_purchased>
      <**actual_price>10</actual_price>
      <**purchase_amount>0</purchase_amount>
      <**ticket_sales_id>0<ticket_sales_id</ticket_sales_id>
      <**status_code>success</status_code>
      <**status_message>tickets purchased</status_message>
    </ticket_group>
  </ticket_groups>
  <**request_status>success or error</request_status>
  <**request_errors>#</request_errors>
  <**total_tickets_requested>99</total_tickets_requested>
  <**total_tickets_purchased>88</total_tickets_purchased>
  <**total_purchase_amount>2222</total_purchase_amount>
  <**purchase_disclaimer>All Ticket Sales Are Final.</purchase_disclaimer>
</ticket_purchase_request>
*/
-- optional elements are marked with [*] and will be ignored if present
-- reply elements are marked with [**] and will be returned.
--customer will be verified by email
--if customer email is in system, customer_id will be returned with the current customer name
--if customer email is not in system, customer will be created (if no customer name was provided the email will be used for the customer name)

--ticket purchases can include multiple ticket groups
--tickets can only be purchased for one customer per request
--all ticket groups in a request must be from the same reseller
--availability for a ticket group will be checked at time of purchase
--if the requested quantity is not available from the reseller the transaction for the ticket group will not go through
--all ticket groups with sufficient available quantities will be purchased to fulfill the purchase request
--price for a ticket group will be checked at time of purchase
--if current price is equal to or lower than requested price transaction will go through at the lower price
--if current price is greater than requested price transaction will be cancelled
    procedure purchase_tickets_reseller
    (
        p_xml_doc in out nocopy xmltype
    );
    
    procedure purchase_tickets_venue
    (
        p_xml_doc in out nocopy xmltype
    );

/*
<ticket_purchase_request>
  <purchase_channel>reseller name|VENUE</purchase_channel>
  <event_series>
    <event_series_id>2</event_series_id>
  </event_series>
  <customer>
    <**customer_id>1438</customer_id>
    <*customer_name>Gary Walsh</customer_name> used to create customer record if customer email is not on file
    <customer_email>Gary.Walsh@example.customer.com</customer_email>
  </customer>
  <*reseller> optional if purchase channel is VENUE
    <reseller_id>3</reseller_id>
  </reseller>  
  <ticket_groups>
    <ticket_group>
      <price_category>VIP</price_category>
      <price>50</price>
      <tickets_requested>6</tickets_requested>
      <**tickets_purchased>0</tickets_purchased>
      <**purchase_amount>0</purchase_amount>
      <**average_price>0</average_price>
      <**status_code>success</status_code>
      <**status_message>tickets purchased</status_message>
    </ticket_group>
  </ticket_groups>
  <**request_status>success or error</request_status>
  <**request_errors>#</request_errors>
  <**total_tickets_requested>99</total_tickets_requested>
  <**total_tickets_purchased>88</total_tickets_purchased>
  <**total_purchase_amount>2222</total_purchase_amount>
  <**purchase_disclaimer>All Ticket Sales Are Final.</purchase_disclaimer>
</ticket_purchase_request>
*/
    --purchase tickets for all available events in an event series
    --ticket groups are specified by price_category and requested price
    --if an event has no available tickets or the price is higher than the requested price the individual transaction will not go through
    --if purchasing through reseller, reseller availability and price is checked for each event
    --if purchasing through venue, venue availability and price is checked for each event
    --if any event in the series has a lower price currently than requested price the transaction will use the current price
    procedure purchase_tickets_reseller_series
    (
        p_xml_doc in out nocopy xmltype
    );
    
    procedure purchase_tickets_venue_series
    (
        p_xml_doc in out nocopy xmltype
    );


--get customer tickets purchased for event
--used to verify customer purchases
    function get_customer_event_purchases
    (
        p_customer_id in number,
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_customer_event_purchases_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    function get_customer_event_series_purchases
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_customer_event_series_purchases_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return xmltype;

    --add methods to print tickets
    
    --add ticket methods (reissue)
    
    /*    
    <ticket_validate>
        <event>
            <event_id>123</event_id>        
        </event>
        <ticket>
            <serial_code>xyz</serial_code>
        </ticket>
        <**status_code>SUCCESS|ERROR</status_code>
        <**status_message>VALIDATED|error message</status_message>        
    </ticket_validate>
    */
    procedure ticket_validate
    (
        p_xml_doc in out nocopy xmltype
    );
    
    /*
    <ticket_verify_validation>
        <event>
            <event_id>123</event_id>        
        </event>
        <ticket>
            <serial_code>xyz</serial_code>
        </ticket>
        <**status_code>SUCCESS|ERROR</status_code>
        <**status_message>VERIFIED|error message</status_message>        
    </ticket_verify_validation>
    */    
    procedure ticket_verify_validation
    (
        p_xml_doc in out nocopy xmltype
    );

    /*
    <ticket_verify_restricted_access>
        <*event>  event id is implied by ticket group..
            <*event_id>123</event_id>        
        </event>
        <ticket_group>
            <ticket_group_id>456</ticket_group_id>
            <price_category>VIP</price_cateogory>
        </ticket_group>
        <ticket>
            <serial_code>xyz</serial_code>
        </ticket>
        <**status_code>SUCCESS|ERROR</status_code>
        <**status_message>ACCESS VERIFIED|error message</status_message>
    </ticket_verify_restricted_access>
    */    
    procedure ticket_verify_restricted_access
    (
        p_xml_doc in out nocopy xmltype
    );

    /*
    <ticket_cancel>
        <event>
            <event_id>123</event_id>        
        </event>    
        <ticket>
            <serial_code>xyz</serial_code>
        </ticket>
        <**status_code>SUCCESS|ERROR</status_code>
        <**status_message>CANCELLED|error message</status_message>
    </ticket_cancel>
    */    
    procedure ticket_cancel
    (
        p_xml_doc in out nocopy xmltype
    );

end events_xml_api;
 