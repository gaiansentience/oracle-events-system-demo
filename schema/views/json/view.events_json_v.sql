create or replace view events_json_v as
with json_base as
(
    select
        v.venue_id,
        e.event_id,
        json_object(
           'venue_id' : v.venue_id,
           'venue_name' : v.venue_name,
           'organizer_email' : v.organizer_email,
           'organizer_name' : v.organizer_name,
           'event_id' : e.event_id, 
           'event_name' : e.event_name,
           'event_date' : e.event_date,
           'tickets_available' : e.tickets_available,
           'tickets_remaining' : 
              e.tickets_available
              - nvl((
                 select sum(ts.ticket_quantity) 
                 from 
                    ticket_groups tg join ticket_sales ts 
                    on tg.ticket_group_id = ts.ticket_group_id
                 where tg.event_id = e.event_id
                ),0)
        ) as json_doc
    from event_system.venues v join event_system.events e on v.venue_id = e.venue_id
)
select
    b.venue_id,
    b.event_id,
    b.json_doc,
    json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;