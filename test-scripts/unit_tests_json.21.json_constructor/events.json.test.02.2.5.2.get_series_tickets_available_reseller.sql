set serveroutput on;
declare
    l_json json;
    l_reseller_name resellers.reseller_name%type := 'Maxtix';
    l_reseller_id number;
    l_venue_id number;
    l_venue_name venues.venue_name%type := 'City Stadium';    
    l_event_series_id number;
    l_event_name events.event_name%type := 'Monster Truck Smashup';    
begin

    l_venue_id := venue_api.get_venue_id(p_venue_name => l_venue_name);
    l_event_series_id := event_api.get_event_series_id(p_venue_id => l_venue_id, p_event_name => l_event_name);
    l_reseller_id := reseller_api.get_reseller_id(p_reseller_name => l_reseller_name);

    l_json := events_json_api.get_event_series_tickets_available_reseller(p_event_series_id => l_event_series_id, p_reseller_id => l_reseller_id, p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

end;
--reply format example
/*

{
  "venue_id" : 1,
  "venue_name" : "City Stadium",
  "event_series_id" : 81,
  "event_name" : "Monster Truck Smashup",
  "first_event_date" : "2023-06-07T19:00:00",
  "last_event_date" : "2023-08-30T19:00:00",
  "events_in_series" : 13,
  "ticket_groups" :
  [
    {
      "price_category" : "VIP PIT ACCESS",
      "price" : 500,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 1300,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    },
    {
      "price_category" : "RESERVED SEATING",
      "price" : 350,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    },
    {
      "price_category" : "GENERAL ADMISSION",
      "price" : 200,
      "ticket_resellers" :
      [
        {
          "reseller_id" : 2,
          "reseller_name" : "MaxTix",
          "tickets_available" : 13000,
          "events_available" : 13,
          "events_sold_out" : 0
        }
      ]
    }
  ]
}

*/