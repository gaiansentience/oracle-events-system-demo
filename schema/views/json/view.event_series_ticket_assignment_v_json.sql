create or replace view event_series_ticket_assignment_v_json as
with json_base as
(
    select
        e.venue_id,
        e.event_series_id,
        json_object(
            'venue_id'                 : e.venue_id
            ,'venue_name'              : e.venue_name
            ,'organizer_email'         : e.organizer_email
            ,'organizer_name'          : e.organizer_name
            ,'event_series_id'         : e.event_series_id
            ,'event_name'              : e.event_name
            ,'first_event_date'        : e.first_event_date
            ,'last_event_date'         : e.last_event_date
            ,'event_tickets_available' : e.event_tickets_available
            ,'ticket_resellers' : 
                (select 
                    json_arrayagg(
                        json_object(
                            'reseller_id'     : r.reseller_id
                            ,'reseller_name'  : r.reseller_name
                            ,'reseller_email' : r.reseller_email
                            ,'ticket_assignments' :
                                (
                                select 
                                    json_arrayagg(
                                        json_object(
                                            'price_category'        : tg.price_category
                                            ,'price'                : tg.price
                                            ,'tickets_in_group'     : tg.tickets_in_group
                                            ,'tickets_assigned'     : tg.tickets_assigned
                                            ,'assigned_to_others'   : tg.assigned_to_others
                                            ,'max_available'        : tg.max_available
                                            ,'min_assignment'       : tg.min_assignment
                                            ,'sold_by_reseller'     : tg.sold_by_reseller
                                            ,'sold_by_venue'        : tg.sold_by_venue
                                        )
                                    returning clob) 
                                from event_system.event_series_ticket_assignment_v tg
                                where 
                                    tg.event_series_id = e.event_series_id 
                                    and tg.reseller_id = r.reseller_id
                                ) 
                        returning clob) 
                    returning clob)
                from event_system.resellers r) 
        returning clob) as json_doc
    from event_system.venue_event_series_base_v e
)
select
    b.venue_id
    ,b.event_series_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;