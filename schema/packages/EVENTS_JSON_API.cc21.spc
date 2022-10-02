create or replace package events_json_api
authid definer
as

--$if dbms_db_version.version >= 21 $then json $else clob $end
--$if dbms_db_version.version >= 21 $then json; $else clob; $end

    function format_json
    (
        p_json_doc in $if dbms_db_version.version >= 21 $then json $else clob $end
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
        
/*    
{
  "customer_name" : "Andi Warenkovna",
  "customer_email" : "Andi.Warenko@example.customer.com"
}    
*/

    procedure create_customer
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

/*
{
  "customer_id" : 5003,
  "customer_name" : "Andrea Warenko",
  "customer_email" : "Andi.Warenko@example.customer.com"
}
*/
    procedure update_customer
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    function get_customer
    (
        p_customer_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_customer_id
    (
        p_customer_email in customers.customer_email%type,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

/*
{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "commission_percent" : 0.09
}
*/
    procedure create_reseller
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

/*
{
  "reseller_id" : 41,
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "sales@TicketFactory.com",
  "commission_percent" : 0.125
}
*/
    procedure update_reseller
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    function get_reseller
    (
        p_reseller_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_all_resellers
    (
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

/*
{
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susie Brewer",
  "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 400
}
*/
    procedure create_venue
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

/*
{
  "venue_id" : 41,
  "venue_name" : "Another Roadside Attraction",
  "organizer_name" : "Susan Brewer",
  "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
  "max_event_capacity" : 500
}
*/
    procedure update_venue
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    function get_venue
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_all_venues
    (
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_venue_summary
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_all_venues_summary
    (
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

/*
{
  "venue_id" : 41,
  "*venue_name" : "Another Roadside Attraction",
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400
}
*/
    procedure create_event
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

/*
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_name" : "Monster Truck Smashup",
  "event_start_date" : "2023-06-01T19:00:00",
  "event_end_date" : "2023-09-01T19:00:00",
  "event_day" : "Wednesday",
  "tickets_available" : 10000
}
*/
    procedure create_weekly_event
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

/*
{
  "event_id" : 581,
  "event_name" : "New Years Mischief",
  "event_date" : "2023-12-31T20:00:00",
  "tickets_available" : 400
}
*/
    procedure update_event
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

/*
{
  "event_series_id" : 13,
  "event_name" : "Monster Truck Smashup",
  "tickets_available" : 10000
}
*/
    procedure update_event_series
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    function get_event
    (
        p_event_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_event_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_venue_events
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_venue_event_series
    (
        p_venue_id in number,
        p_formatted in boolean default false   
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_ticket_groups
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_ticket_groups_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

--update ticket groups using a json document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
    procedure update_ticket_groups
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    procedure update_ticket_groups_series
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

--return possible reseller ticket assignments for event as json document
--returns array of all resellers with ticket groups as nested array
    function get_ticket_assignments
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_ticket_assignments_series
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

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
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    procedure update_ticket_assignments_series
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

--get pricing and availability for tickets created for the event
    function get_event_ticket_prices
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_event_series_ticket_prices
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_event_tickets_available_all
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_event_tickets_available_venue
    (
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_event_tickets_available_reseller
    (
        p_event_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_event_series_tickets_available_all
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_event_series_tickets_available_venue
    (
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_event_series_tickets_available_reseller
    (
        p_event_series_id in number,
        p_reseller_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

--json input for purchase tickets from xxxx is modifed from json format from get_event_tickets_available_[venue|reseller]
/*
{
  "event_id" : 24,
  "purchase_channel" : "RESELLER|VENUE",
  "reseller_id" : 11,
  "[*]reseller_name" : "Your Ticket Supplier",
  "[**]customer_id" : 337,
  "[*]customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 38,
      "[*]price_category" : "VIP",
      "price" : 42,
      "tickets_requested" : 6,
      "[**]status_code" : "SUCCESS|ERRORS",
      "[**]status_message" : 14,  
      "[**]tickets_purchased" : 0,
      "[**]purchase_amount" : 0,
      "[**]ticket_sales_id" : 0
    }
  ],
  "[**]request_status" : "SUCCESS|ERRORS",
  "[**]request_errors" : 14,  
  "[**]total_tickets_requested" : 8,
  "[**]total_tickets_purchased" : 14,  
  "[**]total_purchase_amount" : 410,
  "[**]purchase_disclaimer" : "All Ticket Sales Are Final."
}    
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
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );
    
    procedure purchase_tickets_venue
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

/*
{
  "event_series_id" : 24,
  "purchase_channel" : "RESELLER|VENUE",
  "reseller_id" : 11,  NOTE: ONLY REQUIRED WHEN PURCHASING VIA RESELLER
  "[*]reseller_name" : "Your Ticket Supplier",
  "[**]customer_id" : 337,
  "[*]customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket_groups" :
  [
    {
      "price_category" : "VIP",
      "price" : 42,
      "tickets_requested" : 6,
      "[**]status_code" : "SUCCESS|ERRORS",
      "[**]status_message" : 14,  
      "[**]tickets_purchased" : 0,
      "[**]average_price" : 0,
      "[**]purchase_amount" : 0
    }
  ],
  "[**]request_status" : "SUCCESS|ERRORS",
  "[**]request_errors" : 14,  
  "[**]total_tickets_requested" : 8,
  "[**]total_tickets_purchased" : 14,  
  "[**]total_purchase_amount" : 410,
  "[**]purchase_disclaimer" : "All Ticket Sales Are Final."
}    
*/

    procedure purchase_tickets_reseller_series
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );
    
    procedure purchase_tickets_venue_series
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

--get events with customer purchases
    function get_customer_events
    (
        p_customer_id in number,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_customer_events_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_customer_event_series
    (
        p_customer_id in number,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_customer_event_series_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_venue_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

--get customer purchases for event
--used to verify customer purchases
    function get_customer_event_purchases
    (
        p_customer_id in number,
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_customer_event_purchases_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_customer_event_series_purchases
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_customer_event_series_purchases_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    --add methods to print tickets
    function get_customer_event_tickets_by_sale_id
    (
        p_customer_id in number,
        p_ticket_sales_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
        
    function get_customer_event_tickets
    (
        p_customer_id in number,
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_customer_event_tickets_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end

    function get_customer_event_series_tickets
    (
        p_customer_id in number,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    function get_customer_event_series_tickets_by_email
    (
        p_customer_email in customers.customer_email%type,
        p_event_series_id in number,
        p_formatted in boolean default false
    ) return $if dbms_db_version.version >= 21 $then json; $else clob; $end
    
    /*
    {
        "action" : "ticket_reissue",
        "customer_id" : 123,
        "customer_email" : "customer@customer.com",
        "ticket" : 
            {
                "serial_code" : "xyz", 
                "**status_code" : "SUCCESS|ERROR", 
                "**status_message" : "REISSUED|error message"
            }
    }
    */
    procedure ticket_reissue
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );
    
    /*
    {
        "action" : "ticket_reissue_batch",
        "customer_id" : 123,
        "customer_email" : "customer@customer.com",
        "tickets" : 
            [ 
                {
                    "serial_code" : "xyz", 
                    "**status_code" : "SUCCESS|ERROR", 
                    "**status_message" : "REISSUED|error message"
                },
                {
                    "serial_code" : "abc", 
                    "**status_code" : "SUCCESS|ERROR", 
                    "**status_message" : "REISSUED|error message"
                }
            ]
        "request_status" : "SUCCESS|ERRORS",
        "request_errors" : 999
    }
    */
    procedure ticket_reissue_batch
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    
    /*
    {
        "action" : "ticket-validate",
        "event_id" : 123,
        "serial_code" : "abc",
        "**status_code" : "SUCCESS|ERROR",
        "**status_message" : "VALIDATED|error message"
    }    

    */

    procedure ticket_validate
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );
    
    /*
    {
        "action" : "ticket-verify-validation",
        "event_id" : 123,
        "serial_code" : "abc",
        "**status_code" : "SUCCESS|ERROR",
        "**status_message" : "VERIFIED|error message"
    }        
    */
    procedure ticket_verify_validation
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );
    
    /*
    {
        "action" : "ticket-verify-restricted-access",
        "*event_id" : 123,  optional, implied by ticket group id
        "ticket_group_id" : 456,
        "price_category" : "VIP",
        "serial_code" : "abc",
        "**status_code" : "SUCCESS|ERROR",
        "**status_message" : "ACCESS VERIFIED|error message"        
    }        
    */
    procedure ticket_verify_restricted_access
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );
    
    /*
    {
        "action" : "ticket-cancel",
        "event_id" : 123,
        "serial_code" : "abc",
        "**status_code" : "SUCCESS|ERROR",
        "**status_message" : "CANCELLED|error message"        
    }    
    */    
    procedure ticket_cancel
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );

    /*
    {
        "action" : "ticket_assign_holder",
        "customer_id" : 123,
        "customer_email" : "customer@customer.com",
        "ticket" : 
            {
                "serial_code" : "xyz", 
                "issued_to_name" : "Albert Einstein",
                "issued_to_id" : "MA123456789",
                "**status_code" : "SUCCESS|ERROR", 
                "**status_message" : "REISSUED|error message"
            }
    }
    */
    procedure ticket_assign_holder
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end
    );
    
    /*
    {
        "action" : "ticket_assign_holder_batch",
        "customer_id" : 123,
        "customer_email" : "customer@customer.com",
        "tickets" : 
            [ 
                {
                    "serial_code" : "xyz", 
                    "issued_to_name" : "Albert Einstein",
                    "issued_to_id" : "MA123456789",
                    "**status_code" : "SUCCESS|ERROR", 
                    "**status_message" : "REISSUED|error message"
                },
                {
                    "serial_code" : "abc", 
                    "issued_to_name" : "Nicola Tesla",
                    "issued_to_id" : "NY987654321",
                    "**status_code" : "SUCCESS|ERROR", 
                    "**status_message" : "REISSUED|error message"
                }
            ]
        "request_status" : "SUCCESS|ERRORS",
        "request_errors" : 999
    }
    */
    procedure ticket_assign_holder_batch
    (
        p_json_doc in out nocopy $if dbms_db_version.version >= 21 $then json $else clob $end 
    );

end events_json_api;