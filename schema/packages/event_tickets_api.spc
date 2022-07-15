create or replace package event_tickets_api 
authid current_user
as

    c_ticket_status_issued constant varchar2(20)    := 'ISSUED';
    c_ticket_status_reissued constant varchar2(20)  := 'REISSUED';
    c_ticket_status_cancelled constant varchar2(20) := 'CANCELLED';
    c_ticket_status_validated constant varchar2(20) := 'VALIDATED';
    c_ticket_status_refunded constant varchar2(20)  := 'REFUNDED';
    
    procedure generate_serialized_tickets
    (
        p_sale in event_system.ticket_sales%rowtype
    );

    function get_ticket_status
    (
        p_serial_code in tickets.serial_code%type
    ) return varchar2;
      
    --use to replace customer lost tickets
    --update ticket status to REISSUED and add R to the serial code
    --raise error if customer is not the original purchaser
    --raise error if ticket status is REISSUED or VALIDATED
    procedure ticket_reissue
    (
        p_customer_id in number,
        p_serial_code in varchar2
    );
    
    procedure ticket_reissue_using_email
    (
        p_customer_email in varchar2,
        p_serial_code in varchar2
    );

    type r_ticket_reissue_request is record
        (
            customer_id customers.customer_id%type,
            customer_email customers.customer_email%type,
            serial_code tickets.serial_code%type, 
            status varchar2(20), 
            status_message varchar2(4000)
        );
    
    type t_ticket_reissues is table of r_ticket_reissue_request index by pls_integer;

    procedure ticket_reissue_batch
    (
        p_tickets in out t_ticket_reissues
    );

    procedure ticket_reissue_using_email_batch
    (
        p_tickets in out t_ticket_reissues
    );


    --validate that the ticket has been used for event entry
    --raise error if ticket was sold for a different event
    --raise error if ticket status is not ISSUED or REISSUED
    --raise error if ticket status is already VALIDATED or CANCELLED
    --set valid ticket status to VALIDATED
    procedure ticket_validate
    (
        p_event_id in number,
        p_serial_code in varchar2
    );
    
    --used to verify that the ticket was used to enter the event
    --raise error if ticket was sold for a different event
    --verify that the ticket status is VALIDATED
    --raise error for any other status
    procedure ticket_verify_validation
    (
        p_event_id in number,
        p_serial_code in varchar2
    );
    
    --used to enter restricted areas like RESERVED SEATING, VIP, etc
    --verify that the ticket serial number was purchased in the ticket group
    --and that the ticket has been validated for entry (status = VALIDATED)
    --raise error if ticket is not part of the ticket group or status is not validated
    --raise error if ticket was sold for a different event
    procedure ticket_verify_restricted_access
    (
        p_ticket_group_id in number,
        p_serial_code in varchar2
    );

    --set ticket status to cancelled
    --raise error if ticket was sold for a different event
    procedure ticket_cancel
    (
        p_event_id in number,    
        p_serial_code in varchar2
    );

end event_tickets_api;