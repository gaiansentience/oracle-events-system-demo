create or replace view customer_events_v_json as
with customer_venues as
(
    select
        customer_id
        ,min(customer_name) as customer_name
        ,min(customer_email) as customer_email
        ,min(venue_name) as venue_name
        ,venue_id
    from event_system.customer_events_v 
    group by
        customer_id
        ,venue_id
), json_base as
(
    select
        v.customer_id
        ,v.venue_id
        ,json_object(
            'customer_id'     : v.customer_id
            ,'customer_name'  : v.customer_name
            ,'customer_email' : v.customer_email      
            ,'venue_id'       : v.venue_id
            ,'venue_name'     : v.venue_name
            ,'event_listing'  :
                (select
                    json_arrayagg(
                        json_object(
                            'event_id'       : e.event_id
                            ,'event_series_id' : e.event_series_id
                            ,'event_name'     : e.event_name
                            ,'event_date'     : e.event_date
                            ,'event_tickets' : e.event_tickets
                        )
                    returning clob)
                from event_system.customer_events_v e
                where
                    e.venue_id = v.venue_id
                    and e.customer_id = v.customer_id
                )            
        returning clob) as json_doc
    from customer_venues v
)
select
    b.customer_id
    ,b.venue_id
    ,b.json_doc
    ,json_serialize(b.json_doc pretty) as json_doc_formatted
from json_base b;