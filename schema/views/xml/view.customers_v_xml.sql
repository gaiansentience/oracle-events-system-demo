create or replace view customers_v_xml as
with xml_base as
(
    select
        c.customer_id
        ,c.customer_email
        ,xmlelement("customer"
            ,xmlforest(
                c.customer_id     as "customer_id"
                ,c.customer_name  as "customer_name"
                ,c.customer_email as "customer_email"
            )
        ) as xml_doc
    from
        event_system.customers_v c
)
select
    b.customer_id
    ,b.customer_email
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;