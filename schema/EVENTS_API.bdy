create or replace package body events_api
as

g_user varchar2(30);
g_sid number;

procedure log_error
(
   p_error_message in varchar2,
   p_error_code in number,
   p_locale in varchar2
)
is
  pragma autonomous_transaction;
begin

   insert into event_system.error_log(
      db_user_name,
      db_session_id,
      error_locale,
      error_code,
      error_message,
      error_date)
   values(
      g_user,
      g_sid,
      p_locale,
      p_error_code,
      p_error_message,
      sysdate);
      
   commit;
   
exception
   when others then
      --do not raise errors from logging routine
      rollback;
end log_error;

procedure create_venue
(
   p_venue_name in varchar2,
   p_organizer_name in varchar2,
   p_organizer_email in varchar2,   
   p_max_event_capacity in number,
   p_venue_id out number
)
is
begin

  insert into event_system.venues(
      venue_name, 
      organizer_name, 
      organizer_email, 
      max_event_capacity)
  values(
      p_venue_name, 
      p_organizer_name, 
      p_organizer_email, 
      p_max_event_capacity)
  returning venue_id into p_venue_id;
  
  commit;
  
exception
  when others then
    log_error(sqlerrm, sqlcode,'create_venue');
    raise;
end create_venue;

procedure show_venues_summary
(
   p_venues out sys_refcursor
)
is
begin

   open p_venues for
   select 
   v.venue_id, 
   v.venue_name, 
   v.organizer_name,
   v.organizer_email,
   v.max_event_capacity, 
   count(e.event_id) as events_scheduled, 
   min(e.event_date) as first_event_date, 
   max(e.event_date) as last_event_date,
   min(e.tickets_available) min_event_tickets,
   max(e.tickets_available) max_event_tickets
   from event_system.venues v left outer join event_system.events e on v.venue_id = e.venue_id
   group by 
   v.venue_id, 
   v.venue_name, 
   v.organizer_name,
   v.organizer_email,
   v.max_event_capacity;   
   
end show_venues_summary;
   
procedure create_reseller
(
   p_reseller_name in varchar2,
   p_reseller_email in varchar2,
   p_commission_percent in number default 0.10,
   p_reseller_id out number
)
is
begin

  insert into event_system.resellers(
     reseller_name,
     reseller_email,
     commission_percent)
  values(
     p_reseller_name,
     p_reseller_email,
     p_commission_percent)
  returning reseller_id into p_reseller_id;
  
  commit;
  
exception
  when others then
    log_error(sqlerrm, sqlcode,'create_reseller');
    raise;
end create_reseller;


procedure show_resellers
(
   p_resellers out sys_refcursor
)
is
begin

  open p_resellers for
  select
  r.reseller_id,
  r.reseller_name,
  r.reseller_email,
  r.commission_percent
  from event_system.resellers r
  order by r.reseller_name;

end show_resellers;

function get_customer_id
(
   p_customer_email in varchar2
) return number
is
   v_customer_id number;
begin

   select customer_id
   into v_customer_id
   from event_system.customers c
   where upper(c.customer_email) = upper(p_customer_email);
   
   return v_customer_id;

exception
   when no_data_found then
      return 0;
   when others then
      log_error(sqlerrm, sqlcode, 'get_customer_id');
      raise;
end get_customer_id;

procedure create_customer
(
   p_customer_name in varchar2,
   p_customer_email in varchar2,
   p_customer_id out number
)
is
   v_customer_id number;
begin

   --check to see if the email is already registered to a customer
   v_customer_id := get_customer_id(p_customer_email);
   
   if v_customer_id = 0 then
   
      insert into event_system.customers(
         customer_name,
         customer_email)
      values(
         p_customer_name,
         p_customer_email)
      returning customer_id into v_customer_id;
  
      commit;
      
   end if;
   
   p_customer_id := v_customer_id;

exception
  when others then
    log_error(sqlerrm, sqlcode,'create_customer');
    raise;
end create_customer;
   
procedure verify_event_capacity
(
   p_venue_id in number,
   p_tickets in number
)
is
   v_capacity number;
begin

   select max_event_capacity
   into v_capacity
   from event_system.venues
   where venue_id = p_venue_id;

   if p_tickets > v_capacity then
     raise_application_error(-20100, p_tickets || ' exceeds venue capacity of ' || v_capacity);
   end if;
   
