--get all venues as a json document
set serveroutput on;
declare
    l_json json;
begin

    l_json := events_json_api.get_all_venues_summary(p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

end;

/*
[
  {
    "venue_id" : 4,
    "venue_name" : "Cozy Spot",
    "organizer_name" : "Drew Cavendish",
    "organizer_email" : "Drew.Cavendish@CozySpot.com",
    "max_event_capacity" : 400,
    "events_scheduled" : 112,
    "first_event_date" : "2022-08-16T15:10:22",
    "last_event_date" : "2023-07-07T15:10:22",
    "min_event_tickets" : 400,
    "max_event_tickets" : 400
  },
  {
    "venue_id" : 6,
    "venue_name" : "Nick's Place",
    "organizer_name" : "Nick Tremaine",
    "organizer_email" : "Nick.Tremaine@Nick'sPlace.com",
    "max_event_capacity" : 500,
    "events_scheduled" : 109,
    "first_event_date" : "2022-08-16T15:10:22",
    "last_event_date" : "2023-12-08T15:10:22",
    "min_event_tickets" : 500,
    "max_event_tickets" : 500
  },
  {
    "venue_id" : 7,
    "venue_name" : "Pearl Nightclub",
    "organizer_name" : "Gina Andrews",
    "organizer_email" : "Gina.Andrews@PearlNightclub.com",
    "max_event_capacity" : 1000,
    "events_scheduled" : 111,
    "first_event_date" : "2022-08-16T15:10:22",
    "last_event_date" : "2024-02-23T15:10:22",
    "min_event_tickets" : 1000,
    "max_event_tickets" : 1000
  },
  {
    "venue_id" : 1,
    "venue_name" : "City Stadium",
    "organizer_name" : "Erin Johanson",
    "organizer_email" : "Erin.Johanson@CityStadium.com",
    "max_event_capacity" : 20000,
    "events_scheduled" : 46,
    "first_event_date" : "2022-08-06T16:30:07",
    "last_event_date" : "2023-08-30T19:00:00",
    "min_event_tickets" : 5000,
    "max_event_tickets" : 20000
  },
  {
    "venue_id" : 2,
    "venue_name" : "Clockworks",
    "organizer_name" : "Juliette Rivera",
    "organizer_email" : "Juliette.Rivera@Clockworks.com",
    "max_event_capacity" : 2000,
    "events_scheduled" : 15,
    "first_event_date" : "2022-09-16T15:10:22",
    "last_event_date" : "2023-02-03T15:10:22",
    "min_event_tickets" : 2000,
    "max_event_tickets" : 2000
  },
  {
    "venue_id" : 3,
    "venue_name" : "Club 11",
    "organizer_name" : "Mary Rivera",
    "organizer_email" : "Mary.Rivera@Club11.com",
    "max_event_capacity" : 500,
    "events_scheduled" : 115,
    "first_event_date" : "2022-08-16T15:10:22",
    "last_event_date" : "2023-04-22T15:10:22",
    "min_event_tickets" : 500,
    "max_event_tickets" : 500
  },
  {
    "venue_id" : 5,
    "venue_name" : "Crystal Ballroom",
    "organizer_name" : "Rudolph Racine",
    "organizer_email" : "Rudolph.Racine@CrystalBallroom.com",
    "max_event_capacity" : 2000,
    "events_scheduled" : 17,
    "first_event_date" : "2022-10-07T15:10:22",
    "last_event_date" : "2023-09-23T15:10:22",
    "min_event_tickets" : 2000,
    "max_event_tickets" : 2000
  },
  {
    "venue_id" : 8,
    "venue_name" : "The Ampitheatre",
    "organizer_name" : "Max Johnson",
    "organizer_email" : "Max.Johnson@TheAmpitheatre.com",
    "max_event_capacity" : 10000,
    "events_scheduled" : 21,
    "first_event_date" : "2022-10-28T15:10:22",
    "last_event_date" : "2024-05-11T15:10:22",
    "min_event_tickets" : 10000,
    "max_event_tickets" : 10000
  },
  {
    "venue_id" : 9,
    "venue_name" : "The Right Spot",
    "organizer_name" : "Carol Zaxby",
    "organizer_email" : "Carol.Zaxby@TheRightSpot.com",
    "max_event_capacity" : 2000,
    "events_scheduled" : 16,
    "first_event_date" : "2022-11-04T15:10:22",
    "last_event_date" : "2024-07-27T15:10:22",
    "min_event_tickets" : 2000,
    "max_event_tickets" : 2000
  },
  {
    "venue_id" : 21,
    "venue_name" : "The Pink Pony Revue",
    "organizer_name" : "Julia Stein",
    "organizer_email" : "Julia.Stein@ThePinkPonyRevue.com",
    "max_event_capacity" : 350,
    "events_scheduled" : 18,
    "first_event_date" : "2023-05-01T00:00:00",
    "last_event_date" : "2023-08-24T00:00:00",
    "min_event_tickets" : 200,
    "max_event_tickets" : 200
  },
  {
    "venue_id" : 41,
    "venue_name" : "Another Roadside Attraction",
    "organizer_name" : "Susan Brewer",
    "organizer_email" : "Susan.Brewer@AnotherRoadsideAttraction.com",
    "max_event_capacity" : 500,
    "events_scheduled" : 1,
    "first_event_date" : "2023-12-31T20:00:00",
    "last_event_date" : "2023-12-31T20:00:00",
    "min_event_tickets" : 400,
    "max_event_tickets" : 400
  },
  {
    "venue_id" : 10,
    "venue_name" : "Roadside Cafe",
    "organizer_name" : "Billy Styles",
    "organizer_email" : "Billy.Styles@RoadsideCafe.com",
    "max_event_capacity" : 400,
    "events_scheduled" : 0,
    "first_event_date" : null,
    "last_event_date" : null,
    "min_event_tickets" : 0,
    "max_event_tickets" : 0
  }
]



*/