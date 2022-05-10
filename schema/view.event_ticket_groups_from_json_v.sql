create or replace view event_ticket_groups_from_json_v as
--use to validate the json view
with base as
(
select
venue_id,
event_id,
json_doc
from event_ticket_groups_json_v
)
select
b.venue_id,
j.venue_id as json_venue_id,
j.venue_name,
j.organizer_name,
j.organizer_email,
b.event_id,
j.event_id as json_event_id,
j.event_name,
j.event_date,
j.event_tickets_available,
j.ticket_group_id,
j.price_category,
j.price,
j.tickets_available
from base b,
json_table(b.json_doc
   columns
   (
      venue_id number path '$.venue_id',
      venue_name varchar2(50) path '$.venue_name',
      organizer_name varchar2(50) path '$.organizer_name',
      organizer_email varchar2(50) path '$.organizer_email',
      event_id number path '$.event_id',
      event_name varchar2(50) path '$.event_name', 
      event_date date path '$.event_date',
      event_tickets_available number path '$.event_tickets_available',
      nested path '$.ticket_groups[*]'
      columns
      (
        ticket_group_id number path ticket_group_id,
        price_category varchar2(50) path price_category,
        price number path price,
        tickets_available number path tickets_available
      )
   )
) j

/*
"{
  "event_id" : 2,
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 918,
      "price_category" : "BACKSTAGE-ALL ACCESS",
      "price" : 150,
      "tickets_available" : 2000
    },
    {
      "ticket_group_id" : 920,
      "price_category" : "EARLYBIRD DISCOUNT",
      "price" : 40,
      "tickets_available" : 2000
    },
    {
      "ticket_group_id" : 922,
      "price_category" : "GENERAL ADMISSION",
      "price" : 50,
      "tickets_available" : 12000
    },
    {
      "ticket_group_id" : 921,
      "price_category" : "RESERVED SEATING",
      "price" : 75,
      "tickets_available" : 2000
    },
    {
      "ticket_group_id" : 919,
      "price_category" : "VIP",
      "price" : 100,
      "tickets_available" : 2000
    }
  ]
}"
*/