end verify_event_capacity;
  
procedure verify_event_date_free
(
   p_venue_id in number,
   p_event_date in date
)
is
   v_count number;
begin

   select count(*) into v_count
   from event_system.events e where e.venue_id = p_venue_id 
   and trunc(e.event_date) = trunc(p_event_date);
   
   if v_count > 0 then
      raise_application_error(-20100, 'Cannot schedule event.  Venue already has event for ' || to_char(p_event_date,'MM/DD/YYYY'));
   end if;

end verify_event_date_free;

procedure create_event
(
   p_venue_id in number,   
   p_event_name in varchar2,
   p_event_date in date,
   p_tickets_available in number,
   p_event_id out number
)
is
begin

  --check that the venue can handle the event
  verify_event_capacity(p_venue_id, p_tickets_available);
  --check that the event does not conflict with an existing event
  verify_event_date_free(p_venue_id, p_event_date);
  
  insert into event_system.events(
    venue_id,
    event_name,
    event_date,
    tickets_available)
  values(
    p_venue_id,
    p_event_name,
    p_event_date,
    p_tickets_available)
  returning event_id into p_event_id;
  
  commit;

exception
  when others then
    log_error(sqlerrm, sqlcode,'create_event');
    raise;
end create_event;

procedure create_weekly_event
(
   p_venue_id in number,   
   p_event_name in varchar2,
   p_event_start_date in date,
   p_event_end_date in date,
   p_event_day in varchar2,
   p_tickets_available in number,
   p_status out varchar2
)
is

cursor d is
with date_range as
(
select
(p_event_start_date) + level - 1 as the_date
from dual connect by level <= (p_event_end_date) - (p_event_start_date)
)
select
the_date
from date_range
where to_char(the_date,'fmDAY', 'NLS_DATE_LANGUAGE=American') = upper(p_event_day)
order by the_date;

v_event_id number;
v_success_count number := 0;
v_conflict_count number := 0;
v_conflict_dates varchar2(4000);
v_status varchar2(4000);
v_success_dates varchar2(4000);
begin

for r in d loop

   begin
     create_event(p_venue_id, p_event_name, r.the_date, p_tickets_available, v_event_id);
     v_success_count := v_success_count + 1;
     v_success_dates := v_success_dates || to_char(r.the_date,'MM/DD/YYYY') || ', ';
   exception
     when others then
       log_error(sqlerrm,sqlcode,'create_weekly_event:  adding weekly event');
       v_conflict_count := v_conflict_count + 1;
       v_conflict_dates := v_conflict_dates || to_char(r.the_date,'MM/DD/YYYY') || ', ';
   end;

end loop;

v_success_dates := rtrim(v_success_dates,', ');
v_conflict_dates := rtrim(v_conflict_dates,', ');

v_status := v_success_count || ' events for "' || p_event_name || '" created successfully. ';
v_status := v_status || v_conflict_count || ' events could not be created because of conflicts with existing events.';
--v_status := v_status || '  Conflicting dates are: ' || v_conflict_dates || '.';
p_status := v_status;

exception
  when others then
    log_error(sqlerrm, sqlcode,'create_weekly_event');
    raise;
end create_weekly_event;


--show all planned events for the venue
--include total ticket sales to date
procedure show_venue_upcoming_events
(
   p_venue_id in number,
   p_events out sys_refcursor
)
is
begin

  open p_events for
  select
  v.venue_id,
  v.venue_name,
  e.event_id,
  e.event_name,
  e.event_date,
  e.tickets_available,
  e.tickets_available -
  nvl(
     (select sum(ts.ticket_quantity) 
     from event_system.ticket_sales ts join event_system.ticket_groups tg 
     on ts.ticket_group_id = tg.ticket_group_id
     where tg.event_id = e.event_id)
  ,0) as tickets_remaining
  from
  event_system.venues v join event_system.events e on v.venue_id = e.venue_id
  where v.venue_id = p_venue_id and e.event_date > sysdate;

end show_venue_upcoming_events;


