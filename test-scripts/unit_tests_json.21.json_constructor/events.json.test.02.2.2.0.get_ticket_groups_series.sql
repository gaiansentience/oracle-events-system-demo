set serveroutput on;
declare    
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_name events.event_name%type := 'Monster Truck Smashup';
    l_venue_id number;
    l_event_series_id number;
    l_json_doc clob;
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);

    l_json_doc := events_json_api.get_ticket_groups_series(p_event_series_id => l_event_series_id, p_formatted => true);
    dbms_output.put_line(l_json_doc);

end;

/*
--BEFORE CREATING TICKET GROUPS
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "events_in_series" : 13,
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "event_tickets_available" : 10000,
  "ticket_groups" :
  [
    {
      "price_category" : "UNDEFINED",
      "price" : 0,
      "tickets_available" : 10000,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    }
  ]
}


--AFTER CREATING TICKET GROUPS
{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "events_in_series" : 13,
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "event_tickets_available" : 10000,
  "ticket_groups" :
  [
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "tickets_available" : 4500,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    },
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "tickets_available" : 500,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "tickets_available" : 5000,
      "currently_assigned" : 0,
      "sold_by_venue" : 0
    }
  ]
}


PL/SQL procedure successfully completed.



*/