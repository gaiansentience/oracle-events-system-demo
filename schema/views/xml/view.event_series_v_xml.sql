create or replace view event_series_v_xml as
with event_series_base as
(
    select
        s.venue_id
        ,s.event_series_id
        ,min(s.event_name)              as event_series_name
        ,count(s.event_id)              as events_in_series
        ,sum(s.tickets_available)       as tickets_available_all_events
        ,sum(s.tickets_remaining)       as tickets_remaining_all_events
        ,sum(s.tickets_sold_out)        as events_sold_out
        ,sum(s.tickets_still_available) as events_still_available
    from event_system.venue_event_series_v s
    group by
        s.venue_id,
        s.event_series_id
), xml_base as
(
    select
        v.venue_id
        ,s.event_series_id
        ,xmlelement("event_series"
            ,xmlforest(
                xmlforest(
                    v.venue_id    as "venue_id"
                    ,v.venue_name as "venue_name"
                ) as "venue"
            ,s.event_series_id   as "event_series_id"
            ,s.event_series_name as "event_series_name"
            ,s.events_in_series  as "events_in_series"
            ,s.tickets_available_all_events as "tickets_available_all_events"
            ,s.tickets_remaining_all_events as "tickets_remaining_all_events"
            ,s.events_sold_out              as "events_sold_out"
            ,s.events_still_available       as "events_still_available"
                ,(select 
                    xmlagg(
                        xmlelement("event"
                            ,xmlforest(
                                e.event_id           as "event_id"
                                ,e.event_name        as "event_name"
                                ,e.event_date        as "event_date"
                                ,e.tickets_available as "tickets_available"
                                ,e.tickets_remaining as "tickets_remaining"
                            ) 
                        )
                    )
                from event_system.venue_event_series_v e
                where 
                    e.venue_id = v.venue_id
                    and e.event_series_id = s.event_series_id
                ) as "series_events"
            )
        ) as xml_doc
    from 
        event_series_base s
        join event_system.venues_v v
            on s.venue_id = v.venue_id
)
select
    b.event_series_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;