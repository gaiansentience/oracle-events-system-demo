with base as
(
    select
        ticket_sales_id
        ,serial_code
        --\d+ and [0-9]+ specify one or more digits
        --identify the serialization mask as a set of subexpressions, the specify the correct subexpression
        ,regexp_substr(serial_code, '^G(\d+)C(\d+)S(\d+)D(\d+)Q(\d+)I(\d+)$',1,1,'c',1) as sc_g
        ,regexp_substr(serial_code, '^G(\d+)C(\d+)S(\d+)D(\d+)Q(\d+)I(\d+)$',1,1,'c',2) as sc_c
        ,regexp_substr(serial_code, '^G(\d+)C(\d+)S(\d+)D(\d+)Q(\d+)I(\d+)$',1,1,'c',3) as sc_s
        ,regexp_substr(serial_code, '^G(\d+)C(\d+)S(\d+)D(\d+)Q(\d+)I(\d+)$',1,1,'c',4) as sc_d
        ,regexp_substr(serial_code, '^G(\d+)C(\d+)S(\d+)D(\d+)Q(\d+)I(\d+)$',1,1,'c',5) as sc_q
        ,regexp_substr(serial_code, '^G(\d+)C(\d+)S(\d+)D(\d+)Q(\d+)I(\d+)$',1,1,'c',6) as sc_i
    from tickets
), typed_base as
(
    select
        b.ticket_sales_id
        ,b.serial_code
        ,to_number(b.sc_g) as ticket_group_id
        ,to_number(b.sc_c) as customer_id
        ,to_number(b.sc_s) as sc_ticket_sales_id
        ,to_date(b.sc_d, 'YYYYMMDDHH24MISS') as sales_date
        ,to_number(b.sc_q) as ticket_quantity
        ,to_number(b.sc_i) as ticket_number
    from base b
)
select
* 
from typed_base b
order by ticket_sales_id
