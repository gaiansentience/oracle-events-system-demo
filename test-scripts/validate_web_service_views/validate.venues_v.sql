(
select
    venue_id
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
from venues_v
minus
select
    venue_id
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
from venues_v_json_verify
)
union all
(
select
    venue_id
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
from venues_v
minus
select
    venue_id
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
from venues_v_xml_verify
)