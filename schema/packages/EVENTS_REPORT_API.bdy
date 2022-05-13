create or replace package body events_report_api
as


function show_venues_summary 
return t_venue_summary pipelined
is
   t_rows t_venue_summary;
   rc sys_refcursor;
begin

   events_api.show_venues_summary(rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;
   return;

end show_venues_summary;

function show_resellers 
return t_resellers_info pipelined
is
   t_rows t_resellers_info;
   rc sys_refcursor;
begin

  events_api.show_resellers(rc);
  fetch rc bulk collect into t_rows;
  close rc;
  
  for i in 1..t_rows.count loop
     pipe row(t_rows(i));
  end loop;
  return;

end show_resellers;   

function show_venue_upcoming_events
(
   p_venue_id in number
)  return t_upcoming_events pipelined
is
   t_rows t_upcoming_events;
   rc sys_refcursor;
begin

   events_api.show_venue_upcoming_events(p_venue_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;
   return;

end show_venue_upcoming_events;

function show_venue_reseller_performance
(
   p_venue_id in number
) return t_reseller_performance pipelined
is
   t_rows t_reseller_performance;
   rc sys_refcursor;
begin
   
   events_api.show_venue_reseller_performance(p_venue_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
     pipe row (t_rows(i));
   end loop;
   return;
   
end show_venue_reseller_performance;

function show_venue_reseller_commissions
(
   p_venue_id in number,
   p_reseller_id in number
) return t_reseller_commissions pipelined
is
  t_rows t_reseller_commissions;
  rc sys_refcursor;
begin

   events_api.show_venue_reseller_commissions(p_venue_id, p_reseller_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;   
   return;

end show_venue_reseller_commissions;

function show_ticket_groups
(
   p_event_id in number
) return t_ticket_groups pipelined
is
  t_rows t_ticket_groups;
  rc sys_refcursor;
begin

  events_api.show_ticket_groups(p_event_id, rc);
  fetch rc bulk collect into t_rows;
  close rc;
  
  for i in 1..t_rows.count loop
     pipe row(t_rows(i));
  end loop;
  return;

end show_ticket_groups;


function show_reseller_ticket_group_availability
(
   p_event_id in number,
   p_reseller_id in number
) return t_ticket_assignments pipelined
is
  t_rows t_ticket_assignments;
  rc sys_refcursor;
begin

   events_api.show_reseller_ticket_group_availability(p_event_id, p_reseller_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row (t_rows(i));
   end loop;
   return;

end show_reseller_ticket_group_availability;

function show_all_event_tickets_available
(
   p_event_id in number 
) return t_event_tickets pipelined
is
  t_rows t_event_tickets;
  rc sys_refcursor;
begin

   events_api.show_all_event_tickets_available(p_event_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;
   return;
   
end show_all_event_tickets_available;

function show_reseller_tickets_available
(
   p_event_id in number,
   p_reseller_id in number  
) return t_reseller_event_tickets pipelined
is
  t_rows t_reseller_event_tickets;
  rc sys_refcursor;
begin

   events_api.show_reseller_tickets_available(p_event_id, p_reseller_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;
   return;
   
end show_reseller_tickets_available;

function show_venue_tickets_available
(
   p_event_id in number
) return t_venue_event_tickets pipelined
is
  t_rows t_venue_event_tickets;
  rc sys_refcursor;
begin

   events_api.show_venue_tickets_available(p_event_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;
   return;
   
end show_venue_tickets_available;

function show_customer_event_tickets
(
   p_customer_id in number,
   p_event_id in number
) return t_customer_event_tickets pipelined
is
   t_rows t_customer_event_tickets;
   rc sys_refcursor;
begin

   events_api.show_customer_event_tickets(p_customer_id, p_event_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;
   return;
   
end show_customer_event_tickets;


function show_customer_event_tickets_by_email
(
   p_customer_email in varchar2,
   p_event_id in number
) return t_customer_event_tickets pipelined
is
   v_customer_id number;
   t_rows t_customer_event_tickets;
   rc sys_refcursor;
begin

   v_customer_id := events_api.get_customer_id(p_customer_email);

   events_api.show_customer_event_tickets(v_customer_id, p_event_id, rc);
   fetch rc bulk collect into t_rows;
   close rc;
   
   for i in 1..t_rows.count loop
      pipe row(t_rows(i));
   end loop;
   return;
   
end show_customer_event_tickets_by_email;



begin
  null;
end events_report_api;
