create or replace view resellers_v_xml_verify as
with base as
(
    select
        reseller_id
        ,xml_doc
    from event_system.resellers_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    b.reseller_id
    ,t.reseller_id as reseller_id_xml
    ,t.reseller_name
    ,t.reseller_email
    ,t.commission_percent
from 
    base b,
    xmltable('/reseller' passing b.xml_doc 
        columns
            reseller_id         number        path 'reseller_id'
            ,reseller_name      varchar2(100) path 'reseller_name'
            ,reseller_email     varchar2(100) path 'reseller_email'
            ,commission_percent number        path 'commission_percent'
    ) t;