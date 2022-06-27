with base as
(
    select 
        t.ticket_sales_id
        ,serial_code
        ,substr(serial_code, 2, instr(serial_code,'C') - 2) as sc_g
        ,substr(serial_code, instr(serial_code,'C') + 1, instr(serial_code,'S') - instr(serial_code, 'C') -1) as sc_c
        ,substr(serial_code, instr(serial_code,'S') + 1, instr(serial_code,'D') - instr(serial_code, 'S') -1) as sc_s
        ,substr(serial_code, instr(serial_code,'D') + 1, instr(serial_code,'Q') - instr(serial_code, 'D') -1) as sc_d
        ,substr(serial_code, instr(serial_code,'Q') + 1, instr(serial_code,'I') - instr(serial_code, 'Q') -1) as sc_q
        ,substr(serial_code, instr(serial_code,'I') + 1) as sc_i
    from tickets t
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
