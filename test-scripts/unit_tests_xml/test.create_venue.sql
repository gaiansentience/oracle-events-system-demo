set serveroutput on;
DECLARE
  P_XML_DOC XMLTYPE;
  l_xml varchar2(1000);
BEGIN

l_xml :=
'
<venue>
  <venue_name>The Pink Pony Revue</venue_name>
  <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
  <organizer_name>Julia Stein</organizer_name>
  <max_event_capacity>200</max_event_capacity>
</venue>
';
P_xml_doc := xmltype(l_xml);

  EVENTS_XML_API.CREATE_VENUE(
    P_XML_DOC => P_XML_DOC
  );

DBMS_OUTPUT.PUT_LINE(P_XML_DOC.getstringval);

END;

/*
<venue>
  <venue_name>The Pink Pony Revue</venue_name>
  <organizer_email>Julia.Stein@ThePinkPonyRevue.com</organizer_email>
  <organizer_name>Julia Stein</organizer_name>
  <max_event_capacity>200</max_event_capacity>
  <venue_id>21</venue_id>
  <status_code>SUCCESS</status_code>
  <status_message>Created venue</status_message>
</venue>
*/
