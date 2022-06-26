create or replace view event_series_ticket_prices_v_xml as
with xml_base as
(
    select
        e.venue_id
        ,e.event_series_id
        ,xmlelement("event_series_ticket_prices"
            ,xmlelement("event_series"
                ,xmlforest(
                    xmlforest(
                        e.venue_id    as "venue_id"
                        ,e.venue_name as "venue_name"
                    ) as "venue"
                    ,e.event_series_id         as "event_series_id"
                    ,e.event_name              as "event_name"
                    ,e.events_in_series        as "events_in_series"
                    ,e.first_event_date        as "first_event_date"
                    ,e.last_event_date         as "last_event_date"
                    ,e.event_tickets_available as "event_tickets_available"
                )
            )
            ,xmlelement("ticket_groups"
                ,(select 
                    xmlagg(
                        xmlelement("ticket_group"
                            ,xmlforest(
                                g.price_category                as "price_category"
                                ,g.price                        as "price"
                                ,g.tickets_available_all_events as "tickets_available_all_events"
                                ,g.tickets_sold_all_events      as "tickets_sold_all_events"
                                ,g.tickets_remaining_all_events as "tickets_remaining_all_events"
                            )
                        )
                    )
                from event_system.event_series_ticket_prices_v g
                where g.event_series_id = e.event_series_id)
            )
        ) as xml_doc
    from event_system.venue_event_series_base_v e
)
select
    b.venue_id
    ,b.event_series_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;