--get all venues as a json document
set serveroutput on;
declare
    l_json_doc clob;
begin

    l_json_doc := events_json_api.get_all_venues_summary(p_formatted => true);
    dbms_output.put_line(l_json_doc);

end;

/*


Error starting at line : 3 in command -
declare
    l_json_doc clob;
begin

    l_json_doc := events_json_api.get_all_venues_summary(p_formatted => true);
    dbms_output.put_line(l_json_doc);

end;

/*

--wrong format, need to create all_venues_summary_v_json
[
  {
    "venue_id" : 4,
    "venue_name" : "Cozy Spot",
    "organizer_name" : "Drew Cavendish",
    "organizer_email" : "Drew.Cavendish@CozySpot.com",
    "max_event_capacity" : 400,
    "events_scheduled" : 112
  },
  {
    "venue_id" : 6,
    "venue_name" : "Nick's Place",
    "organizer_name" : "Nick Tremaine",
    "organizer_email" : "Nick.Tremaine@Nick'sPlace.com",
    "max_event_capacity" : 500,
    "events_scheduled" : 109
  },
  {
    "venue_id" : 7,
    "venue_name" : "Pearl Nightclub",
    "organizer_name" : "Gina Andrews",
    "organizer_email" : "Gina.Andrews@PearlNightclub.com",
    "max_event_capacity" : 1000,
    "events_scheduled" : 111
  },
  {
    "venue_id" : 1,
    "venue_name" : "City Stadium",
    "organizer_name" : "Erin Johanson",
    "organizer_email" : "Erin.Johanson@CityStadium.com",
    "max_event_capacity" : 20000,
    "events_scheduled" : 46
  },
  {
    "venue_id" : 2,
    "venue_name" : "Clockworks",
    "organizer_name" : "Juliette Rivera",
    "organizer_email" : "Juliette.Rivera@Clockworks.com",
    "max_event_capacity" : 2000,
    "events_scheduled" : 15
  },
  {
    "venue_id" : 3,
    "venue_name" : "Club 11",
    "organizer_name" : "Mary Rivera",
    "organizer_email" : "Mary.Rivera@Club11.com",
    "max_event_capacity" : 500,
    "events_scheduled" : 115
  },
  {
    "venue_id" : 5,
    "venue_name" : "Crystal Ballroom",
    "organizer_name" : "Rudolph Racine",
    "organizer_email" : "Rudolph.Racine@CrystalBallroom.com",
    "max_event_capacity" : 2000,
    "events_scheduled" : 17
  },
  {
    "venue_id" : 8,
    "venue_name" : "The Ampitheatre",
    "organizer_name" : "Max Johnson",
    "organizer_email" : "Max.Johnson@TheAmpitheatre.com",
    "max_event_capacity" : 10000,
    "events_scheduled" : 21
  },
  {
    "venue_id" : 9,
    "venue_name" : "The Right Spot",
    "organizer_name" : "Carol Zaxby",
    "organizer_email" : "Carol.Zaxby@TheRightSpot.com",
    "max_event_capacity" : 2000,
    "events_scheduled" : 16
  },
  {
    "venue_id" : 21,
    "venue_name" : "The Pink Pony Revue",
    "organizer_name" : "Julia Stein",
    "organizer_email" : "Julia.Stein@ThePinkPonyRevue.com",
    "max_event_capacity" : 350,
    "events_scheduled" : 18
  },
  {
    "venue_id" : 41,
    "venue_name" : "Another Roadside Attraction",
    "organizer_name" : "Susan Brewer",
    "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
    "max_event_capacity" : 500,
    "events_scheduled" : 1
  },
  {
    "venue_id" : 64,
    "venue_name" : "xxyyAnother Roadside Attraction",
    "organizer_name" : "Susie Brewer",
    "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
    "max_event_capacity" : 400,
    "events_scheduled" : 0
  },
  {
    "venue_id" : 63,
    "venue_name" : "xxAnother Roadside Attraction",
    "organizer_name" : "Susie Brewer",
    "organizer_email" : "Susie.Brewer@AnotherRoadsideAttraction.com",
    "max_event_capacity" : 400,
    "events_scheduled" : 0
  },
  {
    "venue_id" : 10,
    "venue_name" : "Roadside Cafe",
    "organizer_name" : "Billy Styles",
    "organizer_email" : "Billy.Styles@RoadsideCafe.com",
    "max_event_capacity" : 400,
    "events_scheduled" : 0
  }
]


*/