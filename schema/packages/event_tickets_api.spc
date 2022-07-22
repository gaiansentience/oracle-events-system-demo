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
    
    --expose for unit test scripts
    procedure update_ticket_status
    (
        p_serial_code in tickets.serial_code%type,
        p_status in tickets.status%type,
        p_use_commit in boolean default false        
    );
    
    procedure get_ticket_information
    (
        p_serial_code in tickets.serial_code%type,
        p_status out tickets.status%type,
        p_ticket_group_id out ticket_sales.ticket_group_id%type,
        p_customer_id out ticket_sales.customer_id%type,
        p_event_id out ticket_groups.event_id%type
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

    procedure get_ticket_holder_info
    (
        p_serial_code in tickets.serial_code%type,
        p_issued_to_name out tickets.issued_to_name%type,
        p_issued_to_id out tickets.issued_to_id%type
    );

end event_tickets_api;