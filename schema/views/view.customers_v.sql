create or replace view customers_v as
select
    c.customer_id
    ,c.customer_name
    ,c.customer_email
from
    event_system.customers c;