create or replace view event_series_ticket_prices_v_json as
with json_base as
(
    select
        e.venue_id
        ,e.event_series_id
        ,json_object(
            'venue_id'          : e.venue_id
            ,'venue_name'       : e.venue_name
            ,'event_series_id'  : e.event_series_id
            ,'event_name'       : e.event_name            
            ,'events_in_series' : e.events_in_series
            ,'first_event_date' : e.first_event_date
            ,'last_event_date'  : e.last_event_date
            ,'ticket_groups'    : 
                (
                select 
                    json_arrayagg(
                        json_object(
                            'price_category'                : g.price_category
                            ,'price'                        : g.price
                            ,'tickets_available_all_events' : g.tickets_available_all_events
                            ,'tickets_sold_all_events'      : g.tickets_sold_all_events
                            ,'tickets_remaining_all_events' : g.tickets_remaining_all_events
                        )
                    returning clob)
                from event_system.event_series_ticket_prices_v g
                where g.event_series_id = e.event_series_id
                )
        returning clob) as json_doc
    from event_system.venue_event_series_base_v e
)
select
    b.venue_id
    ,b.event_series_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;