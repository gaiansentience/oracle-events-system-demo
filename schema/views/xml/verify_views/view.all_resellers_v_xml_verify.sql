create or replace view all_resellers_v_xml_verify as
select 
    t.reseller_id
    ,t.reseller_name
    ,t.reseller_email
    ,t.commission_percent
from 
    all_resellers_v_xml x,
    xmltable('/all_resellers/reseller' passing x.xml_doc 
        columns
            reseller_id         number        path 'reseller_id'
            ,reseller_name      varchar2(100) path 'reseller_name'
            ,reseller_email     varchar2(100) path 'reseller_email'
            ,commission_percent number        path 'commission_percent'
    ) t;
