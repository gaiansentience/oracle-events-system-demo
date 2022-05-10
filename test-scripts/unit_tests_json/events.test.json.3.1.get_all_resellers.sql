--get all resellers as a json document
set serveroutput on;
declare
  v_json_doc clob;
begin

   v_json_doc := events_json_api.get_all_resellers(p_formatted => true);
   
   dbms_output.put_line(v_json_doc);

 end;

/*
[
  {
    "reseller_id" : 1,
    "reseller_name" : "Events For You",
    "reseller_email" : "ticket.sales@EventsForYou.com"
  },
  {
    "reseller_id" : 2,
    "reseller_name" : "MaxTix",
    "reseller_email" : "ticket.sales@MaxTix.com"
  },
  {
    "reseller_id" : 3,
    "reseller_name" : "Old School",
    "reseller_email" : "ticket.sales@OldSchool.com"
  },
  {
    "reseller_id" : 4,
    "reseller_name" : "Source Tix",
    "reseller_email" : "ticket.sales@SourceTix.com"
  },
  {
    "reseller_id" : 5,
    "reseller_name" : "The Source",
    "reseller_email" : "ticket.sales@TheSource.com"
  },
  {
    "reseller_id" : 6,
    "reseller_name" : "Ticket Supply",
    "reseller_email" : "ticket.sales@TicketSupply.com"
  },
  {
    "reseller_id" : 7,
    "reseller_name" : "Ticket Time",
    "reseller_email" : "ticket.sales@TicketTime.com"
  },
  {
    "reseller_id" : 8,
    "reseller_name" : "Ticketron",
    "reseller_email" : "ticket.sales@Ticketron.com"
  },
  {
    "reseller_id" : 9,
    "reseller_name" : "Tickets 2 Go",
    "reseller_email" : "ticket.sales@Tickets2Go.com"
  },
  {
    "reseller_id" : 10,
    "reseller_name" : "Tickets R Us",
    "reseller_email" : "ticket.sales@TicketsRUs.com"
  },
  {
    "reseller_id" : 11,
    "reseller_name" : "Your Ticket Supplier",
    "reseller_email" : "ticket.sales@YourTicketSupplier.com"
  },
  {
    "reseller_id" : 24,
    "reseller_name" : "Future Event Tickets",
    "reseller_email" : "ticket.sales@ContemporaryEvents.com"
  }
]
*/