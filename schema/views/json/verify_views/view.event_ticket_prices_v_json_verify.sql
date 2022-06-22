create or replace view event_ticket_prices_v_json_verify as
select
p.venue_id,
j.venue_id venue_id_json,
j.venue_name,
p.event_id,
j.event_id event_id_json,
j.event_name,
cast(j.event_date as date) as event_date,
j.event_tickets_available,
j.ticket_group_id,
j.price_category,
j.price,
j.tickets_available,
j.tickets_sold,
j.tickets_remaining
from
event_ticket_prices_v_json p,
json_table(p.json_doc
   columns
      (
      venue_id number path '$.venue_id',
      venue_name varchar2(50) path '$.venue_name',
      event_id number path '$.event_id',
      event_name varchar2(50) path '$.event_name',
      event_date timestamp path '$.event_date',
      event_tickets_available number path '$.event_tickets_available',
      nested path '$.ticket_groups[*]'
         columns
         (
            ticket_group_id number path ticket_group_id,
            price_category varchar2(50) path price_category,
            price number path price,
            tickets_available number path tickets_available,
            tickets_sold number path tickets_sold,
            tickets_remaining number path tickets_remaining
         )
      )
) j;