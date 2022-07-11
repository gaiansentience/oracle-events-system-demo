--get all venues as a json document
set serveroutput on;
declare
  v_json_doc clob;
begin

   v_json_doc := events_json_api.get_all_venues(p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

end;

/*
[
  {
    "venue_id" : 21,
    "venue_name" : "The Pink Pony Revue",
    "organizer_email" : "Julia.Stein@ThePinkPonyRevue.com",
    "organizer_name" : "Julia Stein",
    "max_event_capacity" : 200,
    "venue_scheduled_events" : 18
  },
  {
    "venue_id" : 1,
    "venue_name" : "City Stadium",
    "organizer_email" : "Erin.Johanson@CityStadium.com",
    "organizer_name" : "Erin Johanson",
    "max_event_capacity" : 20000,
    "venue_scheduled_events" : 33
  },
  {
    "venue_id" : 2,
    "venue_name" : "Clockworks",
    "organizer_email" : "Juliette.Rivera@Clockworks.com",
    "organizer_name" : "Juliette Rivera",
    "max_event_capacity" : 2000,
    "venue_scheduled_events" : 15
  },
  {
    "venue_id" : 3,
    "venue_name" : "Club 11",
    "organizer_email" : "Mary.Rivera@Club11.com",
    "organizer_name" : "Mary Rivera",
    "max_event_capacity" : 500,
    "venue_scheduled_events" : 115
  },
  {
    "venue_id" : 4,
    "venue_name" : "Cozy Spot",
    "organizer_email" : "Drew.Cavendish@CozySpot.com",
    "organizer_name" : "Drew Cavendish",
    "max_event_capacity" : 400,
    "venue_scheduled_events" : 112
  },
  {
    "venue_id" : 5,
    "venue_name" : "Crystal Ballroom",
    "organizer_email" : "Rudolph.Racine@CrystalBallroom.com",
    "organizer_name" : "Rudolph Racine",
    "max_event_capacity" : 2000,
    "venue_scheduled_events" : 17
  },
  {
    "venue_id" : 6,
    "venue_name" : "Nick's Place",
    "organizer_email" : "Nick.Tremaine@Nick'sPlace.com",
    "organizer_name" : "Nick Tremaine",
    "max_event_capacity" : 500,
    "venue_scheduled_events" : 109
  },
  {
    "venue_id" : 7,
    "venue_name" : "Pearl Nightclub",
    "organizer_email" : "Gina.Andrews@PearlNightclub.com",
    "organizer_name" : "Gina Andrews",
    "max_event_capacity" : 1000,
    "venue_scheduled_events" : 111
  },
  {
    "venue_id" : 8,
    "venue_name" : "The Ampitheatre",
    "organizer_email" : "Max.Johnson@TheAmpitheatre.com",
    "organizer_name" : "Max Johnson",
    "max_event_capacity" : 10000,
    "venue_scheduled_events" : 21
  },
  {
    "venue_id" : 9,
    "venue_name" : "The Right Spot",
    "organizer_email" : "Carol.Zaxby@TheRightSpot.com",
    "organizer_name" : "Carol Zaxby",
    "max_event_capacity" : 2000,
    "venue_scheduled_events" : 16
  },
  {
    "venue_id" : 10,
    "venue_name" : "Roadside Cafe",
    "organizer_email" : "Bill.Styles@RoadsideCafe",
    "organizer_name" : "Bill Styles",
    "max_event_capacity" : 200,
    "venue_scheduled_events" : 0
  }
]

*/