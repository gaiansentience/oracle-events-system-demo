set serveroutput on;
DECLARE
  P_XML_DOC XMLTYPE;
  l_xml varchar2(4000);
BEGIN

l_xml := 
'
<create_event>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Review</venue_name>
  </venue>
  <event_name>Evangeline Thorpe</event_name>
  <event_date>2023-05-01</event_date>
  <tickets_available>200</tickets_available>
</create_event>
';
p_xml_doc := xmltype(l_xml);

  EVENTS_XML_API.CREATE_EVENT(
    P_XML_DOC => P_XML_DOC
  );

DBMS_OUTPUT.PUT_LINE(P_XML_DOC.getstringval);

END;

/*
<create_event>
  <venue>
    <venue_id>21</venue_id>
    <venue_name>The Pink Pony Review</venue_name>
  </venue>
  <event_name>Evangeline Thorpe</event_name>
  <event_date>2023-05-01</event_date>
  <tickets_available>200</tickets_available>
  <event_id>343</event_id>
  <status_code>SUCCESS</status_code>
  <status_message>Created event</status_message>
</create_event>
*/