--show ticket sales and ticket quantity for each reseller
--rank resellers by total sales amount
procedure show_venue_reseller_performance
(
   p_venue_id in number,
   p_reseller_sales out sys_refcursor
)
is
begin

  open p_reseller_sales for
  with venue_sales as
  (
  select
  e.venue_id,
  ts.reseller_id,
  sum(ts.ticket_quantity) total_ticket_quantity,
  sum(ts.extended_price) total_ticket_sales  
  from
  event_system.events e join event_system.ticket_groups tg on e.event_id = tg.event_id
  join event_system.ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id 
  where e.venue_id = p_venue_id
  group by
  e.venue_id,
  ts.reseller_id
  )
  select
  r.reseller_id,
  r.reseller_name,
  nvl(vs.total_ticket_quantity,0) as total_ticket_quantity,
  nvl(vs.total_ticket_sales,0) as total_ticket_sales,
  dense_rank() over (order by nvl(vs.total_ticket_sales,0) desc) rank_by_sales,
  dense_rank() over (order by nvl(vs.total_ticket_sales,0) desc) rank_by_quantity
  from
  event_system.resellers r left outer join venue_sales vs on r.reseller_id = vs.reseller_id --and vs.venue_id = p_venue_id
  order by nvl(vs.total_ticket_sales,0) desc, r.reseller_name;

end show_venue_reseller_performance;



--show reseller commission report grouped by month and event
--?if date is specified show that month, otherwise show all months
--?if event is specified show that event only, otherwise show all events
procedure show_venue_reseller_commissions
(
   p_venue_id in number,
   p_reseller_id in number,
--?   p_month in date default null,
--?   p_event_id in number default null,
   p_commissions out sys_refcursor
)
is
begin

   open p_commissions for
   select
   r.reseller_id,
   r.reseller_name,
   trunc(ts.sales_date,'Month') as sales_month,
   trunc(ts.sales_date,'Month') + interval '1' month - interval '1' day sales_month_ending,
   e.event_id,
   e.event_name,
   sum(ts.extended_price) as total_sales,
   r.commission_percent,
   sum(ts.reseller_commission) as total_commission
   from
   event_system.venues v join event_system.events e on v.venue_id = e.venue_id
   join event_system.ticket_groups tg on e.event_id = tg.event_id
   join event_system.ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
   join event_system.resellers r on ts.reseller_id = p_reseller_id
   where
   v.venue_id = p_venue_id and r.reseller_id = p_reseller_id
   group by 
      r.reseller_id, 
      r.reseller_name, 
      r.commission_percent,
      trunc(ts.sales_date,'Month'), 
      e.event_id, 
      e.event_name;

end show_venue_reseller_commissions;


--show currently defined ticket groups for an event
--for each group include quantity and price
--also include an UNDEFINED group to show how many more tickets could be assigned to groups
--the quantity of the UNDEFINED group is event capacity - sum of all current groups
procedure show_ticket_groups
(
   p_event_id in number,
   p_ticket_groups out sys_refcursor
)
is
begin

   open p_ticket_groups for
   select
   e.event_id,
   e.event_name,
   tg.ticket_group_id,
   tg.price_category,
   tg.price,
   tg.tickets_available,
   nvl(
   (select sum(ta.tickets_assigned) from event_system.ticket_assignments ta where ta.ticket_group_id = tg.ticket_group_id)
   ,0) currently_assigned,
   nvl(
   (select sum(ts.ticket_quantity) from event_system.ticket_sales ts where ts.ticket_group_id = tg.ticket_group_id and ts.reseller_id is null)
   ,0) sold_by_venue
   from
   event_system.events e join event_system.ticket_groups tg on e.event_id = tg.event_id
   where e.event_id = p_event_id
   union all
   select
   e.event_id,
   e.event_name,
   0 as ticket_group_id,
   'UNDEFINED' as price_category,
   0 as price,
   e.tickets_available -
   nvl(
      (select sum(tg.tickets_available) 
      from event_system.ticket_groups tg 
      where tg.event_id = p_event_id)
   ,0) as tickets_available,
   0 as currently_assigned,
   0 as sold_by_venue
   from event_system.events e where e.event_id = p_event_id;

end show_ticket_groups;

procedure verify_ticket_group_availability
(
   p_event_id in number,
   p_price_category in varchar2,
   p_group_tickets in number
)
is
  v_event_tickets number;
  v_other_groups_tickets number;
  v_remaining_tickets number;
  v_reseller_assignments number;
  v_direct_venue_sales number;
  v_group_minimum number;
  v_message varchar2(1000);
