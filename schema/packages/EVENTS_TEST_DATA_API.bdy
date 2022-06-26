create or replace package body events_test_data_api
as

    procedure delete_test_data
    is
        procedure truncate_table(p_table in varchar2)
        is
            v_ddl varchar2(100);
        begin
            v_ddl := 'truncate table event_system.' || p_table || ' drop storage'; 
            execute immediate v_ddl;
        end truncate_table;
    begin

        truncate_table('tickets');
        truncate_table('ticket_sales');
        truncate_table('ticket_assignments');
        truncate_table('ticket_groups');
        truncate_table('events');
        truncate_table('venues');
        truncate_table('resellers');
        truncate_table('customers');
        truncate_table('error_log');

    end delete_test_data;

--remove all data for an event
--use during testing to repeat event creation process
    procedure delete_event_data(p_event_id in number)
    is
    begin

        delete from tickets t 
        where t.ticket_sales_id in 
            (
                select ts.ticket_sales_id 
                from ticket_sales ts 
                join ticket_groups tg 
                    on ts.ticket_group_id = tg.ticket_group_id 
                where tg.event_id = p_event_id
            );

        delete from ticket_sales ts 
        where ts.ticket_group_id in 
            (
                select tg.ticket_group_id 
                from ticket_groups tg 
                where tg.event_id = p_event_id
            );
    
        delete from ticket_assignments ta 
        where ta.ticket_group_id in 
            (
                select tg.ticket_group_id 
                from ticket_groups tg 
                where tg.event_id = p_event_id
            );
    
        delete from ticket_groups tg 
        where tg.event_id = p_event_id;

        delete from events e 
        where e.event_id = p_event_id;

        commit;

        dbms_output.put_line('all data for event ' || p_event_id || ' has been deleted');

    end delete_event_data;

--use during testing to remove a recurring venue event by name
procedure delete_venue_events_by_name
(
   p_venue_id in number,
   p_event_name in varchar2
)
is
cursor c is
select event_id
from events where venue_id = p_venue_id
and event_name = p_event_name;
begin

for r in c loop
   delete_event_data(r.event_id);
end loop;

dbms_output.put_line(p_event_name || ' deleted for venue_id = ' || p_venue_id);

end delete_venue_events_by_name;




procedure create_customers
is

