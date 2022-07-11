set serveroutput on;
declare
  l_xml xmltype;
begin

    l_xml := events_xml_api.get_all_venues(p_formatted => true);

    dbms_output.put_line(l_xml.getstringval);

end;

/*
<all_venues>
  <venue>
    <venue_id>1</venue_id>
    <venue_name>City Stadium</venue_name>
    <organizer_email>Erin.Johanson@CityStadium.com</organizer_email>
    <organizer_name>Erin Johanson</organizer_name>
    <max_event_capacity>20000</max_event_capacity>
    <venue_scheduled_events>33</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>2</venue_id>
    <venue_name>Clockworks</venue_name>
    <organizer_email>Juliette.Rivera@Clockworks.com</organizer_email>
    <organizer_name>Juliette Rivera</organizer_name>
    <max_event_capacity>2000</max_event_capacity>
    <venue_scheduled_events>15</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>3</venue_id>
    <venue_name>Club 11</venue_name>
    <organizer_email>Mary.Rivera@Club11.com</organizer_email>
    <organizer_name>Mary Rivera</organizer_name>
    <max_event_capacity>500</max_event_capacity>
    <venue_scheduled_events>115</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>4</venue_id>
    <venue_name>Cozy Spot</venue_name>
    <organizer_email>Drew.Cavendish@CozySpot.com</organizer_email>
    <organizer_name>Drew Cavendish</organizer_name>
    <max_event_capacity>400</max_event_capacity>
    <venue_scheduled_events>112</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>5</venue_id>
    <venue_name>Crystal Ballroom</venue_name>
    <organizer_email>Rudolph.Racine@CrystalBallroom.com</organizer_email>
    <organizer_name>Rudolph Racine</organizer_name>
    <max_event_capacity>2000</max_event_capacity>
    <venue_scheduled_events>17</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>6</venue_id>
    <venue_name>Nick&apos;s Place</venue_name>
    <organizer_email>Nick.Tremaine@Nick&apos;sPlace.com</organizer_email>
    <organizer_name>Nick Tremaine</organizer_name>
    <max_event_capacity>500</max_event_capacity>
    <venue_scheduled_events>109</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>7</venue_id>
    <venue_name>Pearl Nightclub</venue_name>
    <organizer_email>Gina.Andrews@PearlNightclub.com</organizer_email>
    <organizer_name>Gina Andrews</organizer_name>
    <max_event_capacity>1000</max_event_capacity>
    <venue_scheduled_events>111</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>8</venue_id>
    <venue_name>The Ampitheatre</venue_name>
    <organizer_email>Max.Johnson@TheAmpitheatre.com</organizer_email>
    <organizer_name>Max Johnson</organizer_name>
    <max_event_capacity>10000</max_event_capacity>
    <venue_scheduled_events>21</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>9</venue_id>
    <venue_name>The Right Spot</venue_name>
    <organizer_email>Carol.Zaxby@TheRightSpot.com</organizer_email>
    <organizer_name>Carol Zaxby</organizer_name>
    <max_event_capacity>2000</max_event_capacity>
    <venue_scheduled_events>16</venue_scheduled_events>
  </venue>
  <venue>
    <venue_id>10</venue_id>
    <venue_name>Roadside Cafe</venue_name>
    <organizer_email>Bill.Styles@RoadsideCafe</organizer_email>
    <organizer_name>Bill Styles</organizer_name>
    <max_event_capacity>200</max_event_capacity>
    <venue_scheduled_events>0</venue_scheduled_events>
  </venue>
</all_venues>

*/