begin

   select e.tickets_available
   into v_event_tickets
   from event_system.events e
   where e.event_id = p_event_id;
   
   select nvl(sum(tg.tickets_available),0)
   into v_other_groups_tickets
   from event_system.ticket_groups tg
   where tg.event_id = p_event_id
   and upper(tg.price_category) <> upper(p_price_category);
   
   select nvl(sum(ta.tickets_assigned),0) into v_reseller_assignments
   from event_system.ticket_groups tg join event_system.ticket_assignments ta
   on tg.ticket_group_id = ta.ticket_group_id
   where tg.event_id = p_event_id 
   and upper(tg.price_category) = upper(p_price_category);
   
   select nvl(sum(ts.ticket_quantity),0) into v_direct_venue_sales
   from event_system.ticket_groups tg join event_system.ticket_sales ts 
   on tg.ticket_group_id = ts.ticket_group_id
   where tg.event_id = p_event_id 
   and upper(tg.price_category) = upper(p_price_category) 
   and ts.reseller_id is null;
   
   v_remaining_tickets := v_event_tickets - v_other_groups_tickets;
   v_group_minimum := v_reseller_assignments + v_direct_venue_sales;

   if v_remaining_tickets < p_group_tickets then
      v_message := 'Cannot create ' || upper(p_price_category) || '  with ' || p_group_tickets || ' tickets.  Only ' || v_remaining_tickets || ' are available.';
      raise_application_error(-20100, v_message);
   elsif p_group_tickets < v_group_minimum then
      v_message := 'Cannot set ' || upper(p_price_category) || ' to ' || p_group_tickets || ' tickets.  Current reseller assignments and direct venue sales are ' || v_group_minimum;
      raise_application_error(-20100, v_message);
   end if;

end verify_ticket_group_availability;

function ticket_group_exists
(
   p_event_id in number,
   p_price_category in varchar2
) return boolean
is
   v_count number;
begin

  select count(*) into v_count
  from event_system.ticket_groups tg
  where tg.event_id = p_event_id
  and tg.price_category = upper(p_price_category);
  
  return (v_count > 0);

end ticket_group_exists;

--create a price category ticket group for the event
--if the group already exists, update the number of tickets available
--raise an error if ticket group would exceed event total tickets
procedure create_ticket_group
(
   p_event_id in number,
   p_price_category in varchar2 default 'General Admission',
   p_price in number,
   p_tickets in number,
   p_ticket_group_id out number
)
is
begin

   verify_ticket_group_availability(p_event_id, p_price_category, p_tickets);

   --TODO: Change this to use a merge statement   
   if not ticket_group_exists(p_event_id, p_price_category) then
   
      insert into event_system.ticket_groups(
         event_id,
         price_category,
         price,
         tickets_available)
      values(
         p_event_id,
         upper(p_price_category),
         p_price,
         p_tickets)
      returning ticket_group_id into p_ticket_group_id;

   else
   
      update event_system.ticket_groups
      set 
      price = p_price,
      tickets_available = p_tickets
      where
      event_id = p_event_id
      and price_category = upper(p_price_category)
      returning ticket_group_id into p_ticket_group_id;
      
   end if;

   commit;

exception
  when others then
    log_error(sqlerrm, sqlcode,'create_ticket_group');
    raise;
end create_ticket_group;


