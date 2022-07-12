create or replace view event_series_v_json as
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
), json_base as
(
    select
        v.venue_id
        ,s.event_series_id
        ,json_object(
            'venue_id'             : v.venue_id
            ,'venue_name'          : v.venue_name
            ,'event_series_id'     : s.event_series_id
            ,'event_series_name'   : s.event_series_name
            ,'events_in_series'    : s.events_in_series
            ,'tickets_available_all_events' : s.tickets_available_all_events
            ,'tickets_remaining_all_events' : s.tickets_remaining_all_events
            ,'events_sold_out'              : s.events_sold_out
            ,'events_still_available'       : s.events_still_available
            ,'series_events' :
                (
                select 
                    json_arrayagg(
                        json_object(
                            'event_id'           : e.event_id
                            ,'event_name'        : e.event_name
                            ,'event_date'        : e.event_date
                            ,'tickets_available' : e.tickets_available
                            ,'tickets_remaining' : e.tickets_remaining
                        ) 
                    returning clob)
                from event_system.venue_event_series_v e
                where 
                    e.venue_id = v.venue_id 
                    and e.event_series_id = s.event_series_id
                )
        returning clob) as json_doc
    from 
        event_series_base s
        join event_system.venues_v v
            on s.venue_id = v.venue_id
)
select
   b.event_series_id,
   b.json_doc,
   json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;