cursor customers is
   with fnames as 
   (
   select 'April' as fname from dual union all
   select 'Alex' from dual union all
   select 'Alexa' from dual union all
   select 'Andre' from dual union all
   select 'Andrea' from dual union all
   select 'Bert' from dual union all
   select 'Chris' from dual union all
   select 'Christopher' from dual union all
   select 'Edward' from dual union all
   select 'Eve' from dual union all
   select 'Gary' from dual union all 
   select 'Gene' from dual union all
   select 'Gina' from dual union all
   select 'Grace' from dual union all
   select 'Harold' from dual union all
   select 'Harry' from dual union all
   select 'Howard' from dual union all
   select 'James' from dual union all
   select 'Jane' from dual union all
   select 'Jean' from dual union all
   select 'Jill' from dual union all
   select 'Jillian' from dual union all
   select 'Jerry' from dual union all
   select 'Jim' from dual union all
   select 'John' from dual union all
   select 'Jules' from dual union all
   select 'Julie' from dual union all
   select 'Judy' from dual union all
   select 'June' from dual union all
   select 'Katherine' from dual union all
   select 'Kathy' from dual union all
   select 'Keanu' from dual union all
   select 'Kelly' from dual union all
   select 'Kyle' from dual union all
   select 'Maggie' from dual union all
   select 'Margaret' from dual union all
   select 'Matt' from dual union all
   select 'Matthew' from dual union all
   select 'Pete' from dual union all
   select 'Paul' from dual union all
   select 'Phil' from dual union all
   select 'Phillipe' from dual union all
   select 'Reese' from dual union all  
   select 'Rene' from dual union all
   select 'Richard' from dual union all
   select 'Ron' from dual union all
   select 'Ryan' from dual union all
   select 'Shelly' from dual union all
   select 'Stan' from dual union all
   select 'Stanley' from dual union all
   select 'Stephen' from dual union all
   select 'Steve' from dual union all
   select 'Tina' from dual union all
   select 'Tom' from dual union all
   select 'Tilly' from dual
   ),
   lnames as
   (
   select 'Albright' as lname from dual union all
   select 'Barry' from dual union all
   select 'Baum' from dual union all
   select 'Bikram' from dual union all
   select 'Birch' from dual union all
   select 'Dewar' from dual union all
   select 'Dodge' from dual union all
   select 'Edmunds' from dual union all
   select 'Edwards' from dual union all
   select 'Fredericks' from dual union all
   select 'Garcia' from dual union all
   select 'Gardner' from dual union all
   select 'Hilfiger' from dual union all
   select 'Hill' from dual union all
   select 'Hilyard' from dual union all
   select 'Hoffman' from dual union all
   select 'Jackson' from dual union all
   select 'Janeway' from dual union all
   select 'Jenkins' from dual union all
   select 'Jones' from dual union all
   select 'Keyes' from dual union all
   select 'Kensington' from dual union all
   select 'Kirby' from dual union all
   select 'Killjoy' from dual union all
   select 'Kim' from dual union all
   select 'Kirk' from dual union all
   select 'Mansfield' from dual union all
   select 'Masters' from dual union all
   select 'Miller' from dual union all
   select 'Moore' from dual union all
   select 'Park' from dual union all   
   select 'Picard' from dual union all  
   select 'Potter' from dual union all
   select 'Porter' from dual union all
   select 'Richards' from dual union all
   select 'Roberts' from dual union all
   select 'Robertson' from dual union all
   select 'Rodriguez' from dual union all
   select 'Singer' from dual union all
   select 'Smith' from dual union all
   select 'Song' from dual union all
   select 'Star' from dual union all
   select 'Teller' from dual union all
   select 'Tennant' from dual union all
   select 'Vaughn' from dual union all
   select 'Wall' from dual union all
   select 'Walsh' from dual union all
   select 'Wells' from dual union all
   select 'Wayland' from dual union all
   select 'Wilson' from dual
   )
   select
   fname || ' ' || lname as name,
   fname || '.' || lname || '@example.customer.com' as email,
   dbms_random.value(1,100) random_sort
   from fnames cross join lnames
   order by random_sort;

c_id number;
i number := 0;
begin


for r in customers loop
  
  events_api.create_customer(r.name, r.email, c_id);
  i := i + 1;
end loop;


dbms_output.put_line(i || ' customers created');

end create_customers;

procedure create_resellers
is
cursor resellers is
with name_base as
(
select 'Tickets R Us' as name from dual union all
select 'Tickets 2 Go' from dual union all
select 'Ticketron' from dual union all
select 'Source Tix' from dual union all
select 'Old School' from dual union all
select 'Ticket Supply' from dual union all
select 'Ticket Time' from dual union all
select 'MaxTix' from dual union all
select 'Your Ticket Supplier' from dual union all
select 'The Source' from dual union all
select 'Events For You' from dual
)
select
n.name,
'ticket.sales@' || replace(n.name,' ') || '.com' as email,
round(dbms_random.value(10,15)/100,4) as commission_pct
from name_base n
order by n.name;

r_id number;
i number := 0;
begin


  for r in resellers loop
    events_api.create_reseller(r.name, r.email, r.commission_pct, r_id);
    i := i + 1;
  end loop;

  dbms_output.put_line(i || ' resellers created');
  
end create_resellers;