--show ticket groups and availability for this event and reseller
--     tickets_in_group    tickets in group, 
--     assigned_to_others  tickets assigned to other resellers, 
--     currently_assigned  tickets currently assigned to reseller, 
--     max_available       maximum tickets available for reseller (includes currently assigned)
procedure show_reseller_ticket_group_availability
(
   p_event_id in number,
   p_reseller_id in number,
   p_ticket_groups out sys_refcursor
)
is
begin

   open p_ticket_groups for
   with base as
   (
      select 
      e.event_id,
      tg.ticket_group_id,
      tg.price_category,
      tg.tickets_available as tickets_in_group,
      nvl(
         (
         select sum(ta.tickets_assigned) 
         from event_system.ticket_assignments ta
         where ta.ticket_group_id = tg.ticket_group_id 
         and ta.reseller_id <> p_reseller_id
         )
      ,0)as assigned_to_others,
      nvl(
         (
         select ta.tickets_assigned 
         from event_system.ticket_assignments ta
         where ta.ticket_group_id = tg.ticket_group_id 
         and ta.reseller_id = p_reseller_id
         )
      ,0) as assigned_to_reseller,      
      nvl(
         (
         select sum(ts.ticket_quantity)
         from event_system.ticket_sales ts
         where ts.ticket_group_id = tg.ticket_group_id
         and ts.reseller_id = p_reseller_id
         )
      ,0) as sold_by_reseller,
      nvl(
         (
         select sum(ts.ticket_quantity)
         from event_system.ticket_sales ts
         where ts.ticket_group_id = tg.ticket_group_id
         and ts.reseller_id is null
         )
      ,0) as sold_by_venue
      from
      event_system.events e join event_system.ticket_groups tg on e.event_id = tg.event_id
   where e.event_id = p_event_id
   )
   select
   b.event_id,
   b.ticket_group_id,
   b.price_category,
   b.tickets_in_group,
   r.reseller_id,
   r.reseller_name,   
   b.assigned_to_others,
   b.assigned_to_reseller as currently_assigned,
   b.tickets_in_group - (b.assigned_to_others + b.sold_by_venue) as max_available,
   b.sold_by_reseller as min_assignment,
   b.sold_by_reseller,
   b.sold_by_venue
   from base b cross join event_system.resellers r
   where r.reseller_id = p_reseller_id;


end show_reseller_ticket_group_availability;


procedure verify_ticket_group_assignment
(
   p_reseller_id in number,
   p_ticket_group_id in number,
   p_number_tickets in number
)
is
  v_total_group_tickets number;
  v_price_category ticket_groups.price_category%type;
  v_assigned_others number;
  v_venue_direct_sales number;
  v_reseller_sales number;
  v_available_tickets number;
  v_message varchar2(100);
begin

  select tg.tickets_available, tg.price_category
  into v_total_group_tickets, v_price_category
  from event_system.ticket_groups tg 
  where tg.ticket_group_id = p_ticket_group_id;
  
  select nvl(sum(ta.tickets_assigned),0) 
  into v_assigned_others
  from event_system.ticket_assignments ta 
  where ta.ticket_group_id = p_ticket_group_id 
  and ta.reseller_id <> p_reseller_id;

  select nvl(sum(ts.ticket_quantity),0) 
  into v_venue_direct_sales
  from event_system.ticket_sales ts 
  where ts.ticket_group_id = p_ticket_group_id 
  and ts.reseller_id is null;

  select nvl(sum(ts.ticket_quantity),0) 
  into v_reseller_sales
  from event_system.ticket_sales ts 
  where ts.ticket_group_id = p_ticket_group_id 
  and ts.reseller_id = p_reseller_id;
  
  v_available_tickets := v_total_group_tickets - (v_assigned_others + v_venue_direct_sales);  

  if v_available_tickets < p_number_tickets then
     v_message := 'Cannot assign ' || p_number_tickets || ' tickets for  ' || v_price_category || ' to reseller, maximum available are ' || v_available_tickets;
     raise_application_error(-20100, v_message);
  elsif v_reseller_sales > p_number_tickets then
     v_message := 'Cannot set ' || v_price_category || ' to ' || p_number_tickets || ' tickets for reseller, ' || v_reseller_sales || ' tickets already sold by reseller';
     raise_application_error(-20100, v_message);
  end if;

end verify_ticket_group_assignment;

function ticket_group_assignment_exists
(
   p_reseller_id in number,
   p_ticket_group_id in number
) return boolean
is
   v_count number;
begin

  select count(*) into v_count
  from
  event_system.ticket_assignments ta
  where ta.reseller_id = p_reseller_id
  and ta.ticket_group_id = p_ticket_group_id;
  
  return (v_count > 0);

end ticket_group_assignment_exists;


