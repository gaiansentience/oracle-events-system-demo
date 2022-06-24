(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,event_id
    ,event_id as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from events_v
minus
select
    venue_id
    ,venue_id_json as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,event_id
    ,event_id_json as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from events_v_json_verify
)
union all
(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,event_id
    ,event_id as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from events_v
minus
select
    venue_id
    ,venue_id_xml as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,event_id
    ,event_id_xml as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from events_v_xml_verify
)