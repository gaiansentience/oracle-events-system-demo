--truncate table tickets drop storage;

insert into tickets(ticket_sales_id, serial_code)
select 
ts.ticket_sales_id
--,ts.ticket_quantity
,'G' || to_char(ts.ticket_group_id)
    || 'C' || to_char(ts.customer_id)
    || 'S' || to_char(ts.ticket_sales_id)
    || 'D' || to_char(ts.sales_date,'YYYYMMDDHH24MISS')
    || 'Q' || to_char(ts.ticket_quantity,'fm0999') || 'I'
    || to_char(b.n,'fm0999') as serial_code
from ticket_sales ts cross apply 
(select level as n from dual connect by level <= ts.ticket_quantity) b;