--assign a group of tickets in a price category to a reseller
--if the reseller already has that category assigned, update the number of tickets
--raise an error if the ticket group doesnt have that many tickets available
procedure assign_reseller_ticket_group
(
   p_reseller_id in number,
   p_ticket_group_id in number,
   p_number_tickets in number,
   p_ticket_assignment_id out number
)
is
begin

  verify_ticket_group_assignment(p_reseller_id, p_ticket_group_id, p_number_tickets);

  --TODO:  convert this to use merge statement
  if not ticket_group_assignment_exists(p_reseller_id, p_ticket_group_id) then
    
    insert into event_system.ticket_assignments
       (
          ticket_group_id, 
          reseller_id, 
          tickets_assigned
       )
    values 
       (
          p_ticket_group_id, 
          p_reseller_id, 
          p_number_tickets
       )
    returning ticket_assignment_id into p_ticket_assignment_id;
    
  else
  
    update event_system.ticket_assignments
    set tickets_assigned = p_number_tickets
    where ticket_group_id = p_ticket_group_id
    and reseller_id = p_reseller_id
    returning ticket_assignment_id into p_ticket_assignment_id;
  
  end if;
  
  commit;
  
exception
  when others then
    log_error(sqlerrm, sqlcode, 'assign_reseller_ticket_group');
    raise;
end assign_reseller_ticket_group;


--show all tickets available for event (reseller or venue direct)
--show each ticket group with availability by source (each reseller or venue)
--include tickets available in each group by source
--show [number] AVAILABLE or SOLD OUT as status for each group/source
--include ticket price for each group
--used by venue application to show overall ticket availability
   procedure show_all_event_tickets_available
   (
      p_event_id in number,
      p_ticket_groups out sys_refcursor
   )
   is
   begin

      open p_ticket_groups for
      select
         event_id,
         event_name,
         event_date,
         price_category,
         ticket_group_id,
         price,
         reseller_id,
         reseller_name,
         tickets_available,
         ticket_status
      from
         event_system.tickets_available_all_v
      where 
         event_id = p_event_id;

   end show_all_event_tickets_available;

--show ticket groups assigned to reseller for this event
--include tickets available in each group
--show [number] AVAILABLE or SOLD OUT as status for each group
--include ticket price for each group
--used by reseller application to show available ticket groups to customers
   procedure show_reseller_tickets_available
   (
      p_event_id in number,
      p_reseller_id in number,
      p_ticket_groups out sys_refcursor
   )
   is
   begin

      open p_ticket_groups for
      select
         event_id,
         event_name,
         event_date,
         price_category,
         ticket_group_id,
         price,
         reseller_id,
         reseller_name,
         tickets_available,
         ticket_status
      from
         event_system.tickets_available_reseller_v
      where 
         event_id = p_event_id
         and reseller_id = p_reseller_id;

   end show_reseller_tickets_available;


--show ticket groups not assigned to any reseller for this event
--include tickets available in each group
--show [number] AVAILABLE or SOLD OUT as status for each group
--include ticket price for each group
--used by venue organizer application to show tickets available for direct purchase to customers
   procedure show_venue_tickets_available
   (
      p_event_id in number,
      p_ticket_groups out sys_refcursor
   )
   is
   begin

      open p_ticket_groups for
      select
         event_id,
         event_name,
         event_date,
         price_category,
         ticket_group_id,
         price,
         reseller_id,
         reseller_name,
         tickets_available,
         ticket_status
      from
        event_system.tickets_available_venue_v
      where 
         event_id = p_event_id;

   end show_venue_tickets_available;

   function get_current_ticket_price
   (
      p_ticket_group_id in number
   ) return number
   is
      v_price number;
   begin

      select 
         tg.price into v_price
      from 
         event_system.ticket_groups tg
      where 
         tg.ticket_group_id = p_ticket_group_id;
   
      return v_price;
   
   end get_current_ticket_price;


procedure verify_tickets_available_reseller
(
   p_reseller_id in number,
   p_ticket_group_id in number,
   p_number_tickets in number
)
is
   v_available_reseller number;
   v_available_venue number;
   v_available_other_resellers number;
   v_price_category ticket_groups.price_category%type;
   v_message varchar2(1000);
