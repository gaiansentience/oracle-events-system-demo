create or replace package events_json_api
authid definer
as

function format_json_clob(p_json_doc in clob) return clob;

function format_json_string(p_json_doc in varchar2) return varchar2;

function get_all_resellers
(
   p_formatted in boolean default false
) return clob;

function get_reseller
(
   p_reseller_id in number,
   p_formatted in boolean default false   
) return varchar2;


procedure create_reseller
(
   p_json_doc in out varchar2
);

function get_all_venues
(
   p_formatted in boolean default false
) return clob;

function get_venue
(
   p_venue_id in number,
   p_formatted in boolean default false   
) return varchar2;

procedure create_venue
(
   p_json_doc in out varchar2
);

function get_venue_events
(
   p_venue_id in number,
   p_formatted in boolean default false   
) return clob;

procedure create_event
(
   p_json_doc in out varchar2
);

--todo:  create recurring weekly event
procedure create_event_weekly
(
   p_json_doc in out varchar2
);

function get_event
(
   p_event_id in number,
   p_formatted in boolean default false   
) return varchar2;


procedure create_customer
(
   p_json_doc in out varchar2
);

--return ticket groups for event as json document
function get_event_ticket_groups
(
   p_event_id in number,
   p_formatted in boolean default false
) return varchar2;

--update ticket groups using a json document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
procedure update_event_ticket_groups
(
   p_json_doc in out varchar2
);

--return possible reseller ticket assignments for event as json document
--returns array of all resellers with ticket groups as nested array
function get_event_reseller_ticket_assignments
(
   p_event_id in number,
   p_formatted in boolean default false
) return clob;

--update ticket assignments for a reseller using a json document in the same format as get_event_reseller_ticket_assignments
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
--supports assignment of multiple ticket groups to multiple resellers
--WARNING:  IF MULTIPLE RESELLERS ARE SUBMITTED ASSIGNMENTS CAN EXCEED LIMITS CREATING MULTIPLE ERRORS AT THE END OF BATCH
--IT IS RECOMMENDED TO SUBMIT ASSIGNMENTS FOR ONE RESELLER AT A TIME AND REFRESH THE ASSIGNMENTS DOCUMENT TO SEE CHANGED LIMITS
--additional informational fields from get_event_reseller_ticket_assignments may be present
--if additional informational fields are present they will not be processed
procedure update_event_ticket_assignments
(
   p_json_doc in out nocopy clob
);

--todo:  get_event_tickets_available_all
--todo:  get_event_tickets_available_reseller
--todo:  get_event_tickets_available_venue

--todo:  purchase_tickets_from_reseller

--todo:  purchase_tickets_from_venue


--get customer tickets purchased for event
--used to verify customer purchases
function get_customer_event_tickets
(
   p_customer_id in number,
   p_event_id in number,
   p_formatted in boolean default false
) return varchar2;

function get_customer_event_tickets_by_email
(
   p_customer_email in customers.customer_email%type,
   p_event_id in number,
   p_formatted in boolean default false
) return varchar2;


end events_json_api;
