create or replace view customer_event_tickets_v_json_verify as
with base as
(
    select
        customer_id
        ,event_id
        ,json_doc
    from customer_event_tickets_v_json
)
select
    b.customer_id
    ,j.customer_id as customer_id_json
    ,j.customer_name
    ,j.customer_email
    ,j.venue_id
    ,j.venue_name
    ,j.event_series_id
    ,b.event_id
    ,j.event_id as event_id_json
    ,j.event_name
    ,cast(j.event_date as date) as event_date
    ,j.event_tickets
    ,j.ticket_group_id
    ,j.price_category
    ,j.ticket_sales_id
    ,j.ticket_quantity
    ,cast(j.sales_date as date) as sales_date
    ,j.reseller_id
    ,j.reseller_name
    ,j.ticket_id
    ,j.serial_code
    ,j.status
    ,j.issued_to_name
    ,j.issued_to_id
    ,j.assigned_section
    ,j.assigned_row
    ,j.assigned_seat
from 
    base b,
    json_table(b.json_doc
        columns
        (
            customer_id     number        path '$.customer_id'
            ,customer_name  varchar2(100) path '$.customer_name'
            ,customer_email varchar2(100) path '$.customer_email'
            ,venue_id       number        path '$.venue_id'
            ,venue_name     varchar2(100) path '$.venue_name'
            ,event_series_id       number        path '$.event_series_id'
            ,event_id       number        path '$.event_id'
            ,event_name     varchar2(100) path '$.event_name'
            ,event_date     timestamp     path '$.event_date'
            ,event_tickets  number        path '$.event_tickets'
            ,nested                       path '$.purchases[*]'
                columns
                (
                    ticket_group_id  number        path ticket_group_id
                    ,price_category  varchar2(50)  path price_category
                    ,ticket_sales_id number        path ticket_sales_id
                    ,ticket_quantity number        path ticket_quantity
                    ,sales_date      timestamp     path sales_date
                    ,reseller_id     number        path reseller_id
                    ,reseller_name   varchar2(100) path reseller_name
                    ,nested                        path '$.tickets[*]'
                        columns
                        (
                            ticket_id         number        path ticket_id
                            ,serial_code      varchar2(500) path serial_code
                            ,status           varchar2(20)  path status
                            ,issued_to_name   varchar2(100) path issued_to_name
                            ,issued_to_id     varchar2(100) path issued_to_id
                            ,assigned_section varchar2(20)  path assigned_section
                            ,assigned_row     varchar2(10)  path assigned_row
                            ,assigned_seat    varchar2(10)  path assigned_seat
                        )
                )
        )
    ) j;