procedure create_venues
is
cursor venues is
with base as
(
select 'The Ampitheatre' as venue_name, 'Max Johnson' as organizer_name, 10000 as capacity from dual union all
select 'City Stadium', 'Erin Johanson', 20000 from dual union all
select 'The Right Spot', 'Carol Zaxby', 2000 from dual union all
select 'Nick''s Place', 'Nick Tremaine', 500 from dual union all
select 'Pearl Nightclub', 'Gina Andrews', 1000 from dual union all
select 'Club 11', 'Mary Rivera', 500 from dual union all
select 'Cozy Spot', 'Drew Cavendish', 400 from dual union all
select 'Crystal Ballroom', 'Rudolph Racine', 2000 from dual
) 
select
b.venue_name,
b.organizer_name,
replace(b.organizer_name,' ','.')|| '@' || replace(b.venue_name,' ') || '.com' as organizer_email,
capacity
from base b
order by b.venue_name;

v_id number;
i number := 0;
begin

for r in venues loop
   events_api.create_venue(r.venue_name, r.organizer_name, r.organizer_email,r.capacity, v_id);
   i := i + 1;
end loop;

dbms_output.put_line(i || ' venues created');

end create_venues;

procedure create_events
is
cursor acts is
with acts as
(
select 'Rudy and the Trees' as act_name from dual union all
select 'A Night of Polka' from dual union all
select 'Molly Jones and Associates' from dual union all
select 'Rolling Thunder' from dual union all
select 'Miles Morgan and the Undergound Jazz Trio' from dual union all
select 'Purple Parrots' from dual union all
select 'The Specials' from dual union all
select 'Synthtones and Company' from dual union all
select 'The Electric Blues Garage Band' from dual
), acts_base as
(
select a.act_name,
rownum * 7 as act_row
from acts a
), venue_base as
(select v.venue_id, v.venue_name, v.max_event_capacity,
rownum as venue_row
from venues v)
select
v.venue_id,
a.act_name,
next_day(sysdate,'Friday') + (a.act_row * v.venue_row) event_date,
v.max_event_capacity as tickets_available
from acts_base a cross join venue_base v
order by event_date, a.act_name, v.venue_name;

e_id number;
i number := 0;
begin

for r in acts loop
  events_api.create_event(r.venue_id, r.act_name, r.event_date, r.tickets_available, e_id);
  i := i + 1;
end loop;

  dbms_output.put_line(i || ' events created');

end create_events;

procedure create_weekly_events
is
  cursor small_venues is 
  select v.venue_id, v.max_event_capacity as event_tickets
  from venues v
  where v.max_event_capacity <= 500;
  
  v_status varchar2(4000);
  v_start_date date := sysdate + 21;
  v_end_date date := sysdate + 180;
  v_event_series_id number;
begin

  for r in small_venues loop
    events_api.create_weekly_event(r.venue_id, 'Amateur Comedy Hour', v_start_date, v_end_date, 'Thursday',r.event_tickets,v_event_series_id,v_status);
    dbms_output.put_line(v_status);
    events_api.create_weekly_event(r.venue_id, 'Poetry Night', v_start_date, v_end_date, 'Tuesday',r.event_tickets,v_event_series_id,v_status);
    dbms_output.put_line(v_status);
    events_api.create_weekly_event(r.venue_id, 'Open Mike Night', v_start_date, v_end_date, 'Wednesday',r.event_tickets,v_event_series_id,v_status);
    dbms_output.put_line(v_status);  
  end loop;


end create_weekly_events;

