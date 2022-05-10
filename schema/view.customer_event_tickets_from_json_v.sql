create or replace view customer_event_tickets_from_json_v as
with base as
(
select
customer_id,
event_id,
json_doc
from customer_event_tickets_json_v
)
select
b.customer_id,
j.customer_id as json_customer_id,
j.customer_name,
j.customer_email,
j.venue_id,
j.venue_name,
b.event_id,
j.event_id as json_event_id,
j.event_name,
cast(j.event_date as date) as event_date,
j.total_tickets_purchased,
j.ticket_group_id,
j.price_category,
j.ticket_sales_id,
j.ticket_quantity,
cast(j.sales_date as date) as sales_date,
j.reseller_id,
j.reseller_name
from base b,
json_table(b.json_doc
   columns
   (
      customer_id number path '$.customer_id',
      customer_name varchar2(50) path '$.customer_name',
      customer_email varchar2(50) path '$.customer_email',
      venue_id number path '$.venue_id',
      venue_name varchar2(50) path '$.venue_name',
      event_id number path '$.event_id',
      event_name varchar2(50) path '$.event_name',
      event_date timestamp path '$.event_date',
      total_tickets_purchased number path '$.total_tickets_purchased',
      nested path '$.event_ticket_purchases[*]'
         columns
         (
            ticket_group_id number path ticket_group_id,
            price_category varchar2(50) path price_category,
            ticket_sales_id number path ticket_sales_id,
            ticket_quantity number path ticket_quantity,
            sales_date timestamp path sales_date,
            reseller_id number path reseller_id,
            reseller_name varchar2(50) path reseller_name
         )
    )
) j