begin

   with base as
   (
     select 
     tg.tickets_available,
     ta.tickets_assigned,
     nvl(
        (select sum(ta_others.tickets_assigned)
        from event_system.ticket_assignments ta_others
        where ta_others.ticket_group_id = tg.ticket_group_id
        and ta_others.reseller_id <> ta.reseller_id)
     ,0) as tickets_assigned_others,
     tg.price_category,
     nvl(
        (select sum(ts.ticket_quantity)
        from event_system.ticket_sales ts
        where ts.ticket_group_id = tg.ticket_group_id
        and ts.reseller_id = ta.reseller_id)
     ,0) as tickets_sold_by_reseller,
     nvl(
        (select sum(ts.ticket_quantity)
        from event_system.ticket_sales ts
        where ts.ticket_group_id = tg.ticket_group_id
        and ts.reseller_id is not null and ts.reseller_id <> ta.reseller_id)
     ,0) as tickets_sold_by_other_resellers,
     nvl(
        (select sum(ts.ticket_quantity)
        from event_system.ticket_sales ts
        where ts.ticket_group_id = tg.ticket_group_id
        and ts.reseller_id is null)
     ,0) as tickets_sold_by_venue
     from event_system.ticket_groups tg join event_system.ticket_assignments ta 
     on tg.ticket_group_id = ta.ticket_group_id
     where tg.ticket_group_id = p_ticket_group_id 
     and ta.reseller_id = p_reseller_id
   )
   select 
      base.price_category, 
      base.tickets_assigned - base.tickets_sold_by_reseller,
      base.tickets_assigned_others - base.tickets_sold_by_other_resellers,
      base.tickets_available - (base.tickets_assigned + base.tickets_assigned_others + base.tickets_sold_by_venue)
   into 
      v_price_category, 
      v_available_reseller,
      v_available_other_resellers,
      v_available_venue
   from base;

   if v_available_reseller < p_number_tickets then
      v_message := 'Cannot purchase ' || p_number_tickets || ' ' || v_price_category || ' tickets from reseller.  ';
      v_message := v_message || case when v_available_reseller > 0 then to_char(v_available_reseller) else 'No' end || ' tickets are available from reseller.  ';
      if (v_available_reseller + v_available_other_resellers + v_available_venue) = 0 then
         v_message := v_message || v_price_category || ' tickets are SOLD OUT.';
      else
         null;
         --open issue:  should reseller purchase error give availability from other resellers or venue?
        v_message := v_message || case when v_available_venue > 0 then to_char(v_available_venue) else 'No' end || ' tickets are available directly from venue.  ';
        v_message := v_message || case when v_available_other_resellers > 0 then to_char(v_available_other_resellers) else 'No' end || ' tickets are available through other resellers.';
      end if;
      raise_application_error(-20100,v_message);
   end if;

end verify_tickets_available_reseller;

function get_reseller_commission_percent
(
   p_reseller_id in number
) return number
is
   v_commission_pct number;
begin

   select r.commission_percent
   into v_commission_pct
   from event_system.resellers r
   where r.reseller_id = p_reseller_id;
   
   return v_commission_pct;
   
end get_reseller_commission_percent;

--record ticket purchased through reseller application
--raise error if ticket group quantity available is less than number of tickets requested
--return ticket sales id as sales confirmation number
procedure purchase_tickets_from_reseller
(
   p_reseller_id in number,
   p_ticket_group_id in number,
   p_customer_id in number,
   p_number_tickets in number,
   p_ticket_sales_id out number
)
is
   v_price number;
   v_extended_price number;
   v_commission_pct number;
   v_commission number;
begin

   verify_tickets_available_reseller(p_reseller_id, p_ticket_group_id, p_number_tickets);
   
   v_price := get_current_ticket_price(p_ticket_group_id);
   v_extended_price := v_price * p_number_tickets;
   v_commission_pct := get_reseller_commission_percent(p_reseller_id);
   v_commission := round(v_extended_price * v_commission_pct);
   
   insert into event_system.ticket_sales(
        ticket_group_id, 
        customer_id, 
        reseller_id, 
        ticket_quantity,
        extended_price,
        reseller_commission,
        sales_date)
    values (
        p_ticket_group_id,
        p_customer_id,
        p_reseller_id,
        p_number_tickets,
        v_extended_price,
        v_commission,
        sysdate)
    returning ticket_sales_id into p_ticket_sales_id;
    
    commit;

exception
   when others then
     log_error(sqlerrm, sqlcode,'purchase_tickets_from_reseller');
     raise;
end purchase_tickets_from_reseller;

procedure verify_tickets_available_venue
(
   p_ticket_group_id in number,
   p_number_tickets in number
)
is
   v_price_category ticket_groups.price_category%type;
   v_available_venue number;
   v_available_resellers number;
   v_message varchar2(1000);
