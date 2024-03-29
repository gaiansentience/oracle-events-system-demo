--get all resellers as a json document
set serveroutput on;
declare
    l_json json;
begin

    l_json := events_json_api.get_all_resellers(p_formatted => true);
    dbms_output.put_line(events_json_api.json_as_clob(l_json));

 end;

/*
[
  {
    "reseller_id" : 21,
    "reseller_name" : "New Wave Tickets",
    "reseller_email" : "tickets@NewWaveTickets.com",
    "commission_percent" : 0.1414
  },
  {
    "reseller_id" : 1,
    "reseller_name" : "Events For You",
    "reseller_email" : "ticket.sales@EventsForYou.com",
    "commission_percent" : 0.1198
  },
  {
    "reseller_id" : 2,
    "reseller_name" : "MaxTix",
    "reseller_email" : "ticket.sales@MaxTix.com",
    "commission_percent" : 0.1119
  },
  {
    "reseller_id" : 3,
    "reseller_name" : "Old School",
    "reseller_email" : "ticket.sales@OldSchool.com",
    "commission_percent" : 0.1337
  },
  {
    "reseller_id" : 4,
    "reseller_name" : "Source Tix",
    "reseller_email" : "ticket.sales@SourceTix.com",
    "commission_percent" : 0.1322
  },
  {
    "reseller_id" : 5,
    "reseller_name" : "The Source",
    "reseller_email" : "ticket.sales@TheSource.com",
    "commission_percent" : 0.1214
  },
  {
    "reseller_id" : 6,
    "reseller_name" : "Ticket Supply",
    "reseller_email" : "ticket.sales@TicketSupply.com",
    "commission_percent" : 0.1163
  },
  {
    "reseller_id" : 7,
    "reseller_name" : "Ticket Time",
    "reseller_email" : "ticket.sales@TicketTime.com",
    "commission_percent" : 0.1434
  },
  {
    "reseller_id" : 8,
    "reseller_name" : "Ticketron",
    "reseller_email" : "ticket.sales@Ticketron.com",
    "commission_percent" : 0.1474
  },
  {
    "reseller_id" : 9,
    "reseller_name" : "Tickets 2 Go",
    "reseller_email" : "ticket.sales@Tickets2Go.com",
    "commission_percent" : 0.1385
  },
  {
    "reseller_id" : 10,
    "reseller_name" : "Tickets R Us",
    "reseller_email" : "ticket.sales@TicketsRUs.com",
    "commission_percent" : 0.1393
  },
  {
    "reseller_id" : 11,
    "reseller_name" : "Your Ticket Supplier",
    "reseller_email" : "ticket.sales@YourTicketSupplier.com",
    "commission_percent" : 0.129
  },
  {
    "reseller_id" : 73,
    "reseller_name" : "Easy Tickets",
    "reseller_email" : "tickets@EasyTickets.com",
    "commission_percent" : 0.0909
  },
  {
    "reseller_id" : 81,
    "reseller_name" : "Ticket Factory",
    "reseller_email" : "sales@TicketFactory.com",
    "commission_percent" : 0.125
  }
]
*/