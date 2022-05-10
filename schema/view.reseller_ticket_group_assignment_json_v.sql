create or replace view reseller_ticket_group_assignment_json_v as
with json_base as
(
select
e.venue_id,
e.event_id,
json_object(
      'venue_id' : v.venue_id,
      'venue_name' : v.venue_name,
      'organizer_email' : v.organizer_email,
      'organizer_name' : v.organizer_name,
      'event_id' : e.event_id, 
      'event_name' : e.event_name,
      'event_date' : e.event_date,
      'event_tickets_available' : e.tickets_available,
      'ticket_resellers' : 
      (
      select json_arrayagg(
           json_object(
              'reseller_id' : r.reseller_id, 
              'reseller_name' : r.reseller_name,
              'reseller_email' : r.reseller_email,
              'ticket_assignments' :
              (
                 select json_arrayagg(
                    json_object(
                       'ticket_group_id' : tg.ticket_group_id, 
                       'price_category' : tg.price_category, 
                       'price' : tg.price, 
                       'tickets_in_group' : tg.tickets_available,
                       'tickets_assigned' : nvl(ta.tickets_assigned,0),
                       'ticket_assignment_id' : ta.ticket_assignment_id,
                       'assigned_to_others' : 
                           nvl((
                           select sum(ta_others.tickets_assigned) from ticket_assignments ta_others where ta_others.ticket_group_id = tg.ticket_group_id and ta_others.reseller_id <> r.reseller_id
                           ),0),
                       'max_available' : 
                           (
                              tg.tickets_available 
                              -  nvl((
                                 select sum(ta_others.tickets_assigned) from ticket_assignments ta_others where ta_others.ticket_group_id = tg.ticket_group_id and ta_others.reseller_id <> r.reseller_id
                                 ),0)
                              -  nvl((
                                 select sum(ts_venue.ticket_quantity) from ticket_sales ts_venue where ts_venue.ticket_group_id = tg.ticket_group_id and ts_venue.reseller_id is null
                                 ),0)
                           ),
                       'min_assignment' :
                           nvl((
                           select sum(ts_venue.ticket_quantity) from ticket_sales ts_venue where ts_venue.ticket_group_id = tg.ticket_group_id and ts_venue.reseller_id = r.reseller_id
                           ),0),
                       'sold_by_reseller' :
                           nvl((
                           select sum(ts_venue.ticket_quantity) from ticket_sales ts_venue where ts_venue.ticket_group_id = tg.ticket_group_id and ts_venue.reseller_id = r.reseller_id
                           ),0),
                       'sold_by_venue' :
                           nvl((
                           select sum(ts_venue.ticket_quantity) from ticket_sales ts_venue where ts_venue.ticket_group_id = tg.ticket_group_id and ts_venue.reseller_id is null
                           ),0)
                    returning clob)
                 returning clob) 
                 from ticket_groups tg left join ticket_assignments ta on tg.ticket_group_id = ta.ticket_group_id and ta.reseller_id = r.reseller_id
                 where tg.event_id = e.event_id
              ) 
           returning clob) 
      returning clob)
      from resellers r
      ) 
returning clob) as json_doc
from
venues v join events e on v.venue_id = e.venue_id
)
select
b.venue_id,
b.event_id,
b.json_doc,
json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b