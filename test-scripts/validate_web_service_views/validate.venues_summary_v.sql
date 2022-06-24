(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,events_scheduled
    ,trunc(first_event_date) as first_event_date
    ,trunc(last_event_date) as last_event_date
from venues_summary_v
minus
select
    venue_id
    ,venue_id_json as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,events_scheduled
    ,trunc(first_event_date) as first_event_date
    ,trunc(last_event_date) as last_event_date
from venues_summary_v_json_verify
)
union all
(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,events_scheduled
    ,trunc(first_event_date) as first_event_date
    ,trunc(last_event_date) as last_event_date
from venues_summary_v
minus
select
    venue_id
    ,venue_id_xml as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,events_scheduled
    ,trunc(first_event_date) as first_event_date
    ,trunc(last_event_date) as last_event_date
from venues_summary_v_xml_verify
)