create or replace view resellers_v_xml as
with xml_base as
(
    select
        r.reseller_id
        ,xmlelement("reseller"
            ,xmlforest(
                r.reseller_id         as "reseller_id"
                ,r.reseller_name      as "reseller_name"
                ,r.reseller_email     as "reseller_email"
                ,r.commission_percent as "commission_percent"
            )
        ) as xml_doc
    from event_system.resellers_v r
)
select
    b.reseller_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;