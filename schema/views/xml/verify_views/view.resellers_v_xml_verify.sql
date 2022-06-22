create or replace view resellers_v_xml_verify as
select 
    x.reseller_id
    ,t.reseller_id as reseller_id_xml
    ,t.reseller_name
    ,t.reseller_email
    ,t.commission_percent
from 
    resellers_v_xml x,
    xmltable('/reseller' passing x.xml_doc 
        columns
            reseller_id         number        path 'reseller_id'
            ,reseller_name      varchar2(100) path 'reseller_name'
            ,reseller_email     varchar2(100) path 'reseller_email'
            ,commission_percent number        path 'commission_percent'
    ) t;
