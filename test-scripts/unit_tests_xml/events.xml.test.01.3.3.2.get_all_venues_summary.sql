set serveroutput on;
declare
  l_xml xmltype;
begin

    l_xml := events_xml_api.get_all_venues_summary(p_formatted => true);

    dbms_output.put_line(l_xml.getclobval);

end;

/*

<all_venues_summary>
  <venue_summary>
    <venue>
      <venue_id>4</venue_id>
      <venue_name>Cozy Spot</venue_name>
      <organizer_name>Drew Cavendish</organizer_name>
      <organizer_email>Drew.Cavendish@CozySpot.com</organizer_email>
      <max_event_capacity>400</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>112</events_scheduled>
      <first_event_date>2022-08-16</first_event_date>
      <last_event_date>2023-07-07</last_event_date>
      <min_event_tickets>400</min_event_tickets>
      <max_event_tickets>400</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>6</venue_id>
      <venue_name>Nick&apos;s Place</venue_name>
      <organizer_name>Nick Tremaine</organizer_name>
      <organizer_email>Nick.Tremaine@Nick&apos;sPlace.com</organizer_email>
      <max_event_capacity>500</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>109</events_scheduled>
      <first_event_date>2022-08-16</first_event_date>
      <last_event_date>2023-12-08</last_event_date>
      <min_event_tickets>500</min_event_tickets>
      <max_event_tickets>500</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>7</venue_id>
      <venue_name>Pearl Nightclub</venue_name>
      <organizer_name>Gina Andrews</organizer_name>
      <organizer_email>Gina.Andrews@PearlNightclub.com</organizer_email>
      <max_event_capacity>1000</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>111</events_scheduled>
      <first_event_date>2022-08-16</first_event_date>
      <last_event_date>2024-02-23</last_event_date>
      <min_event_tickets>1000</min_event_tickets>
      <max_event_tickets>1000</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>1</venue_id>
      <venue_name>City Stadium</venue_name>
      <organizer_name>Erin Johanson</organizer_name>
      <organizer_email>Erin.Johanson@CityStadium.com</organizer_email>
      <max_event_capacity>20000</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>47</events_scheduled>
      <first_event_date>2022-08-13</first_event_date>
      <last_event_date>2023-08-30</last_event_date>
      <min_event_tickets>5000</min_event_tickets>
      <max_event_tickets>20000</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>2</venue_id>
      <venue_name>Clockworks</venue_name>
      <organizer_name>Juliette Rivera</organizer_name>
      <organizer_email>Juliette.Rivera@Clockworks.com</organizer_email>
      <max_event_capacity>2000</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>15</events_scheduled>
      <first_event_date>2022-09-16</first_event_date>
      <last_event_date>2023-02-03</last_event_date>
      <min_event_tickets>2000</min_event_tickets>
      <max_event_tickets>2000</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>3</venue_id>
      <venue_name>Club 11</venue_name>
      <organizer_name>Mary Rivera</organizer_name>
      <organizer_email>Mary.Rivera@Club11.com</organizer_email>
      <max_event_capacity>500</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>115</events_scheduled>
      <first_event_date>2022-08-16</first_event_date>
      <last_event_date>2023-04-22</last_event_date>
      <min_event_tickets>500</min_event_tickets>
      <max_event_tickets>500</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>5</venue_id>
      <venue_name>Crystal Ballroom</venue_name>
      <organizer_name>Rudolph Racine</organizer_name>
      <organizer_email>Rudolph.Racine@CrystalBallroom.com</organizer_email>
      <max_event_capacity>2000</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>17</events_scheduled>
      <first_event_date>2022-10-07</first_event_date>
      <last_event_date>2023-09-23</last_event_date>
      <min_event_tickets>2000</min_event_tickets>
      <max_event_tickets>2000</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>8</venue_id>
      <venue_name>The Ampitheatre</venue_name>
      <organizer_name>Max Johnson</organizer_name>
      <organizer_email>Max.Johnson@TheAmpitheatre.com</organizer_email>
      <max_event_capacity>10000</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>21</events_scheduled>
      <first_event_date>2022-10-28</first_event_date>
      <last_event_date>2024-05-11</last_event_date>
      <min_event_tickets>10000</min_event_tickets>
      <max_event_tickets>10000</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>9</venue_id>
      <venue_name>The Right Spot</venue_name>
      <organizer_name>Carol Zaxby</organizer_name>
      <organizer_email>Carol.Zaxby@TheRightSpot.com</organizer_email>
      <max_event_capacity>2000</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>16</events_scheduled>
      <first_event_date>2022-11-04</first_event_date>
      <last_event_date>2024-07-27</last_event_date>
      <min_event_tickets>2000</min_event_tickets>
      <max_event_tickets>2000</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>81</venue_id>
      <venue_name>Another Roadside Attraction</venue_name>
      <organizer_name>Susan Brewer</organizer_name>
      <organizer_email>Susan.Brewer@AnotherRoadsideAttraction.com</organizer_email>
      <max_event_capacity>500</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>2</events_scheduled>
      <first_event_date>2022-12-31</first_event_date>
      <last_event_date>2023-12-31</last_event_date>
      <min_event_tickets>400</min_event_tickets>
      <max_event_tickets>400</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>82</venue_id>
      <venue_name>The Pink Pony Revue</venue_name>
      <organizer_name>Julia Stone</organizer_name>
      <organizer_email>Julia.Stone@ThePinkPonyRevue.com</organizer_email>
      <max_event_capacity>400</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>0</events_scheduled>
      <min_event_tickets>0</min_event_tickets>
      <max_event_tickets>0</max_event_tickets>
    </event_summary>
  </venue_summary>
  <venue_summary>
    <venue>
      <venue_id>67</venue_id>
      <venue_name>Roadside Cafe</venue_name>
      <organizer_name>Billy Styles</organizer_name>
      <organizer_email>Billy.Styles@RoadsideCafe.com</organizer_email>
      <max_event_capacity>400</max_event_capacity>
    </venue>
    <event_summary>
      <events_scheduled>0</events_scheduled>
      <min_event_tickets>0</min_event_tickets>
      <max_event_tickets>0</max_event_tickets>
    </event_summary>
  </venue_summary>
</all_venues_summary>



PL/SQL procedure successfully completed.



*/