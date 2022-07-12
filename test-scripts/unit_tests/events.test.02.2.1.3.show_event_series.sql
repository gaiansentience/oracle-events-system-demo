--show all events in the event series
select
*
from
events_report_api.show_event_series(61) 
order by event_date;

select * from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'Hometown Hockey League';