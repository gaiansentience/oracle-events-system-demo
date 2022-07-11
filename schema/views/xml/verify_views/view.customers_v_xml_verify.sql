create or replace view customers_v_xml_verify as
with base as
(
    select
        customer_id
        ,xml_doc
    from event_system.customers_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    b.customer_id
    ,t.customer_id as reseller_id_xml
    ,t.customer_name
    ,t.customer_email
from 
    base b,
    xmltable('/customer' passing b.xml_doc 
        columns
            customer_id     number        path 'customer_id'
            ,customer_name  varchar2(100) path 'customer_name'
            ,customer_email varchar2(100) path 'customer_email'
    ) t;