procedure create_ticket_groups
is

   cursor small_events is
   select e.event_id, e.tickets_available
   from events e where e.tickets_available <= 500;

   cursor large_events is
   select e.event_id, e.tickets_available
   from events e where e.tickets_available > 500;


   v_group_id number;
   i number := 0;
   
   type r_ticket_group is record
   (
      price_category ticket_groups.price_category%type,
      price ticket_groups.price%type,
      tickets number
   );

   type t_ticket_groups is table of r_ticket_group index by pls_integer;
   v_ticket_groups t_ticket_groups;
   
   procedure factor_tickets(p_total_tickets in number, p_percent in number, p_tickets out number, p_remaining in out number)
   is
   begin
     p_tickets := trunc(p_total_tickets * p_percent);
     p_remaining := p_remaining - p_tickets;
   end factor_tickets;
   
   function build_small_event(p_tickets in number) return t_ticket_groups
   is
     v_groups t_ticket_groups;
     v_tickets number;
     v_remaining_tickets number := p_tickets;
   begin
     factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
     v_groups(1) := r_ticket_group('SPONSOR',100,v_tickets);        
     factor_tickets(p_tickets, .20, v_tickets, v_remaining_tickets);
     v_groups(2) := r_ticket_group('VIP',42,v_tickets);   
     factor_tickets(p_tickets, .20, v_tickets, v_remaining_tickets);
     v_groups(3) := r_ticket_group('EARLYBIRD DISCOUNT',22,v_tickets);   
     v_groups(4) := r_ticket_group('GENERAL ADMISSION',30,v_remaining_tickets);   
     return v_groups;
   end build_small_event;

   function build_large_event(p_tickets in number) return t_ticket_groups
   is
     v_groups t_ticket_groups;
     v_tickets number;
     v_remaining_tickets number := p_tickets;
   begin
     factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
     v_groups(1) := r_ticket_group('BACKSTAGE-ALL ACCESS',150,v_tickets);        
     factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
     v_groups(2) := r_ticket_group('VIP',100,v_tickets);   
     factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
     v_groups(3) := r_ticket_group('EARLYBIRD DISCOUNT',40,v_tickets); 
     factor_tickets(p_tickets, .10, v_tickets, v_remaining_tickets);
     v_groups(4) := r_ticket_group('RESERVED SEATING',75,v_tickets);      
     v_groups(5) := r_ticket_group('GENERAL ADMISSION',50,v_remaining_tickets);   
     return v_groups;
   end build_large_event;

begin

  for r in small_events loop
    v_ticket_groups := build_small_event(r.tickets_available);
    for g in 1..v_ticket_groups.count loop
      events_api.create_ticket_group(r.event_id, v_ticket_groups(g).price_category, v_ticket_groups(g).price, v_ticket_groups(g).tickets, v_group_id);
      i := i + 1;
    end loop;
  end loop;

  for r in large_events loop
    v_ticket_groups := build_large_event(r.tickets_available);
    for g in 1..v_ticket_groups.count loop
      events_api.create_ticket_group(r.event_id, v_ticket_groups(g).price_category, v_ticket_groups(g).price, v_ticket_groups(g).tickets, v_group_id);
      i := i + 1;
    end loop;
  end loop;


  dbms_output.put_line(i || ' ticket groups created');

end create_ticket_groups;

procedure create_ticket_assignments
is

   cursor event_ticket_groups is
   select 
   tg.ticket_group_id, 
   round(tg.tickets_available * 0.8) as tickets_available
   from events e join ticket_groups tg on e.event_id = tg.event_id
   order by e.venue_id, e.event_date, tg.ticket_group_id;

   type t_resellers is table of number index by pls_integer;
   v_resellers t_resellers;
   v_tickets number;
   v_tickets_remaining number;
   v_assignment_id number;
   i number := 0;
   function get_resellers return t_resellers
   is
     l_resellers t_resellers;
   begin
   
        with base as
        (
        select
        reseller_id,
        round(dbms_random.value(0,1),2) include_reseller
        from
        resellers
        order by dbms_random.value
        ), random_base as
        (
        select
        reseller_id,
        b.include_reseller
        from base b
        where b.include_reseller > .5
        )
        select reseller_id bulk collect into l_resellers from random_base;   
   
   
     --select r.reseller_id bulk collect into l_resellers from resellers r;
     
     return l_resellers;
   end get_resellers;
   
   procedure factor_tickets(p_total in number, p_tickets out number, p_remaining in out number)
   is
     l_tickets number := p_total * 0.1;
   begin
     case 
     when l_tickets > 1000 then l_tickets := 1000;
     when l_tickets > 500 then l_tickets := 500;
     when l_tickets > 250 then l_tickets := 250;
     when l_tickets > 100 then l_tickets := 100;
     else l_tickets := 20;
     end case;
     if l_tickets < p_remaining then
       p_remaining := p_remaining - l_tickets;
     else
        l_tickets := 0;
     end if;
     p_tickets := l_tickets;
   end factor_tickets;

