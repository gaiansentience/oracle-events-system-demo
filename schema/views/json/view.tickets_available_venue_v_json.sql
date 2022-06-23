create or replace view tickets_available_venue_v_json as
with json_base as
(
    select
        e.venue_id
        ,e.event_id
        ,json_object(
            'venue_id'    : e.venue_id
            ,'venue_name' : e.venue_name
            ,'event_id'   : e.event_id
            ,'event_name' : e.event_name
            ,'event_date' : e.event_date
            ,'event_tickets_available' : e.tickets_available
            ,'ticket_groups' : 
                (select 
                    json_arrayagg(
                        json_object(
                            'ticket_group_id'    : g.ticket_group_id
                            ,'price_category'    : g.price_category
                            ,'price'             : g.price
                            ,'group_tickets_available' : g.tickets_available
                            ,'group_tickets_sold'      : g.tickets_sold
                            ,'group_tickets_remaining' : g.tickets_remaining
                            ,'ticket_resellers'  : 
                                (select 
                                    json_arrayagg(
                                        json_object(
                                            'reseller_id'       : ta.reseller_id
                                            ,'reseller_name'    : ta.reseller_name
                                            ,'tickets_available' : ta.tickets_available
                                            ,'ticket_status'     : ta.ticket_status
                                        )
                                    returning clob) 
                                from event_system.tickets_available_venue_v ta 
                                where ta.ticket_group_id = g.ticket_group_id)
                        returning clob)
                    returning clob)
                from event_system.event_ticket_prices_v g 
                where g.event_id = e.event_id)
        returning clob) as json_doc
    from event_system.venue_event_base_v e
)
select
    b.venue_id
    ,b.event_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;