begin

   with base as
   (
     select 
     tg.tickets_available,
     tg.price_category,
     nvl(
        (select sum(ta.tickets_assigned)
        from event_system.ticket_assignments ta
        where ta.ticket_group_id = tg.ticket_group_id)
     ,0) as reseller_tickets_assigned,
     nvl(
        (select sum(ts.ticket_quantity)
        from event_system.ticket_sales ts
        where ts.ticket_group_id = tg.ticket_group_id
        and ts.reseller_id is null)
     ,0) as venue_tickets_sold,
     nvl(
       (select sum(ts.ticket_quantity)
        from event_system.ticket_sales ts
        where ts.ticket_group_id = tg.ticket_group_id
        and ts.reseller_id is not null)
     ,0) as reseller_tickets_sold
     from event_system.ticket_groups tg
     where tg.ticket_group_id = p_ticket_group_id 
   )
   select 
   base.price_category,
   base.tickets_available - (base.reseller_tickets_assigned + base.venue_tickets_sold),
   base.reseller_tickets_assigned - base.reseller_tickets_sold
   into v_price_category, v_available_venue, v_available_resellers
   from base;

   if v_available_venue < p_number_tickets then
      v_message := 'Cannot purchase ' || p_number_tickets || ' ' || v_price_category || ' tickets from venue.  ';
      if v_available_venue = 0 and v_available_resellers = 0 then
         v_message := v_message || 'All '||  v_price_category || ' tickets are SOLD OUT.';
      else
         v_message := v_message || case when v_available_venue > 0 then to_char(v_available_venue) else 'No' end || ' tickets are available directly from venue.  ';
         v_message := v_message || case when v_available_resellers > 0 then v_available_resellers || ' tickets are available through resellers.' else 'All resellers are SOLD OUT.' end;
      end if;
      raise_application_error(-20100,v_message);
   end if;

end verify_tickets_available_venue;



--record ticket purchased from venue directly
--raise error if ticket group quantity available is less than number of tickets requested
--return ticket sales id as sales confirmation number
procedure purchase_tickets_from_venue
(
   p_ticket_group_id in number,
   p_customer_id in number,
   p_number_tickets in number,
   p_ticket_sales_id out number
)
is
   v_price number;
   v_extended_price number;
begin

   verify_tickets_available_venue(p_ticket_group_id, p_number_tickets);

   v_price := get_current_ticket_price(p_ticket_group_id);
   v_extended_price := v_price * p_number_tickets;
   
   insert into event_system.ticket_sales(
        ticket_group_id, 
        customer_id, 
        reseller_id, 
        ticket_quantity,
        extended_price,
        reseller_commission,
        sales_date)
    values (
        p_ticket_group_id,
        p_customer_id,
        NULL,
        p_number_tickets,
        v_extended_price,
        0,
        sysdate)
    returning ticket_sales_id into p_ticket_sales_id;

    commit;
    
exception
  when others then
    log_error(sqlerrm, sqlcode, 'purchase_tickets_from_venue');
    raise;
end purchase_tickets_from_venue;


procedure show_customer_event_tickets
(
   p_customer_id in number,
   p_event_id in number,
   p_tickets out sys_refcursor
)
is
begin

   open p_tickets for
   select
   ct.customer_id,
   ct.customer_name,
   ct.customer_email,   
   ct.venue_id,
   ct.venue_name,
   ct.event_id,
   ct.event_name,
   ct.event_date,
   ct.total_tickets_purchased,
   ct.ticket_group_id,
   ct.price_category,
   ct.ticket_sales_id,
   ct.ticket_quantity,
   ct.sales_date,
   ct.reseller_id,
   ct.reseller_name
   from event_system.customer_event_tickets_v ct
   where ct.event_id = p_event_id and ct.customer_id = p_customer_id
   order by ct.price_category;

end show_customer_event_tickets;

procedure show_customer_event_tickets_by_email
(
   p_customer_email in varchar2,
   p_event_id in number,
   p_tickets out sys_refcursor
)
is
   v_customer_id number;
begin

   v_customer_id := get_customer_id(p_customer_email);
   
   show_customer_event_tickets(v_customer_id, p_event_id, p_tickets);


end show_customer_event_tickets_by_email;



--package initialization
begin
  g_user := user;
  g_sid := sys_context('userenv','sid');
end events_api;