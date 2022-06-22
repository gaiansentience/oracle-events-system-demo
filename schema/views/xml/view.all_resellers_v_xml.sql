create or replace view all_resellers_v_xml as
with xml_base as
(
    select
        xmlelement("all_resellers",
            xmlagg(
                xmlelement("reseller",
                    xmlforest(
                        r.reseller_id     as "reseller_id"
                        ,r.reseller_name  as "reseller_name"
                        ,r.reseller_email as "reseller_email"
                        ,r.commission_percent as "commission_percent"
                    )
                )
            )
        ) as xml_doc
    from event_system.resellers r
)
select
    b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;