begin

--  v_resellers := get_resellers;

  for etg in event_ticket_groups loop
     v_tickets_remaining := etg.tickets_available;
     --for each ticket group only assign it to some resellers
     --each ticket group may be assigned to a different group of resellers
     v_resellers := get_resellers;
     for r in 1..v_resellers.count loop
        factor_tickets(etg.tickets_available, v_tickets, v_tickets_remaining);
        if v_tickets > 0 then
           events_api.create_ticket_assignment(v_resellers(r),etg.ticket_group_id, v_tickets, v_assignment_id); 
           i := i + 1;
        end if;     
     end loop;
  
  end loop;

  dbms_output.put_line(i || ' ticket assignments created');
  
end create_ticket_assignments;


procedure create_event_ticket_sales
(
   p_event_id in number
)
is
   cursor ticket_options is
   select
   ticket_group_id,
   reseller_id,
   trunc((trunc(dbms_random.value(30,100))/100 * tickets_available)) tickets_available
   from
   events_report_api.show_event_tickets_available_all(p_event_id) 
   where tickets_available > 0;

   type r_customer is record(customer_id number, number_tickets number);
   type t_customers is table of r_customer;
   v_customers t_customers;
   v_sales_id number;
   v_tickets_available number;
   i number := 0;

   function get_random_customers return t_customers
   is
      l_customers t_customers;
   begin
      select customer_id, trunc(dbms_random.value(2,20)) as number_tickets
      bulk collect into l_customers
      from customers
      order by dbms_random.value()
      fetch first 50 rows only;
  
      return l_customers;

   end get_random_customers;

begin


  for o in ticket_options loop  --o.ticket_group_id o.reseller_id  o.tickets_available
     v_customers := get_random_customers;
     v_tickets_available := o.tickets_available;
     for c in 1..v_customers.count loop
     
        if v_customers(c).number_tickets > 0 and v_tickets_available > v_customers(c).number_tickets then
           begin
              if o.reseller_id is not null then
           
                 events_api.purchase_tickets_from_reseller(
                    p_reseller_id => o.reseller_id,
                    p_ticket_group_id => o.ticket_group_id,
                    p_customer_id => v_customers(c).customer_id,
                    p_number_tickets => v_customers(c).number_tickets,
                    p_ticket_sales_id => v_sales_id);
                 
              else
           
                 events_api.purchase_tickets_from_venue(
                    p_ticket_group_id => o.ticket_group_id,
                    p_customer_id => v_customers(c).customer_id,
                    p_number_tickets => v_customers(c).number_tickets,
                    p_ticket_sales_id => v_sales_id);

              end if;
              i := i + 1;
              v_tickets_available := v_tickets_available - v_customers(c).number_tickets;
           exception
              when others then
                 null;
           end;
        end if;
     end loop;
  end loop;

  if i > 0 then
     dbms_output.put_line(i || ' ticket sales transactions created for event ' || p_event_id);
  end if;

end create_event_ticket_sales;


procedure create_ticket_sales
is
   type r_event is record(event_id number, generate_sales number);
   type t_events is table of r_event;
   v_events t_events;
   i number := 0;
begin

   select event_id, sign(trunc(dbms_random.value(-3,3))) as generate_sales 
   bulk collect into v_events
   from events
   order by dbms_random.value;

   for e in 1..v_events.count loop
      if v_events(e).generate_sales = 1 then
         create_event_ticket_sales(v_events(e).event_id);
         i := i + 1;
      end if;   
   end loop;

  dbms_output.put_line('created sales for ' || i || ' events.');

end create_ticket_sales;

procedure create_test_data
is
begin

   --clear previous test data
   delete_test_data;

   create_customers;
   create_resellers;
   create_venues;
   create_events;
   create_weekly_events;
   create_ticket_groups;
   create_ticket_assignments;
   
   for i in 1..4 loop
      create_ticket_sales;
   end loop;

end create_test_data;

begin
    dbms_random.seed('Albert Einstein');
end events_test_data_api;
