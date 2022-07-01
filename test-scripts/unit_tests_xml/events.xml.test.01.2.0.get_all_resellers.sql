set serveroutput on;
DECLARE
  P_RESELLER_ID NUMBER;
  P_FORMATTED BOOLEAN;
  v_Return XMLTYPE;
BEGIN
  P_RESELLER_ID := 1;
  P_FORMATTED := true;

  v_Return := EVENTS_XML_API.GET_RESELLER(
    P_RESELLER_ID => P_RESELLER_ID,
    P_FORMATTED => P_FORMATTED
  );

DBMS_OUTPUT.PUT_LINE(v_Return.getstringval);

END;

/*
<reseller>
  <reseller_id>1</reseller_id>
  <reseller_name>Events For You</reseller_name>
  <reseller_email>ticket.sales@EventsForYou.com</reseller_email>
  <commission_percent>.1461</commission_percent>
</reseller>
*/