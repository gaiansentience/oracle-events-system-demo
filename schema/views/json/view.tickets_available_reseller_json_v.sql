create or replace view tickets_available_reseller_json_v as
with event_resellers as
(
    select
        tg.event_id
        ,ta.reseller_id
    from 
        ticket_groups tg 
        join ticket_assignments ta 
            on tg.ticket_group_id = ta.ticket_group_id
    group by
        tg.event_id
        ,ta.reseller_id
), reseller_ticket_groups as
(
    select
        tg.event_id
        ,ta.reseller_id
        ,ta.ticket_group_id
    from 
        event_system.ticket_groups tg 
        join event_system.ticket_assignments ta 
            on tg.ticket_group_id = ta.ticket_group_id
    group by
        tg.event_id
        ,ta.reseller_id
        ,ta.ticket_group_id
), json_base as
(
    select
        e.venue_id
        ,e.event_id
        ,er.reseller_id
        ,json_object(
            'venue_id'   : e.venue_id,
            'venue_name' : e.venue_name,
            'event_id'   : e.event_id, 
            'event_name' : e.event_name,
            'event_date' : e.event_date,
            'event_tickets_available' : e.tickets_available,
            'ticket_groups' : 
                (select 
                    json_arrayagg(
                        json_object(
                            'ticket_group_id'    : g.ticket_group_id
                            ,'price_category'    : g.price_category
                            ,'price'             : g.price
                            ,'tickets_available' : g.tickets_available
                            ,'tickets_sold'      : g.tickets_sold
                            ,'tickets_remaining' : g.tickets_remaining
                            ,'ticket_resellers'  : 
                                (select 
                                    json_arrayagg(
                                        json_object(
                                            'reseller_id'    : ta.reseller_id
                                            ,'reseller_name' : ta.reseller_name
                                            ,'reseller_tickets_available' : ta.tickets_available
                                            ,'reseller_ticket_status'     : ta.ticket_status
                                        )
                                    returning clob)
                                from event_system.tickets_available_reseller_v ta 
                                where 
                                    ta.ticket_group_id = g.ticket_group_id
                                    and ta.reseller_id = rtg.reseller_id)
                        returning clob)
                    returning clob)
                from 
                    event_system.event_ticket_prices_v g 
                    join reseller_ticket_groups rtg 
                        on g.ticket_group_id = rtg.ticket_group_id 
                where 
                    g.event_id = e.event_id 
                    and rtg.reseller_id = er.reseller_id)
        returning clob) as json_doc
    from 
        event_system.venue_event_base_v e
        join event_resellers er 
            on e.event_id = er.event_id
)
select
    b.venue_id
    ,b.event_id
    ,b.reseller_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;