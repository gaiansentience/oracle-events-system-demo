create or replace view tickets_available_series_all_v_json as
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
            ,'first_event_date' : e.first_event_date
            ,'last_event_date'  : e.last_event_date
            ,'events_in_series' : e.events_in_series
            ,'ticket_groups'    : 
                (select 
                    json_arrayagg(
                        json_object(
                            'price_category'    : g.price_category
                            ,'price'            : g.price
                            ,'ticket_resellers' : 
                                (select 
                                    json_arrayagg(
                                        json_object(
                                            'reseller_id'        : ta.reseller_id
                                            ,'reseller_name'     : ta.reseller_name
                                            ,'tickets_available' : ta.tickets_available
                                            ,'events_available'  : ta.events_available
                                            ,'events_sold_out'   : ta.events_sold_out
                                        )
                                    returning clob) 
                                from event_system.tickets_available_series_all_v ta 
                                where 
                                    ta.event_series_id = g.event_series_id
                                    and ta.price_category = g.price_category)
                        returning clob)
                    returning clob)
                from event_system.event_series_ticket_prices_v g 
                where g.event_series_id = e.event_series_id)
        returning clob) as json_doc
    from event_system.venue_event_series_base_v e
)
select
    b.venue_id
    ,b.event_series_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;