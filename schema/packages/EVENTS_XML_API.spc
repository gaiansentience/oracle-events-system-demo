create or replace package events_xml_api
authid definer
as

    function format_xml_clob(
        p_xml_doc in xmltype
    ) return xmltype;

    function format_xml_string(
        p_xml_doc in xmltype
    ) return xmltype;

    function get_all_resellers
    (
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_reseller
    (
        p_reseller_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    procedure create_reseller
    (
        p_xml_doc in out xmltype
    );

    function get_all_venues
    (
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_venue
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    procedure create_venue
    (
        p_xml_doc in out xmltype
    );

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

    procedure create_event
    (
        p_xml_doc in out xmltype
    );

    procedure create_weekly_event
    (
        p_xml_doc in out xmltype
    );

    function get_event
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return xmltype;

    procedure create_customer
    (
        p_xml_doc in out xmltype
    );

--return ticket groups for event as json document
    function get_ticket_groups
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;

--update ticket groups using a json document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
    procedure update_ticket_groups
    (
        p_xml_doc in out xmltype
    );

--return possible reseller ticket assignments for event as json document
--returns array of all resellers with ticket groups as nested array
    function get_ticket_assignments
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;

--update ticket assignments for a reseller using a json document in the same format as get_event_reseller_ticket_assignments
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

--get pricing and availability for tickets created for the event
    function get_event_ticket_prices
    (
        p_event_id in number,
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

--xml input for purchase tickets from xxxx is modifed from xml format from get_event_tickets_available_[venue|reseller]
--customer format is same as get_customer_tickets
/*

<ticket_purchase_request>
  <purchase_channel>reseller|VENUE</purchase_channel>
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
    <*reseller_name>Old School</reseller_name>
  </reseller>  
  <ticket_groups>
    <ticket_group>
      <ticket_group_id>922</ticket_group_id>
      <*price_category>VIP</price_category>
      <price>50</price>
      <ticket_quantity_requested>6</ticket_quantity_requested>
      <**ticket_quantity_purchased>0</ticket_quantity_purchased>
      <**extended_price>0</extended_price>
      <**ticket_sales_id>0<ticket_sales_id</ticket_sales_id>
      <**sales_date>null</sales_date>
      <status_code>success</status_code>
      <status_message>tickets purchased</status_message>
    </ticket_group>
  </ticket_groups>
  <request_status>success or error</request_status>
  <request_errors>#</request_errors>
  <**total_tickets_requested>99</total_tickets_requested>
  <**total_tickets_purchased>88</total_tickets_purchased>
  <**total_purchase_amount>2222</total_purchase_amount>
  <purchase_disclaimer>All Ticket Sales Are Final.</purchase_disclaimer>
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
    procedure purchase_tickets_from_reseller
    (
        p_xml_doc in out nocopy xmltype
    );
    
    procedure purchase_tickets_from_venue
    (
        p_xml_doc in out nocopy xmltype
    );

--get customer tickets purchased for event
--used to verify customer purchases
    function get_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;
    
    function get_customer_event_tickets_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_id in number,
        p_formatted in boolean default false
    ) return xmltype;

end events_xml_api;
