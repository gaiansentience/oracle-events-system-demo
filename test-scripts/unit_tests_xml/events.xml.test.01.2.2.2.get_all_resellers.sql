set serveroutput on;
declare
  l_xml xmltype;
begin

    l_xml := events_xml_api.get_all_resellers(p_formatted => true);

    dbms_output.put_line(l_xml.getstringval);

end;

/*
<all_resellers>
  <reseller>
    <reseller_id>21</reseller_id>
    <reseller_name>New Wave Tickets</reseller_name>
    <reseller_email>ticket.sales@NewWaveTickets.com</reseller_email>
    <commission_percent>.1313</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>1</reseller_id>
    <reseller_name>Events For You</reseller_name>
    <reseller_email>ticket.sales@EventsForYou.com</reseller_email>
    <commission_percent>.1198</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>2</reseller_id>
    <reseller_name>MaxTix</reseller_name>
    <reseller_email>ticket.sales@MaxTix.com</reseller_email>
    <commission_percent>.1119</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>3</reseller_id>
    <reseller_name>Old School</reseller_name>
    <reseller_email>ticket.sales@OldSchool.com</reseller_email>
    <commission_percent>.1337</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>4</reseller_id>
    <reseller_name>Source Tix</reseller_name>
    <reseller_email>ticket.sales@SourceTix.com</reseller_email>
    <commission_percent>.1322</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>5</reseller_id>
    <reseller_name>The Source</reseller_name>
    <reseller_email>ticket.sales@TheSource.com</reseller_email>
    <commission_percent>.1214</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>6</reseller_id>
    <reseller_name>Ticket Supply</reseller_name>
    <reseller_email>ticket.sales@TicketSupply.com</reseller_email>
    <commission_percent>.1163</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>7</reseller_id>
    <reseller_name>Ticket Time</reseller_name>
    <reseller_email>ticket.sales@TicketTime.com</reseller_email>
    <commission_percent>.1434</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>8</reseller_id>
    <reseller_name>Ticketron</reseller_name>
    <reseller_email>ticket.sales@Ticketron.com</reseller_email>
    <commission_percent>.1474</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>9</reseller_id>
    <reseller_name>Tickets 2 Go</reseller_name>
    <reseller_email>ticket.sales@Tickets2Go.com</reseller_email>
    <commission_percent>.1385</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>10</reseller_id>
    <reseller_name>Tickets R Us</reseller_name>
    <reseller_email>ticket.sales@TicketsRUs.com</reseller_email>
    <commission_percent>.1393</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>11</reseller_id>
    <reseller_name>Your Ticket Supplier</reseller_name>
    <reseller_email>ticket.sales@YourTicketSupplier.com</reseller_email>
    <commission_percent>.129</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>12</reseller_id>
    <reseller_name>Easy Tickets</reseller_name>
    <reseller_email>tickets@EasyTickets.com</reseller_email>
    <commission_percent>.0909</commission_percent>
  </reseller>
  <reseller>
    <reseller_id>41</reseller_id>
    <reseller_name>Ticket Factory</reseller_name>
    <reseller_email>sales@TicketFactory.com</reseller_email>
    <commission_percent>.125</commission_percent>
  </reseller>
</all_resellers>

*/