create or replace package body events_json_api
as

function format_json_clob(p_json_doc in clob) return clob
is
   v_json_formatted clob;
begin

  select json_serialize(p_json_doc pretty) 
  into v_json_formatted 
  from dual;

  return v_json_formatted;

end format_json_clob;

function format_json_string(p_json_doc in varchar2) return varchar2
is
   v_json_formatted varchar2(32000);
begin

  select json_serialize(p_json_doc pretty) 
  into v_json_formatted 
  from dual;

  return v_json_formatted;

end format_json_string;

function get_json_error_doc
(
   p_error_code in number,
   p_error_message in varchar2,
   p_json_method in varchar2
) return varchar2
is
   v_error_o json_object_t := new json_object_t;
   v_json_error varchar2(4000);
begin

   v_error_o.put('json_method', p_json_method);
   v_error_o.put('error_code', p_error_code);
   v_error_o.put('error_message', p_error_message);
   v_json_error := v_error_o.to_string();
   
   return format_json_string(v_json_error);
   
end get_json_error_doc;


function get_all_resellers
(
   p_formatted in boolean default false
) return clob
is
   v_json_doc clob;
begin

   select 
   b.json_doc
   into v_json_doc
   from all_resellers_json_v b;

   if p_formatted then
      v_json_doc := format_json_clob(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_all_resellers');
end get_all_resellers;


function get_reseller
(
   p_reseller_id in number,
   p_formatted in boolean default false   
) return varchar2
is
   v_json_doc varchar2(4000);
begin

   select 
   b.json_doc
   into v_json_doc
   from resellers_json_v b
   where b.reseller_id = p_reseller_id;

   if p_formatted then
      v_json_doc := format_json_string(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_reseller');
end get_reseller;


procedure create_reseller
(
   p_json_doc in out varchar2
)
is
   v_reseller_id number := 0;
   v_reseller_name resellers.reseller_name%type;
   v_reseller_email resellers.reseller_email%type;
   v_commission_percent resellers.commission_percent%type;
   
   v_request_o json_object_t;
   v_status_code varchar2(10);
   v_status_message varchar2(4000);
begin

   v_request_o := json_object_t.parse(p_json_doc);
   v_reseller_name := v_request_o.get_string('reseller_name');
   v_reseller_email := v_request_o.get_string('reseller_email');
   v_commission_percent := v_request_o.get_number('commission_percent');

      case
      when v_reseller_name is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing reseller name, cannot create reseller';
      when v_reseller_email is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing reseller email, cannot create reseller';
      when v_commission_percent is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing reseller commission, cannot create reseller';      
      else
         begin         
            events_api.create_reseller(v_reseller_name, v_reseller_email, v_commission_percent, v_reseller_id);
            v_status_code := 'SUCCESS';
            v_status_message := 'Created reseller';
         exception
            when others then
               v_status_code := 'ERROR';
               v_status_message := sqlerrm;
         end;
      end case;

   v_request_o.put('reseller_id', v_reseller_id);
   v_request_o.put('status_code',v_status_code);
   v_request_o.put('status_message', v_status_message);

   p_json_doc := v_request_o.to_string; 

exception
   when others then
      p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_reseller');
end create_reseller;

function get_all_venues
(
   p_formatted in boolean default false
) return clob
is
   v_json_doc clob;
begin

   select 
   b.json_doc
   into v_json_doc
   from all_venues_json_v b;

   if p_formatted then
      v_json_doc := format_json_clob(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_all_venues');
end get_all_venues;

function get_venue
(
   p_venue_id in number,
   p_formatted in boolean default false   
) return varchar2
is
   v_json_doc varchar2(4000);
begin

   select 
   b.json_doc
   into v_json_doc
   from venues_json_v b
   where b.venue_id = p_venue_id;

   if p_formatted then
      v_json_doc := format_json_string(v_json_doc);
   end if;
   return v_json_doc;
   
exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_venue');
end get_venue;

procedure create_venue
(
   p_json_doc in out varchar2
)
is
   v_venue_id number := 0;
   v_venue_name venues.venue_name%type;
   v_organizer_name venues.organizer_name%type;   
   v_organizer_email venues.organizer_email%type;
   v_max_event_capacity venues.max_event_capacity%type;
   
   v_commission_percent number;
   
   v_request_o json_object_t;
   v_status_code varchar2(10);
   v_status_message varchar2(4000);
begin

   v_request_o := json_object_t.parse(p_json_doc);
   v_venue_name := v_request_o.get_string('venue_name');   
   v_organizer_name := v_request_o.get_string('organizer_name');
   v_organizer_email := v_request_o.get_string('organizer_email');
   v_max_event_capacity := v_request_o.get_number('max_event_capacity');

      case
      when v_venue_name is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing venue name, cannot create venue';
      when v_organizer_name is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing organizer name, cannot create venue';         
      when v_organizer_email is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing organizer email, cannot create venue';
      when v_max_event_capacity is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing event capacity, cannot create venue';      
      else
         begin         
            events_api.create_venue(v_venue_name, v_organizer_name, v_organizer_email, v_max_event_capacity, v_venue_id);
            v_status_code := 'SUCCESS';
            v_status_message := 'Created venue';
         exception
            when others then
               v_status_code := 'ERROR';
               v_status_message := sqlerrm;
         end;
      end case;

   v_request_o.put('venue_id', v_venue_id);
   v_request_o.put('status_code',v_status_code);
   v_request_o.put('status_message', v_status_message);

   p_json_doc := v_request_o.to_string; 


exception
   when others then
      p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_venue');
end create_venue;

function get_venue_events
(
   p_venue_id in number,
   p_formatted in boolean default false   
) return clob
is
   v_json_doc clob;
begin

   select 
   b.json_doc
   into v_json_doc
   from venue_events_json_v b
   where b.venue_id = p_venue_id;

   if p_formatted then
      v_json_doc := format_json_clob(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_venue_events');
end get_venue_events;

procedure create_event
(
   p_json_doc in out varchar2
)
is
   v_event_id number := 0;
   v_venue_id events.venue_id%type;
   v_event_name events.event_name%type;
   v_event_date events.event_date%type;   
   v_event_capacity events.tickets_available%type;
   
   v_request_o json_object_t;
   v_status_code varchar2(10);
   v_status_message varchar2(4000);
begin

   v_request_o := json_object_t.parse(p_json_doc);

   v_venue_id := v_request_o.get_string('venue_id');   
   v_event_name := v_request_o.get_string('event_name');
   v_event_date := v_request_o.get_date('event_date');
   v_event_capacity := v_request_o.get_number('event_capacity');

      case
      when v_venue_id is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing venue, cannot create event';
      when v_event_name is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing event name, cannot create event';         
      when v_event_date is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing event date, cannot create event';
      when v_event_capacity is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing event capacity, cannot create event';      
      else
         begin                  
            events_api.create_event(v_venue_id, v_event_name, v_event_date, v_event_capacity, v_event_id);
            v_status_code := 'SUCCESS';
            v_status_message := 'Created event';
         exception
            when others then
               v_status_code := 'ERROR';
               v_status_message := sqlerrm;
         end;
      end case;

   v_request_o.put('event_id', v_event_id);
   v_request_o.put('status_code',v_status_code);
   v_request_o.put('status_message', v_status_message);

   p_json_doc := v_request_o.to_string; 

exception
   when others then
      p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_event');
end create_event;

--todo:  create recurring weekly event
procedure create_event_weekly
(
   p_json_doc in out varchar2
)
is
begin

null;
raise_application_error(-20100,'method not available in this release');

/*
procedure create_weekly_event
(
   p_venue_id in number,   
   p_event_name in varchar2,
   p_event_start_date in date,
   p_event_end_date in date,
   p_event_day in varchar2,
   p_tickets_available in number,
   p_status out varchar2
);
*/

exception
   when others then
      p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_event_weekly');
end create_event_weekly;

function get_event
(
   p_event_id in number,
   p_formatted in boolean default false   
) return varchar2
is
   v_json_doc varchar2(4000);
begin

   select 
   b.json_doc
   into v_json_doc
   from events_json_v b
   where b.event_id = p_event_id;

   if p_formatted then
      v_json_doc := format_json_string(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_event');
end get_event;

procedure create_customer
(
   p_json_doc in out varchar2
)
is
   v_customer_id number := 0;
   v_customer_name customers.customer_name%type;
   v_customer_email customers.customer_email%type;   
   
   v_request_o json_object_t;
   v_status_code varchar2(10);
   v_status_message varchar2(4000);
begin

   v_request_o := json_object_t.parse(p_json_doc);

   v_customer_name := v_request_o.get_string('customer_name');
   v_customer_email := v_request_o.get_string('customer_email');

      case
      when v_customer_name is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing name, cannot create customer';
      when v_customer_email is null then
         v_status_code := 'ERROR';
         v_status_message := 'Missing email, cannot create customer';         
      else
         begin                  
            events_api.create_customer(v_customer_name, v_customer_email, v_customer_id);
            v_status_code := 'SUCCESS';
            v_status_message := 'Created customer';
         exception
            when others then
               v_status_code := 'ERROR';
               v_status_message := sqlerrm;
         end;
      end case;

   v_request_o.put('customer_id', v_customer_id);
   v_request_o.put('status_code',v_status_code);
   v_request_o.put('status_message', v_status_message);

   p_json_doc := v_request_o.to_string; 

exception
   when others then
      p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'create_customer');
end create_customer;

--return ticket groups for event as json document
function get_ticket_groups
(
   p_event_id in number,
   p_formatted in boolean default false   
) return varchar2
is
   v_json_doc varchar2(32000);
begin

   select 
   b.json_doc
   into v_json_doc
   from event_ticket_groups_json_v b
   where b.event_id = p_event_id;

   if p_formatted then
      v_json_doc := format_json_string(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_groups');
end get_ticket_groups;

--update ticket groups using a json document in the same format as get_event_ticket_groups
--do not create/update group for UNDEFINED price category
--do not create/update group if price category is missing
--update request document for each ticket group with status_code of SUCCESS or ERROR and a status_message
--update entire request with a request_status of SUCCESS or ERRORS and request_errors (0 or N)
procedure update_ticket_groups
(
   p_json_doc in out varchar2
)
is
   v_event_id number;
   v_ticket_group_id number;
   
   v_request_o json_object_t;
   v_groups_array json_array_t;
   v_group_o json_object_t;
   v_price_category varchar2(50);
   v_price number;
   v_tickets_available number;
   v_error_count number := 0;
   v_status_code varchar2(10);
   v_status_message varchar2(4000);
begin

   v_request_o := json_object_t.parse(p_json_doc);
   v_event_id := v_request_o.get_number('event_id');
   v_groups_array := v_request_o.get_array('ticket_groups');
   for i in 0..v_groups_array.get_size - 1 loop
      v_group_o := json_object_t(v_groups_array.get(i));
      v_price_category := v_group_o.get_string('price_category');
      v_price := v_group_o.get_number('price');
      v_tickets_available := v_group_o.get_number('tickets_available');
      v_ticket_group_id := 0;
      case
      when v_price_category is null then
         v_error_count := v_error_count + 1;
         v_status_code := 'ERROR';
         v_status_message := 'Missing price category, cannot set group';
      when v_price_category = 'UNDEFINED' then
         v_error_count := v_error_count + 1;
         v_status_code := 'ERROR';
         v_status_message := 'Price category is UNDEFINED, cannot set group';
      else
         begin
            events_api.create_ticket_group(v_event_id, v_price_category, v_price, v_tickets_available, v_ticket_group_id);
            v_status_code := 'SUCCESS';
            v_status_message := 'Created/updated ticket group';
         exception
            when others then
               v_error_count := v_error_count + 1;
               v_status_code := 'ERROR';
               v_status_message := sqlerrm;
         end;
      end case;
      --update the array element with results (updates request object by reference)
      v_group_o.put('ticket_group_id', v_ticket_group_id);
      v_group_o.put('status_code', v_status_code);
      v_group_o.put('status_message', v_status_message);
   end loop;
   --add status information for all groups in the request
   v_request_o.put('request_status',case when v_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
   v_request_o.put('request_errors', v_error_count);

   p_json_doc := v_request_o.to_string; 
   
exception
   when others then
      p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_ticket_groups');
end update_ticket_groups;

--return possible reseller ticket assignments for event as json document
--returns array of all resellers with ticket groups as nested array
function get_ticket_assignments
(
   p_event_id in number,
   p_formatted in boolean default false   
) return clob
is
   v_json_doc clob;
begin

   select 
   b.json_doc
   into v_json_doc
   from reseller_ticket_assignment_json_v b
   where b.event_id = p_event_id;

   if p_formatted then
      v_json_doc := format_json_clob(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_ticket_assignments');
end get_ticket_assignments;

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
   p_json_doc in out nocopy clob
)
is
   v_event_id number;
   v_reseller_id number;
   v_ticket_group_id number;
   v_tickets_assigned number;
   v_ticket_assignment_id number;
   
   v_request_o json_object_t;
   v_resellers_array json_array_t;
   v_reseller_o json_object_t;
   v_groups_array json_array_t;
   v_group_o json_object_t;

   v_reseller_error_count number := 0;
   v_error_count number := 0;
   v_status_code varchar2(10);
   v_status_message varchar2(4000);
begin

   v_request_o := json_object_t.parse(p_json_doc);
   v_event_id := v_request_o.get_number('event_id');
   
   v_resellers_array := v_request_o.get_array('ticket_resellers');
   for r in 0..v_resellers_array.get_size - 1 loop
     v_reseller_o := json_object_t(v_resellers_array.get(r));

     v_reseller_error_count := 0;
     v_reseller_id := v_reseller_o.get_number('reseller_id');
     
     v_groups_array := v_reseller_o.get_array('ticket_assignments');
     for g in 0..v_groups_array.get_size - 1 loop
        v_group_o := json_object_t(v_groups_array.get(g));
        
        v_ticket_group_id := v_group_o.get_number('ticket_group_id');
        v_tickets_assigned := v_group_o.get_number('tickets_assigned');
        v_ticket_assignment_id := 0;
        
        --TODO: add validations here for ticket_group_id
        
        begin
        
            events_api.create_ticket_assignment(
                p_reseller_id => v_reseller_id,
                p_ticket_group_id => v_ticket_group_id,
                p_number_tickets => v_tickets_assigned,
                p_ticket_assignment_id => v_ticket_assignment_id);

            --update the reseller assignment for the ticket group
            v_status_code := 'SUCCESS';
            v_status_message := 'created/updated ticket group assignment';
        
        exception
           when others then
              v_status_code := 'ERROR';
              v_reseller_error_count := v_reseller_error_count + 1;
              v_status_message := sqlerrm;
        end;
        
        --update the assignment array element with results (updates request object by reference)
        v_group_o.put('ticket_assignment_id', v_ticket_assignment_id);
        v_group_o.put('status_code', v_status_code);
        v_group_o.put('status_message', v_status_message);
     end loop;
     --update the reseller array element
     v_reseller_o.put('reseller_status',case when v_reseller_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
     v_reseller_o.put('reseller_errors',v_reseller_error_count);
     v_error_count := v_error_count + v_reseller_error_count;
   end loop;
   
   --add status information for all resellers in the request
   v_request_o.put('request_status',case when v_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
   v_request_o.put('request_errors', v_error_count);

   p_json_doc := v_request_o.to_clob; 

exception
   when others then
      p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'update_ticket_assignments');
end update_ticket_assignments;

--get pricing and availability for tickets created for the event
function get_event_ticket_prices
(
    p_event_id in number,
    p_formatted in boolean default false
) return varchar2
is
    v_json_doc varchar2(4000);
begin
    
    select
    b.json_doc
    into v_json_doc
    from event_ticket_prices_json_v b
    where b.event_id = p_event_id;

    if p_formatted then
        v_json_doc := format_json_string(v_json_doc);
    end if;
    return v_json_doc;
exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_event_ticket_prices');
end get_event_ticket_prices;

function get_event_tickets_available_all
(
    p_event_id in number,
    p_formatted in boolean default false
) return clob
is
    v_json_doc clob;
begin

    select
    b.json_doc
    into v_json_doc
    from tickets_available_all_json_v b
    where b.event_id = p_event_id;

    if p_formatted then
        v_json_doc := format_json_clob(v_json_doc);
    end if;
    return v_json_doc;
exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_all');
end get_event_tickets_available_all;

function get_event_tickets_available_venue
(
    p_event_id in number,
    p_formatted in boolean default false
) return clob
is
    v_json_doc clob;
begin

    select
    b.json_doc
    into v_json_doc
    from tickets_available_venue_json_v b
    where b.event_id = p_event_id;

    if p_formatted then
        v_json_doc := format_json_clob(v_json_doc);
    end if;
    return v_json_doc;
exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_venue');
end get_event_tickets_available_venue;

function get_event_tickets_available_reseller
(
    p_event_id in number,
    p_reseller_id in number,
    p_formatted in boolean default false
) return clob
is
    v_json_doc clob;
begin

    select
    b.json_doc
    into v_json_doc
    from tickets_available_reseller_json_v b
    where 
        b.event_id = p_event_id
        and b.reseller_id = p_reseller_id;

    if p_formatted then
        v_json_doc := format_json_clob(v_json_doc);
    end if;
    return v_json_doc;
exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_event_tickets_available_reseller');
end get_event_tickets_available_reseller;


    procedure purchase_tickets_get_customer
    (
        o_request in out nocopy json_object_t, 
        p_customer_id out number
    )
    is
        v_customer_email customers.customer_email%type;
        v_customer_name customers.customer_name%type;
    begin
        v_customer_email := o_request.get_string('customer_email');
        v_customer_name := o_request.get_string('customer_name');
        --validate customer by email, set v_customer_id if found, else create    
        events_api.create_customer(
                p_customer_name => v_customer_name,
                p_customer_email => v_customer_email,
                p_customer_id => p_customer_id);
   
        o_request.put('customer_id', p_customer_id);
    end purchase_tickets_get_customer;

    procedure purchase_tickets_get_group_request(
            o_group in out nocopy json_object_t,
            p_group_id out number,
            p_quantity out number,
            p_price out number,
            p_tickets_requested_all_groups in out number
    )
    is
        v_price_category ticket_groups.price_category%type;
    begin
        
        p_group_id := o_group.get_number('ticket_group_id');
        p_quantity := o_group.get_number('ticket_quantity_requested');
        p_price := o_group.get_number('price');
        
        v_price_category := events_api.get_ticket_group_category(p_group_id);    
        o_group.put('price_category', v_price_category);
        
        p_tickets_requested_all_groups := p_tickets_requested_all_groups + p_quantity;

    end purchase_tickets_get_group_request;


    procedure purchase_tickets_verify_requested_price
    (
        p_group_id in number,
        p_requested_price in number,
        p_actual_price out number
    )
    is
    begin
        --verify ticket price
        p_actual_price := events_api.get_current_ticket_price(p_ticket_group_id => p_group_id);
        if p_actual_price > p_requested_price then
            raise_application_error(-20100, 'INVALID TICKET PRICE: CANCELLING TRANSACTION.  Price requested is ' 
                                        || p_requested_price || ', current price is ' || p_actual_price);
        end if;
            
    end purchase_tickets_verify_requested_price;

    procedure purchase_tickets_set_group_values_success
    (
        p_qty_requested in number,
        p_price in number,
        p_qty_purchased out number,
        p_sales_date out date,
        p_extended_price out number,
        p_qty_purchased_all_groups in out number,
        p_total_purchase_amount in out number,
        p_status_code out varchar2,
        p_status_message out varchar2
    )
    is
    begin
        
        p_status_code := 'SUCCESS';
        p_status_message := 'group tickets purchased';
        p_qty_purchased := p_qty_requested;
        p_sales_date := sysdate;
        p_extended_price := p_qty_purchased * p_price;
        p_qty_purchased_all_groups := p_qty_purchased_all_groups + p_qty_purchased;
        p_total_purchase_amount := p_total_purchase_amount + p_extended_price;

    end purchase_tickets_set_group_values_success;

    procedure purchase_tickets_set_group_values_error(
        p_sqlerrm in varchar2,
        p_status_code out varchar2,
        p_status_message in out varchar2,
        p_error_count in out number,
        p_qty_purchased out number,
        p_extended_price out number,
        p_sales_date out date,
        p_sales_id out number)
    is
    begin
        p_status_code := 'ERROR';
        p_status_message := p_sqlerrm;              
        p_error_count := p_error_count + 1;
        p_qty_purchased := 0;
        p_extended_price := 0;
        p_sales_date := null;
        p_sales_id := 0;
    end purchase_tickets_set_group_values_error;

    procedure purchase_tickets_update_group_object
    (
        o_group in out nocopy json_object_t,
        p_sales_id in number,
        p_sales_date in date,
        p_tickets_purchased in number,
        p_actual_price in number,
        p_extended_price in number,
        p_status_code in varchar2,
        p_status_message in varchar2
    )
    is
    begin
            
        --update the array element with results (updates request object by reference)
        o_group.put('ticket_sales_id', p_sales_id);
        o_group.put('sales_date', p_sales_date);
        o_group.put('ticket_quantity_purchased', p_tickets_purchased);
        o_group.put('actual_price', p_actual_price);
        o_group.put('extended_price', p_extended_price);
        o_group.put('status_code', p_status_code);
        o_group.put('status_message', p_status_message);
    end purchase_tickets_update_group_object;

    procedure purchase_tickets_update_request_object
    (
        o_request in out nocopy json_object_t,
        p_error_count in number,
        p_qty_requested_all_groups in number,
        p_qty_purchased_all_groups in number,
        p_total_purchase_amount in number
    )
    is
    begin
        --add status information for all ticket purchases in the request
        o_request.put('request_status',case when p_error_count = 0 then 'SUCCESS' else 'ERRORS' end);
        o_request.put('request_errors', p_error_count);
        o_request.put('total_tickets_requested', p_qty_requested_all_groups);
        o_request.put('total_tickets_purchased', p_qty_purchased_all_groups);
        o_request.put('total_purchase_amount', p_total_purchase_amount);
        o_request.put('purchase_disclaimer', 'All Ticket Sales Are Final.');
        
    end purchase_tickets_update_request_object;

    procedure purchase_tickets_from_reseller
    (
        p_json_doc in out nocopy clob
    )
    is
        v_event_id number;
        v_reseller_id number;
        v_customer_id number;
        v_total_tickets_requested number := 0;
        v_total_tickets_purchased number := 0;
        v_total_purchase_amount number := 0;
   
        v_ticket_group_id number;
        v_tickets_requested_in_group number;
        v_tickets_purchased_in_group number;
        v_ticket_price_requested number;
        v_actual_ticket_price number;
        v_extended_price_in_group number;
        v_ticket_sales_id number;
        v_sales_date date;
      
        v_request_o json_object_t;
        v_groups_array json_array_t;
        v_group_o json_object_t;

        v_group_status_code varchar2(10);
        v_group_status_message varchar2(4000);
        v_total_error_count number := 0;
        v_status_code varchar2(10);
        v_status_message varchar2(4000);
    begin

        v_request_o := json_object_t.parse(p_json_doc);
        v_event_id := v_request_o.get_number('event_id');
        v_reseller_id := v_request_o.get_number('reseller_id');
   
        purchase_tickets_get_customer(o_request => v_request_o, p_customer_id => v_customer_id);

        v_groups_array := v_request_o.get_array('ticket_groups');
        for group_index in 0..v_groups_array.get_size - 1 loop
        
            v_group_o := json_object_t(v_groups_array.get(group_index));

            purchase_tickets_get_group_request(
                            o_group => v_group_o, 
                            p_group_id => v_ticket_group_id, 
                            p_quantity => v_tickets_requested_in_group, 
                            p_price => v_ticket_price_requested,
                            p_tickets_requested_all_groups => v_total_tickets_requested);                            
        
            begin
            
                purchase_tickets_verify_requested_price(
                                p_group_id => v_ticket_group_id, 
                                p_requested_price => v_ticket_price_requested, 
                                p_actual_price => v_actual_ticket_price);
            
                --purchase the tickets, this sets v_ticket_sales_id
                --this will verify availability for the reseller and group
                --raises an exception if tickets are not available
                events_api.purchase_tickets_from_reseller(
                                p_reseller_id => v_reseller_id,
                                p_ticket_group_id => v_ticket_group_id,
                                p_customer_id => v_customer_id,
                                p_number_tickets => v_tickets_requested_in_group,
                                p_ticket_sales_id => v_ticket_sales_id);

                purchase_tickets_set_group_values_success(
                                p_qty_requested => v_tickets_requested_in_group,
                                p_price => v_actual_ticket_price,
                                p_qty_purchased => v_tickets_purchased_in_group,
                                p_sales_date => v_sales_date,
                                p_extended_price => v_extended_price_in_group,
                                p_qty_purchased_all_groups => v_total_tickets_purchased,
                                p_total_purchase_amount => v_total_purchase_amount,
                                p_status_code => v_group_status_code,
                                p_status_message => v_group_status_message);
            
            exception
                when others then
                    purchase_tickets_set_group_values_error(
                        p_sqlerrm => sqlerrm,
                        p_status_code => v_group_status_code,
                        p_status_message => v_group_status_message,
                        p_error_count => v_total_error_count,
                        p_qty_purchased => v_tickets_purchased_in_group,
                        p_extended_price => v_extended_price_in_group,
                        p_sales_date => v_sales_date,
                        p_sales_id => v_ticket_sales_id);
            end;
        
            purchase_tickets_update_group_object(
                                    o_group => v_group_o, 
                                    p_sales_id => v_ticket_sales_id, 
                                    p_sales_date => v_sales_date, 
                                    p_tickets_purchased => v_tickets_purchased_in_group,
                                    p_actual_price => v_actual_ticket_price,
                                    p_extended_price => v_extended_price_in_group,
                                    p_status_code => v_group_status_code,
                                    p_status_message => v_group_status_message);
        
        end loop;
        
        purchase_tickets_update_request_object(
                        o_request => v_request_o, 
                        p_error_count => v_total_error_count,
                        p_qty_requested_all_groups => v_total_tickets_requested,
                        p_qty_purchased_all_groups => v_total_tickets_purchased,
                        p_total_purchase_amount => v_total_purchase_amount);
    
        p_json_doc := v_request_o.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_from_reseller');
    end purchase_tickets_from_reseller;

    --see comments above purchase tickets from reseller for restrictions and error conditions
    procedure purchase_tickets_from_venue
    (
        p_json_doc in out nocopy clob
    )
    is
        v_event_id number;
        v_customer_id number;
        v_total_tickets_requested number := 0;
        v_total_tickets_purchased number := 0;
        v_total_purchase_amount number := 0;
   
        v_ticket_group_id number;
        v_tickets_requested_in_group number;
        v_tickets_purchased_in_group number;
        v_ticket_price_requested number;
        v_actual_ticket_price number;
        v_extended_price_in_group number;
        v_ticket_sales_id number;
        v_sales_date date;
      
        v_request_o json_object_t;
        v_groups_array json_array_t;
        v_group_o json_object_t;

        v_group_status_code varchar2(10);
        v_group_status_message varchar2(4000);
        v_total_error_count number := 0;
        v_status_code varchar2(10);
        v_status_message varchar2(4000);
    begin

        v_request_o := json_object_t.parse(p_json_doc);
        v_event_id := v_request_o.get_number('event_id');

        purchase_tickets_get_customer(o_request => v_request_o, p_customer_id => v_customer_id);

        v_groups_array := v_request_o.get_array('ticket_groups');
        for group_index in 0..v_groups_array.get_size - 1 loop        
            v_group_o := json_object_t(v_groups_array.get(group_index));
        
            purchase_tickets_get_group_request(
                            o_group => v_group_o, 
                            p_group_id => v_ticket_group_id, 
                            p_quantity => v_tickets_requested_in_group, 
                            p_price => v_ticket_price_requested,
                            p_tickets_requested_all_groups => v_total_tickets_requested);                            
        
            begin

                purchase_tickets_verify_requested_price(
                                p_group_id => v_ticket_group_id, 
                                p_requested_price => v_ticket_price_requested, 
                                p_actual_price => v_actual_ticket_price);
            
                --purchase the tickets, this sets v_ticket_sales_id
                --this will verify availability for the reseller and group
                --raises an exception if tickets are not available
                events_api.purchase_tickets_from_venue(
                                p_ticket_group_id => v_ticket_group_id,
                                p_customer_id => v_customer_id,
                                p_number_tickets => v_tickets_requested_in_group,
                                p_ticket_sales_id => v_ticket_sales_id);

                purchase_tickets_set_group_values_success(
                                p_qty_requested => v_tickets_requested_in_group,
                                p_price => v_actual_ticket_price,
                                p_qty_purchased => v_tickets_purchased_in_group,
                                p_sales_date => v_sales_date,
                                p_extended_price => v_extended_price_in_group,
                                p_qty_purchased_all_groups => v_total_tickets_purchased,
                                p_total_purchase_amount => v_total_purchase_amount,
                                p_status_code => v_group_status_code,
                                p_status_message => v_group_status_message);
            
            exception
                when others then
                    purchase_tickets_set_group_values_error(
                        p_sqlerrm => sqlerrm,
                        p_status_code => v_group_status_code,
                        p_status_message => v_group_status_message,
                        p_error_count => v_total_error_count,
                        p_qty_purchased => v_tickets_purchased_in_group,
                        p_extended_price => v_extended_price_in_group,
                        p_sales_date => v_sales_date,
                        p_sales_id => v_ticket_sales_id);
            end;
            
            purchase_tickets_update_group_object(
                                    o_group => v_group_o, 
                                    p_sales_id => v_ticket_sales_id, 
                                    p_sales_date => v_sales_date, 
                                    p_tickets_purchased => v_tickets_purchased_in_group,
                                    p_actual_price => v_actual_ticket_price,
                                    p_extended_price => v_extended_price_in_group,
                                    p_status_code => v_group_status_code,
                                    p_status_message => v_group_status_message);
                    
        end loop;
   
        purchase_tickets_update_request_object(
                        o_request => v_request_o, 
                        p_error_count => v_total_error_count,
                        p_qty_requested_all_groups => v_total_tickets_requested,
                        p_qty_purchased_all_groups => v_total_tickets_purchased,
                        p_total_purchase_amount => v_total_purchase_amount);

        p_json_doc := v_request_o.to_clob; 

    exception
        when others then
            p_json_doc := get_json_error_doc(sqlcode, sqlerrm, 'purchase_tickets_from_venue');
    end purchase_tickets_from_venue;


--get customer tickets purchased for event
--used to verify customer purchases
function get_customer_event_tickets
(
   p_customer_id in number,
   p_event_id in number,
   p_formatted in boolean default false
) return varchar2
is
   v_json_doc varchar2(4000);
begin

   select 
   b.json_doc
   into v_json_doc
   from customer_event_tickets_json_v b
   where b.event_id = p_event_id and b.customer_id = p_customer_id;

   if p_formatted then
      v_json_doc := format_json_string(v_json_doc);
   end if;
   return v_json_doc;

exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_event_tickets');
end get_customer_event_tickets;


--get customer tickets purchased for event
--use email to get customer_id
function get_customer_event_tickets_by_email
(
   p_customer_email in customers.customer_email%type,
   p_event_id in number,
   p_formatted in boolean default false
) return varchar2
is
   v_customer_id number;
   v_json_doc varchar2(4000);   
begin
   
   v_customer_id := events_api.get_customer_id(p_customer_email);
   
   select 
   b.json_doc
   into v_json_doc
   from customer_event_tickets_json_v b
   where b.event_id = p_event_id and b.customer_id = v_customer_id;

   if p_formatted then
      v_json_doc := format_json_string(v_json_doc);
   end if;
   return v_json_doc;
   
exception
   when others then
      return get_json_error_doc(sqlcode, sqlerrm, 'get_customer_event_tickets_by_email');
end get_customer_event_tickets_by_email;



begin
  null;
end events_json_api;