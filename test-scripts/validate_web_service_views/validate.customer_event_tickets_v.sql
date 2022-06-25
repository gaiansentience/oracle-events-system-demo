(select
    customer_id
    ,customer_id as customer_id_doc
    ,customer_name
    ,customer_email
    ,venue_id
    ,venue_name
    ,event_id
    ,event_id as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,total_tickets_purchased
    ,ticket_group_id
    ,price_category
    ,ticket_sales_id
    ,ticket_quantity
    ,trunc(sales_date) as sales_date
    ,reseller_id
    ,reseller_name
from customer_event_tickets_v
minus
select
    customer_id
    ,customer_id_json as customer_id_doc
    ,customer_name
    ,customer_email
    ,venue_id
    ,venue_name
    ,event_id
    ,event_id_json as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,total_tickets_purchased
    ,ticket_group_id
    ,price_category
    ,ticket_sales_id
    ,ticket_quantity
    ,trunc(sales_date) as sales_date
    ,reseller_id
    ,reseller_name
from customer_event_tickets_v_json_verify)
union all
(
select
    customer_id
    ,customer_id as customer_id_doc
    ,customer_name
    ,customer_email
    ,venue_id
    ,venue_name
    ,event_id
    ,event_id as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,total_tickets_purchased
    ,ticket_group_id
    ,price_category
    ,ticket_sales_id
    ,ticket_quantity
    ,trunc(sales_date) as sales_date
    ,reseller_id
    ,reseller_name
from customer_event_tickets_v
minus
select
    customer_id
    ,customer_id_xml as customer_id_doc
    ,customer_name
    ,customer_email
    ,venue_id
    ,venue_name
    ,event_id
    ,event_id_xml as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,total_tickets_purchased
    ,ticket_group_id
    ,price_category
    ,ticket_sales_id
    ,ticket_quantity
    ,trunc(sales_date) as sales_date
    ,reseller_id
    ,reseller_name
from customer_event_tickets_v_xml_verify
)